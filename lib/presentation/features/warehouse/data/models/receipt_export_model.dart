import 'package:pharmago/presentation/features/warehouse/data/models/warehouse_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

import '../../../../features_v2/models/customer/v2/user_model.dart';
import '../../domain/entities/receipt_export_entity.dart';
import 'shipment_data_model.dart';

class ReceiptExportModel extends ReceiptExportEntity {
  ReceiptExportModel({
    super.id,
    super.code,
    super.reason,
    super.warehouse,
    super.status,
    super.totalPrice,
    super.userCreated,
    super.userUpdated,
    super.createdAt,
    super.updatedAt,
    // super.warehouseData,
    super.statusData,
    super.order,
    super.userCreatedData,
    super.userUpdatedData,
  });

  factory ReceiptExportModel.fromJson(Map<String, dynamic> json) =>
      ReceiptExportModel(
        id: json['id'],
        code: json['code'],
        reason: json['reason'],
        warehouse: json['warehouse'],
        status: json['status'],
        totalPrice: json['total_price'],
        userCreated: json['user_created'],
        userUpdated: json['user_updated'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        // warehouseData: json['warehouse_data'] == null
        //     ? null
        //     : WarehouseModel.fromJson(json['warehouse_data']),
        statusData: json['status_data'] == null
            ? null
            : ReceiptStatusModel.fromJson(json['status_data']),
        order: json['order'],
        userCreatedData: json['user_created_data'] == null
            ? null
            : UserV2Model.fromJson(json['user_created_data']),
        userUpdatedData: json['user_updated_data'] == null
            ? null
            : UserV2Model.fromJson(json['user_updated_data']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'reason': reason,
        'warehouse': warehouse,
        'status': status,
        'total_price': totalPrice,
        'user_created': userCreated,
        'user_updated': userUpdated,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        // 'warehouse_data': warehouseData?.toJson(),
        'status_data': (statusData as ReceiptStatusModel?)?.toJson(),
        'order': order,
        'user_created_data': userCreatedData?.toJson(),
        'user_updated_data': userUpdatedData?.toJson(),
      };
}

class ReceiptStatusModel extends ReceiptStatusEntity {
  ReceiptStatusModel({
    super.id,
    super.title,
    super.code,
  });

  factory ReceiptStatusModel.fromJson(Map<String, dynamic> json) =>
      ReceiptStatusModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
      };
}

class ReceiptItemModel extends ReceiptItemEntity {
  ReceiptItemModel({
    super.id,
    super.exportUnit,
    super.exportNumber,
    super.exportPrice,
    super.totalExportPrice,
    super.variant,
    super.shipment,
    super.createdAt,
    super.shipmentData,
    super.exportUnitData,
    super.productData,
  });

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) =>
      ReceiptItemModel(
        id: json['id'],
        exportUnit: json['export_unit'],
        exportNumber: json['export_number'],
        exportPrice: json['export_price'],
        totalExportPrice: json['total_export_price'],
        variant: json['variant'],
        shipment: json['shipment'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        shipmentData: json['shipment_data'] == null
            ? null
            : ShipmentItemModel.fromJson(json['shipment_data']),
        exportUnitData: json['export_unit_data'],
        productData: json['product_data'] == null
            ? null
            : ProductV2Model.fromJson(json['product_data']),
      );
}
