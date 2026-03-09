import 'dart:ui';

import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../features_v2/models/product/product_v2_model.dart';
import '../../data/models/warehouse_model.dart';

class ShipmentDataEntity {
  final String? message;
  final int? code;
  final List<ShipmentItemEntity>? data;
  final int? count;
  final ShipmentDataBonusEntity? bonus;
  final List<ShipmentItemEntity>? selected;

  ShipmentDataEntity({
    this.message,
    this.code,
    this.data,
    this.count,
    this.bonus,
    this.selected,
  });

  ShipmentDataEntity copyWith({
    String? message,
    int? code,
    List<ShipmentItemEntity>? data,
    int? count,
    ShipmentDataBonusEntity? bonus,
    List<ShipmentItemEntity>? selected,
  }) =>
      ShipmentDataEntity(
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
        count: count ?? this.count,
        bonus: bonus ?? this.bonus,
        selected: selected ?? this.selected,
      );

  factory ShipmentDataEntity.fromJson(Map<String, dynamic> json) =>
      ShipmentDataEntity(
        message: json['message'],
        code: json['code'],
        data: json['data'] == null
            ? []
            : List<ShipmentItemEntity>.from(
                json['data']!.map((x) => ShipmentItemEntity.fromJson(x))),
        count: json['count'],
        bonus: json['bonus'] == null
            ? null
            : ShipmentDataBonusEntity.fromJson(json['bonus']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        'count': count,
        'bonus': bonus?.toJson(),
      };
}

class ShipmentDataBonusEntity {
  final num? totalShipmentNearDate;
  final num? quantityNearDate;
  final num? quantityExpDate;
  final num? quantityInventory;

  ShipmentDataBonusEntity({
    this.totalShipmentNearDate,
    this.quantityNearDate,
    this.quantityExpDate,
    this.quantityInventory,
  });

  ShipmentDataBonusEntity copyWith({
    num? totalShipmentNearDate,
    num? quantityNearDate,
    num? quantityExpDate,
    num? quantityInventory,
  }) =>
      ShipmentDataBonusEntity(
        totalShipmentNearDate:
            totalShipmentNearDate ?? this.totalShipmentNearDate,
        quantityNearDate: quantityNearDate ?? this.quantityNearDate,
        quantityExpDate: quantityExpDate ?? this.quantityExpDate,
        quantityInventory: quantityInventory ?? this.quantityInventory,
      );

  factory ShipmentDataBonusEntity.fromJson(Map<String, dynamic> json) =>
      ShipmentDataBonusEntity(
        totalShipmentNearDate: json['total_shipment_near_date'],
        quantityNearDate: json['quantity_near_date'],
        quantityExpDate: json['quantity_exp_date'],
        quantityInventory: json['quantity_inventory'],
      );

  Map<String, dynamic> toJson() => {
        'total_shipment_near_date': totalShipmentNearDate,
        'quantity_near_date': quantityNearDate,
        'quantity_exp_date': quantityExpDate,
        'quantity_inventory': quantityInventory,
      };
}

class ShipmentItemEntity {
  final int? id;
  final String? code;
  final num? storageQuantity;
  final num? currentQuantity;
  final num? importPrice;
  final num? totalImportPrice;
  final num? totalMoney;
  final num? vat;
  final num? discount;
  final int? variant;
  final int? storageUnit;
  final int? inputUnit;
  final num? inputQuantity;
  final DateTime? startDate;
  final DateTime? endDate;
  final dynamic typeItemsId;
  final int? warehouseImportId;
  final int? importReceiptId;
  final dynamic slotId;
  final int? userCreated;
  final int? userUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? daysRemaining;
  final ImportReceiptEntity? importReceiptData;
  final int? status;
  final String? statusLabel;
  final int selectedQuantity;
  final ShipmentItemProduct? product;
  final ProductV2Model? productData;
  final String? inputUnitData;
  final String? storageUnitData;
  final String? receiptName;
  final bool isSelected;
  final ShipmentItemTypeWarehouse? typeWarehouse;

  ShipmentItemEntity({
    this.id,
    this.code,
    this.storageQuantity,
    this.currentQuantity,
    this.importPrice,
    this.totalImportPrice,
    this.totalMoney,
    this.vat,
    this.discount,
    this.variant,
    this.storageUnit,
    this.inputUnit,
    this.inputQuantity,
    this.startDate,
    this.endDate,
    this.typeItemsId,
    this.warehouseImportId,
    this.importReceiptId,
    this.slotId,
    this.userCreated,
    this.userUpdated,
    this.createdAt,
    this.updatedAt,
    this.daysRemaining,
    this.importReceiptData,
    this.status,
    this.statusLabel,
    this.selectedQuantity = 0,
    this.product,
    this.productData,
    this.inputUnitData,
    this.storageUnitData,
    this.receiptName,
    this.isSelected = false,
    this.typeWarehouse,
  });

  ShipmentItemEntity copyWith({
    int? id,
    String? code,
    num? storageQuantity,
    num? currentQuantity,
    num? importPrice,
    num? totalImportPrice,
    num? totalMoney,
    num? vat,
    num? discount,
    int? variant,
    int? storageUnit,
    int? inputUnit,
    num? inputQuantity,
    DateTime? startDate,
    DateTime? endDate,
    dynamic typeItemsId,
    int? warehouseImportId,
    int? importReceiptId,
    dynamic slotId,
    int? userCreated,
    int? userUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? daysRemaining,
    ImportReceiptEntity? importReceiptData,
    int? status,
    String? statusLabel,
    int? selectedQuantity,
    ShipmentItemProduct? product,
    ProductV2Model? productData,
    String? inputUnitData,
    String? storageUnitData,
    String? receiptName,
    bool? isSelected,
    ShipmentItemTypeWarehouse? typeWarehouse,
  }) =>
      ShipmentItemEntity(
        id: id ?? this.id,
        code: code ?? this.code,
        storageQuantity: storageQuantity ?? this.storageQuantity,
        currentQuantity: currentQuantity ?? this.currentQuantity,
        importPrice: importPrice ?? this.importPrice,
        totalImportPrice: totalImportPrice ?? this.totalImportPrice,
        totalMoney: totalMoney ?? this.totalMoney,
        vat: vat ?? this.vat,
        discount: discount ?? this.discount,
        variant: variant ?? this.variant,
        storageUnit: storageUnit ?? this.storageUnit,
        inputUnit: inputUnit ?? this.inputUnit,
        inputQuantity: inputQuantity ?? this.inputQuantity,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        typeItemsId: typeItemsId ?? this.typeItemsId,
        warehouseImportId: warehouseImportId ?? this.warehouseImportId,
        importReceiptId: importReceiptId ?? this.importReceiptId,
        slotId: slotId ?? this.slotId,
        userCreated: userCreated ?? this.userCreated,
        userUpdated: userUpdated ?? this.userUpdated,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        daysRemaining: daysRemaining ?? this.daysRemaining,
        importReceiptData: importReceiptData ?? this.importReceiptData,
        status: status ?? this.status,
        statusLabel: statusLabel ?? this.statusLabel,
        selectedQuantity: selectedQuantity ?? this.selectedQuantity,
        product: product ?? this.product,
        productData: productData ?? this.productData,
        inputUnitData: inputUnitData ?? this.inputUnitData,
        storageUnitData: storageUnitData ?? this.storageUnitData,
        receiptName: receiptName ?? this.receiptName,
        isSelected: isSelected ?? this.isSelected,
        typeWarehouse: typeWarehouse ?? this.typeWarehouse,
      );

  factory ShipmentItemEntity.fromJson(Map<String, dynamic> json) =>
      ShipmentItemEntity(
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
            : ImportReceiptEntity.fromJson(json['import_receipt_data']),
        status: json['status'],
        statusLabel: json['status_label'],
        product: json['product_data'] == null
            ? null
            : ShipmentItemProduct.fromJson(json['product_data']),
        productData: json['product_data'] == null
            ? null
            : ProductV2Model.fromJson(json['product_data']),
        typeWarehouse: json['type_warehouse'] == null
            ? null
            : ShipmentItemTypeWarehouse.fromJson(json['type_warehouse']),
        inputUnitData: json['input_unit_data'],
        storageUnitData: json['storage_unit_data'],
        receiptName: json['receipt_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'storage_quantity': storageQuantity,
        'current_quantity': currentQuantity,
        'import_price': importPrice,
        'total_import_price': totalImportPrice,
        'total_money': totalMoney,
        'vat': vat,
        'discount': discount,
        'variant': variant,
        'storage_unit': storageUnit,
        'input_unit': inputUnit,
        'input_unit_data': inputUnitData,
        'input_quantity': inputQuantity,
        'start_date': startDate != null
            ? '${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}'
            : null,
        'end_date': endDate != null
            ? '${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}'
            : null,
        'type_items_id': typeItemsId,
        'warehouse_import_id': warehouseImportId,
        'import_receipt_id': importReceiptId,
        'slot_id': slotId,
        'user_created': userCreated,
        'user_updated': userUpdated,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'days_remaining': daysRemaining,
        'import_receipt_data': importReceiptData?.toJson(),
        'status': status,
        'status_label': statusLabel,
        'product_data': product?.toJson(),
        'product_data_test': productData?.toJson(),
        'isSelected': isSelected,
        'receipt_name': receiptName,
      };

  // TODO
  Map<String, dynamic> toJsonPayloadCreateImportReceipt() {
    List? unitData;
    if (productData?.id == null) {
      unitData = [
        {
          'id': null,
          'name': productData?.unitSell?.name,
          'value': 1,
          'level': 1,
          'sell_unit': true,
          'import_price': 0,
          'sell_price': productData?.unitSell?.sellPrice,
        },
      ];
    }
    final json = {
      'id': id,
      'code': code,
      'barcode': productData?.barcode,
      'lieu_dung': null,
      'start_date': startDate.fomatCustom(fomat: 'yyyy-MM-dd'),
      'end_date': endDate.fomatCustom(fomat: 'yyyy-MM-dd'),
      'import_price': importPrice,
      'sell_price': productData?.unitSell?.sellPrice,
      'total_money': totalMoneyAfterVat,
      'total_import_price': (importPrice ?? 0) * (inputQuantity ?? 0),
      'warehouse_import': warehouseImportId,
      'vat': vat,
      'discount': '${discount ?? 0}',
      'unit_data': unitData,
      'input_quantity': inputQuantity,
      'variant_name': productData?.id == null ? productData?.name : null,
      'variant': productData?.id,
      'storage_unit': inputUnit,
      'input_unit': inputUnit ?? productData?.unitSell?.name,
      'status_label': 'Còn hạn',
    };
    json.removeWhere(
      (key, value) => value == null || value == '' || value == 'null',
    );
    return json;
  }
}

extension GetShipmentItemEntity on ShipmentItemEntity {
  int get nowToDateEnd {
    return (endDate ?? DateTime.now()).difference(DateTime.now()).inDays;
  }

  String get titleChip {
    return switch (nowToDateEnd) {
      <= 30 => 'Sắp hết hạn',
      > 30 => 'Còn hạn',
      <= 0 => 'Hết hạn',
      int() => throw UnimplementedError(),
    };
  }

  Color get colorTitleChip {
    return switch (nowToDateEnd) {
      <= 30 => AppColors.carrot60,
      > 30 => AppColors.green60,
      <= 0 => AppColors.red60,
      int() => throw UnimplementedError(),
    };
  }

  Color get borderChip {
    return switch (nowToDateEnd) {
      <= 30 => AppColors.carrot20,
      > 30 => AppColors.green20,
      <= 0 => AppColors.red20,
      int() => throw UnimplementedError(),
    };
  }

  Color get bgChip {
    return switch (nowToDateEnd) {
      <= 30 => AppColors.carrot10,
      > 30 => AppColors.green10,
      <= 0 => AppColors.red10,
      int() => throw UnimplementedError(),
    };
  }

  num get totalMoneyBeforeVat {
    return (importPrice ?? 0) * (inputQuantity ?? 0) - (discount ?? 0);
  }

  num get totalMoneyAfterVat {
    return totalMoneyBeforeVat * (1 + (vat ?? 0) / 100);
  }
}

class ShipmentItemProduct {
  final int? id;
  final String? productName;

  ShipmentItemProduct({
    this.id,
    this.productName,
  });

  ShipmentItemProduct copyWith({
    int? id,
    String? productName,
  }) =>
      ShipmentItemProduct(
        id: id ?? this.id,
        productName: productName ?? this.productName,
      );

  factory ShipmentItemProduct.fromJson(Map<String, dynamic> json) =>
      ShipmentItemProduct(
        id: json['id'],
        productName: json['product_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_name': productName,
      };
}

class ImportReceiptEntity {
  final int? id;
  final String? code;

  ImportReceiptEntity({
    this.id,
    this.code,
  });

  ImportReceiptEntity copyWith({
    int? id,
    String? code,
  }) =>
      ImportReceiptEntity(
        id: id ?? this.id,
        code: code ?? this.code,
      );

  factory ImportReceiptEntity.fromJson(Map<String, dynamic> json) =>
      ImportReceiptEntity(
        id: json['id'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
      };
}


class ShipmentItemTypeWarehouse {
    final int? id;
    final String? title;
    final String? code;

    ShipmentItemTypeWarehouse({
        this.id,
        this.title,
        this.code,
    });

    ShipmentItemTypeWarehouse copyWith({
        int? id,
        String? title,
        String? code,
    }) => 
        ShipmentItemTypeWarehouse(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
        );

    factory ShipmentItemTypeWarehouse.fromJson(Map<String, dynamic> json) => ShipmentItemTypeWarehouse(
        id: json["id"],
        title: json["title"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
    };
}