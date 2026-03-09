import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model_v2.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/screens/warehourse_list_page_v2.dart';

part 'warehouse_state.freezed.dart';

@freezed
class WarehouseState with _$WarehouseState {
  const factory WarehouseState({
    @Default(0) int tabSelected,
    @Default(0) int timeFilterIndex,
    @Default('') String search,
    @Default(10) int limit,
    @Default(0) int total,
    @Default([]) List<InventoryModelV2> inventories,
    @Default([]) List<WarehouseModel> listWareHouse,
    FilterButtonModel? filter,
    WarehouseModel? warehouseSelect,
    @Default(false) bool isLoading,
  }) = _WarehouseState;
}
