import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_shipments_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/shipments_infor_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/product/product_v2_repository.dart';

class ProductShipmentsBloc extends Cubit<CubitState> {
  ProductShipmentsBloc() : super(CubitState());

  final repo = ProductV2Repository();

  List<ProductShipmentsModel> list = [];

  ShipmentsInforModel? shipmentsInfor;

  Future<void> init(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await repo.getProdShipments(id: id);
    if (res.code == 200) {
      list = res.data ?? [];
      shipmentsInfor = res.extra;

      emit(state.copyWith(status: BlocStatus.success));
    } else {
      emit(state.copyWith(status: BlocStatus.failure, msg: res.message));
    }
  }
}
