import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/warehouse_model.dart';
import '../../domain/entities/shipment_data_entity.dart';

part 'shipment_manager_state.freezed.dart';

@freezed
class ShipmentManagerState with _$ShipmentManagerState {
  const factory ShipmentManagerState({
    @Default(20) int limit,
    @Default(0) int page,
    @Default([]) List<ShipmentItemEntity> list,
    @Default('') String search,
    WarehouseModel? warehouse,
    @Default([]) List<WarehouseModel> listWareHouse,
    @Default(true) bool isLoadingListWareHouse,
    @Default(true) bool canLoadMore,
    @Default(false) bool isLoadMore,
  }) = _ShipmentManagerState;
}
