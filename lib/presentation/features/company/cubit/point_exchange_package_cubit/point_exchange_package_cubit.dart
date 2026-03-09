import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';

import '../../../../features_v2/models/product/product_v2_model.dart';
import '../../data/models/point_exchange_package_model.dart';
import '../../data/models/point_exchange_package_payload_model.dart';
import '../../domain/repositories/company_repository.dart';
import 'point_exchange_package_state.dart';

@injectable
class PointExchangePackageCubit extends Cubit<PointExchangePackageState> {
  PointExchangePackageCubit(
    this._companyRepository,
  ) : super(const PointExchangePackageState());

  final CompanyRepository _companyRepository;

  void stateChange({
    int? point,
    String? name,
    String? note,
  }) {
    emit(
      state.copyWith(
        point: point ?? state.point,
        name: name ?? state.name,
        note: note ?? state.note,
      ),
    );
  }

  Future<PointExchangePackageModel?> createHandle(List<ProductV2Model> products) async {
    final payload = PointExchangePackagePayload(
      point: state.point,
      name: state.name,
      note: state.note,
      status: true,
      workspace: getCompanyId,
      items: products
          .map(
            (e) => Item(
              productId: e.id,
              quantity: e.quantity,
              unitId: e.unitData?.id ?? e.unitSell?.id,
            ),
          )
          .toList(),
    );
    final res = await _companyRepository.createPointExchangePackage(payload);
    return res.data;
  }
}
