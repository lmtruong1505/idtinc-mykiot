import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecase/warehouse_detail_use_case.dart';
import '../../domain/usecase/warehouse_product_use_case.dart';
import 'warehouse_detail_state.dart';

@injectable
class WarehouseDetailCubit extends Cubit<WarehouseDetailState> {
  WarehouseDetailCubit(
    this._warehouseDetailUseCase,
    this._warehouseProductUseCase,
  ) : super(const WarehouseDetailState());

  final WarehouseDetailUseCase _warehouseDetailUseCase;
  final WarehouseProductUseCase _warehouseProductUseCase;

  void init(int id) async {
    await getDetail(id);
    getProductWarehouse();
  }

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = WarehouseDetailInput(id: id);
    final res = await _warehouseDetailUseCase.execute(input);
    emit(
      state.copyWith(
        warehouseEntity: res.response.data,
        isLoading: false,
      ),
    );
  }

  Future<void> getProductWarehouse() async {
    if (state.warehouseEntity?.id == null) return;
    emit(state.copyWith(isLoading: true));
    final input = WarehouseProductInput(id: state.warehouseEntity!.id);
    final res = await _warehouseProductUseCase.execute(input);
    emit(
      state.copyWith(
        productWarehouse: res.response.data,
        isLoading: false,
      ),
    );
  }
}
