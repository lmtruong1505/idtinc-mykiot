import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/warehouse_entity.dart';

part 'warehouse_edit_state.freezed.dart';


@freezed
class WarehouseEditState with _$WarehouseEditState {
  const factory WarehouseEditState({
    @Default(false) bool isLoading,
    WarehouseEntity? warehouseEntity,
  }) = _WarehouseEditState;
}
