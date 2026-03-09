import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_detail_v2_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/product/product_v2_repository.dart';

import '../../../../data/models/base/response.dart';
import '../../models/product/unit_v2_model.dart';
import 'params/warehouse_import_param.dart';

class ProductDetailBloc extends Cubit<CubitState> {
  ProductDetailBloc() : super(CubitState());

  final repo = ProductV2Repository();

  ProductDetailV2Model? _model ;
  ProductDetailV2Model? get model => _model;

  Future<void> init(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await repo.getDetailProd(id: id);
    if(res.code == 200) {
      _model = res.data;
      emit(state.copyWith(status: BlocStatus.success));
    } else {
      emit(state.copyWith(status: BlocStatus.failure, msg: res.message));
    }
  }

  UnitV2Model? get baseUnit {
    if(_model != null) {
      return _model!.product?.unit.firstWhere((element) => element.sellUnit == true);
    }
    return null;
  }

  Future<BaseResponseModel> changeStatus(bool active, int id) {
    final Map<String, dynamic> payload = {};
    payload['product'] = jsonEncode({'active': active});
    return repo.update(id: id, payload: payload);
  }

  Future<BaseResponseModel>delete(int id) {
    return repo.delete(id: id);
  }

  Future<BaseResponseModel> warehouseImport(WarehouseImportParam param) {
      final payload = param.toJson();
      return repo.warehouseImport(payload: payload);
  }
}