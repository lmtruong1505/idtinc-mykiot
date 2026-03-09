import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/params/warehouse_import_param.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../data/models/base/response.dart';
import '../../repositories/product/product_v2_repository.dart';

class WarehouseBloc extends Cubit<CubitState> {
  WarehouseBloc() : super(CubitState());

  final repo = ProductV2Repository();

  ProductV2Model? _model;
  ProductV2Model? get model => _model;
  set model(ProductV2Model? value) {
    _model = value;
  }

  int get heso {
    final units = _model?.unit ?? [];
    units.sort(
      (a, b) => a.level.validator.compareTo(b.level.validator),
    );
    for (int i = units.length - 1; i >= 0; i--) {
      if (units[i].sellUnit == true) {
        final int index = i + 1;
        if (index >= units.length) {
          return units[i].value ?? 1;
        }
        return units.sublist(i + 1).fold(
          1,
          (previousValue, element) {
            if (element.value.validator < 1) {
              return previousValue;
            }
            return previousValue * element.value!;
          },
        );
      }
    }

    return 1;
  }

  Future<BaseResponseModel> warehouseImport(WarehouseImportParam param) async {
    param.initialStock = (param.initialStock ?? 0) * heso;
    final payload = param.toJson();

    return repo.warehouseImport(payload: payload);
  }
}
