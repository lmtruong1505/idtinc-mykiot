import 'package:pharmago/presentation/features/warehouse/domain/entities/shipment_data_entity.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

import '../../../../features_v2/models/customer/v2/user_model.dart';
import '../../data/models/warehouse_model.dart';

class ReceiptExportEntity {
  final int? id;
  final String? code;
  final String? reason;
  final int? warehouse;
  final int? status;
  final num? totalPrice;
  final int? userCreated;
  final int? userUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final WarehouseModel? warehouseData;
  final ReceiptStatusEntity? statusData;
  final dynamic order;
  final UserV2Model? userCreatedData;
  final UserV2Model? userUpdatedData;

  ReceiptExportEntity({
    this.id,
    this.code,
    this.reason,
    this.warehouse,
    this.status,
    this.totalPrice,
    this.userCreated,
    this.userUpdated,
    this.createdAt,
    this.updatedAt,
    // this.warehouseData,
    this.statusData,
    this.order,
    this.userCreatedData,
    this.userUpdatedData,
  });

  ReceiptExportEntity copyWith({
    int? id,
    String? code,
    String? reason,
    int? warehouse,
    int? status,
    int? totalPrice,
    int? userCreated,
    int? userUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
    WarehouseModel? warehouseData,
    ReceiptStatusEntity? statusData,
    dynamic order,
    UserV2Model? userCreatedData,
    UserV2Model? userUpdatedData,
  }) =>
      ReceiptExportEntity(
        id: id ?? this.id,
        code: code ?? this.code,
        reason: reason ?? this.reason,
        warehouse: warehouse ?? this.warehouse,
        status: status ?? this.status,
        totalPrice: totalPrice ?? this.totalPrice,
        userCreated: userCreated ?? this.userCreated,
        userUpdated: userUpdated ?? this.userUpdated,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        // warehouseData: warehouseData ?? this.warehouseData,
        statusData: statusData ?? this.statusData,
        order: order ?? this.order,
        userCreatedData: userCreatedData ?? this.userCreatedData,
        userUpdatedData: userUpdatedData ?? this.userUpdatedData,
      );
}

class ReceiptStatusEntity {
  final int? id;
  final String? title;
  final String? code;

  ReceiptStatusEntity({
    this.id,
    this.title,
    this.code,
  });

  ReceiptStatusEntity copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      ReceiptStatusEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );
}

class ReceiptItemEntity {
    final int? id;
    final int? exportUnit;
    final num? exportNumber;
    final num? exportPrice;
    final num? totalExportPrice;
    final int? variant;
    final int? shipment;
    final DateTime? createdAt;
    final ShipmentItemEntity? shipmentData;
    final String? exportUnitData;
    final ProductV2Model? productData;

    ReceiptItemEntity({
        this.id,
        this.exportUnit,
        this.exportNumber,
        this.exportPrice,
        this.totalExportPrice,
        this.variant,
        this.shipment,
        this.createdAt,
        this.shipmentData,
        this.exportUnitData,
        this.productData,
    });

    ReceiptItemEntity copyWith({
        int? id,
        int? exportUnit,
        int? exportNumber,
        int? exportPrice,
        int? totalExportPrice,
        int? variant,
        int? shipment,
        DateTime? createdAt,
        ShipmentItemEntity? shipmentData,
        String? exportUnitData,
        ProductV2Model? productData,
    }) => 
        ReceiptItemEntity(
            id: id ?? this.id,
            exportUnit: exportUnit ?? this.exportUnit,
            exportNumber: exportNumber ?? this.exportNumber,
            exportPrice: exportPrice ?? this.exportPrice,
            totalExportPrice: totalExportPrice ?? this.totalExportPrice,
            variant: variant ?? this.variant,
            shipment: shipment ?? this.shipment,
            createdAt: createdAt ?? this.createdAt,
            shipmentData: shipmentData ?? this.shipmentData,
            exportUnitData: exportUnitData ?? this.exportUnitData,
            productData: productData ?? this.productData,
        );

    Map<String, dynamic> toJson() => {
        'id': id,
        'export_unit': exportUnit,
        'export_number': exportNumber,
        'export_price': exportPrice,
        'total_export_price': totalExportPrice,
        'variant': variant,
        'shipment': shipment,
        'created_at': createdAt?.toIso8601String(),
        'shipment_data': shipmentData?.toJson(),
        'export_unit_data': exportUnitData,
        'product_data': productData?.toJson(),
    };
}