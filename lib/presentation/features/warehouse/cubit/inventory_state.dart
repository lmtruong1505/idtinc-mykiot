import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_state.freezed.dart';

@freezed
class InventoryState with _$InventoryState {
  const factory InventoryState({
    @Default('') String search,
    @Default(10) int limit,
    @Default(0) int warehouseId,
    @Default([]) List<DropdownMenuItem> warehouseDrops,
  }) = _InventoryState;
}
