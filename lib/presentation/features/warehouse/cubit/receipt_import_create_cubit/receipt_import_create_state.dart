
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../features_v2/models/employee/user_data_model.dart';
import '../../data/models/receipt_import_model.dart';
import '../../data/models/warehouse_model.dart';
import '../../domain/entities/shipment_data_entity.dart';

part 'receipt_import_create_state.freezed.dart';

@freezed
class ReceiptImportCreateState with _$ReceiptImportCreateState {
  const factory ReceiptImportCreateState({
    @Default(0) int indexTab,
    @Default([]) List<WarehouseModel> listWareHouse,
    @Default([]) List<UserDataModel> listUser,
    WarehouseModel? warehouse,
    UserDataModel? userCheck,
    DateTime? dateImport,
    String? provider,
    @Default('') String reason,
    @Default([]) List<ShipmentItemEntity> shipments,
    String? errMessage,
    ReceitExportModel? receiptDetail,
    @Default([]) List<int> fileDelete,
    @Default([]) List<int> shipmentDelete,
  }) = _ReceiptImportCreateState;
}

extension ReceiptImportCreateStateGet on ReceiptImportCreateState {
  num get totalPrice {
    return shipments.fold(0, (total, e) {
      total += e.totalMoneyAfterVat;
      return total;
    },);
  }
}
