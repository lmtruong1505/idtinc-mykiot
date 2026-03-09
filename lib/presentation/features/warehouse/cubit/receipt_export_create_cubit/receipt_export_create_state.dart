import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

import '../../../../features_v2/models/employee/user_data_model.dart';
import '../../data/models/warehouse_model.dart';
import 'package:collection/collection.dart';

part 'receipt_export_create_state.freezed.dart';

@freezed
class ReceiptExportCreateState with _$ReceiptExportCreateState {
  const factory ReceiptExportCreateState({
    @Default(0) int indexTab,
    @Default([]) List<WarehouseModel> listWareHouse,
    @Default([]) List<UserDataModel> listUser,
    WarehouseModel? warehouse,
    UserDataModel? userCheck,
    @Default('') String codeReceipt,
    DateTime? dateExport,
    @Default('') String reasonExport,
    @Default([]) List<ProductV2Model> products,
    String? errMessage,
  }) = _ReceiptExportCreateState;
}

extension ReceiptExportCreateStateGet on ReceiptExportCreateState {
  num get totalPrice {
    return products.fold(0, (total, e) {
      final shipment = e.shipment?.data?.firstWhereOrNull((e) => e.isSelected);
      if (shipment != null) {
        final sellPrice = e.unitSell?.sellPrice ?? 0;
        total += sellPrice * shipment.selectedQuantity;
      }
      return total;
    },);
  }
}
