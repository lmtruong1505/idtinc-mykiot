import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/ticket_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';

part 'ticket_create_state.freezed.dart';

@freezed
class TicketCreateState with _$TicketCreateState {
  const factory TicketCreateState({
    @Default('') String search,
    @Default(10) int limit,
    @Default('') String code,
    @Default('') String note,
    @Default(0) int supplierId,
    @Default(0) int warehouseId,
    @Default([]) List<int> idSelecteds,
    @Default([]) List<VariantWarehouseEntity> variants,
    @Default([]) List<WarehouseEntity> warehouses,
    @Default([]) List<DropdownMenuItem> warehouseDrops,
    TicketEntity? ticket,
  }) = _TicketCreateState;
}
