import 'package:pharmago/presentation/features/warehouse/domain/entities/shipment_data_entity.dart';

import '../../../../features_v2/models/product/product_v2_model.dart';

class ShipmentDataModel extends ShipmentDataEntity {
  ShipmentDataModel({
    super.message,
    super.code,
    super.data,
    super.count,
    super.bonus,
  });

  factory ShipmentDataModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDataModel(
        message: json['message'],
        code: json['code'],
        data: json['data'] == null
            ? []
            : List<ShipmentItemModel>.from(
                json['data']!.map((x) => ShipmentItemModel.fromJson(x))),
        count: json['count'],
        bonus: json['bonus'] == null
            ? null
            : ShipmentDataBonusModel.fromJson(json['bonus']),
      );
}

class ShipmentDataBonusModel extends ShipmentDataBonusEntity {
  ShipmentDataBonusModel({
    super.totalShipmentNearDate,
    super.quantityNearDate,
    super.quantityExpDate,
    super.quantityInventory,
  });

  factory ShipmentDataBonusModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDataBonusModel(
        totalShipmentNearDate: json['total_shipment_near_date'],
        quantityNearDate: json['quantity_near_date'],
        quantityExpDate: json['quantity_exp_date'],
        quantityInventory: json['quantity_inventory'],
      );
}

class ShipmentItemModel extends ShipmentItemEntity {
  ShipmentItemModel({
    super.id,
    super.code,
    super.storageQuantity,
    super.currentQuantity,
    super.importPrice,
    super.totalImportPrice,
    super.totalMoney,
    super.vat,
    super.discount,
    super.variant,
    super.storageUnit,
    super.inputUnit,
    super.inputQuantity,
    super.startDate,
    super.endDate,
    super.typeItemsId,
    super.warehouseImportId,
    super.importReceiptId,
    super.slotId,
    super.userCreated,
    super.userUpdated,
    super.createdAt,
    super.updatedAt,
    super.daysRemaining,
    super.importReceiptData,
    super.status,
    super.statusLabel,
    super.productData,
    super.inputUnitData,
    super.storageUnitData,
    super.product,
    super.typeWarehouse,
  });

  factory ShipmentItemModel.fromJson(Map<String, dynamic> json) =>
      ShipmentItemModel(
        id: json['id'],
        code: json['code'],
        storageQuantity: json['storage_quantity'],
        currentQuantity: json['current_quantity'],
        importPrice: json['import_price'],
        totalImportPrice: json['total_import_price'],
        totalMoney: json['total_money'],
        vat: json['vat'],
        discount: json['discount'],
        variant: json['variant'],
        storageUnit: json['storage_unit'],
        inputUnit: json['input_unit'],
        inputQuantity: json['input_quantity'],
        startDate: json['start_date'] == null
            ? null
            : DateTime.parse(json['start_date']),
        endDate:
            json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        typeItemsId: json['type_items_id'],
        warehouseImportId: json['warehouse_import_id'],
        importReceiptId: json['import_receipt_id'],
        slotId: json['slot_id'],
        userCreated: json['user_created'],
        userUpdated: json['user_updated'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        daysRemaining: json['days_remaining'],
        importReceiptData: json['import_receipt_data'] == null
            ? null
            : ImportReceiptModel.fromJson(json['import_receipt_data']),
        status: json['status'],
        statusLabel: json['status_label'],
        product: json['product_data'] == null
            ? null
            : ShipmentItemProductModel.fromJson(json['product_data']),
        productData: json['product_data'] == null
            ? null
            : ProductV2Model.fromJson(json['product_data']),
        inputUnitData: json['input_unit_data'],
        storageUnitData: json['storage_unit_data'],
        typeWarehouse: json['type_warehouse'] == null
            ? null
            : ShipmentItemTypeWarehouseModel.fromJson(json['type_warehouse']),
      );
}

class ShipmentItemProductModel extends ShipmentItemProduct {
  ShipmentItemProductModel({
    super.id,
    super.productName,
  });

  factory ShipmentItemProductModel.fromJson(Map<String, dynamic> json) =>
      ShipmentItemProductModel(
        id: json['id'],
        productName: json['product_name'],
      );
}

class ImportReceiptModel extends ImportReceiptEntity {
  ImportReceiptModel({
    super.id,
    super.code,
  });

  factory ImportReceiptModel.fromJson(Map<String, dynamic> json) =>
      ImportReceiptModel(
        id: json['id'],
        code: json['code'],
      );
}

class ShipmentItemTypeWarehouseModel extends ShipmentItemTypeWarehouse {
  ShipmentItemTypeWarehouseModel({
    super.id,
    super.title,
    super.code,
  });

  factory ShipmentItemTypeWarehouseModel.fromJson(Map<String, dynamic> json) =>
      ShipmentItemTypeWarehouseModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
      );
}
