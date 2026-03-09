import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/warehouse_model.dart';
import '../../domain/entities/receipt_export_entity.dart';

part 'receipt_export_manager_state.freezed.dart';

@freezed
class ReceiptExportManagerState with _$ReceiptExportManagerState {
  const factory ReceiptExportManagerState({
    ReceiptExportEntity? receipt,
    @Default([]) List<ReceiptItemEntity> receiptItems,
    @Default(<ReceiptExportEntity>[]) List<ReceiptExportEntity> receipts,
    @Default([]) List<WarehouseModel> listWareHouse,
    @Default(true) bool isLoadingListWareHouse,
    WarehouseModel? warehouse,
    @Default(20) int limit,
    @Default(0) int page,
    @Default('') String search,
    @Default(true) bool canLoadMore,
    @Default(true) bool isLoadMore,
  }) = _ReceiptExportManagerState;
}

extension ReceiptExportManagerStateGet on ReceiptExportManagerState {
  List<Widget> get getTabs {
    return listWareHouse
        .map(
          (e) => Tab(
            text: e.title,
          ),
        )
        .toList();
  }
}
