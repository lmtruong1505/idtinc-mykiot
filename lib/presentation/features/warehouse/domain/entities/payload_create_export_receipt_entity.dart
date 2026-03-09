class PayloadCreateExportReceiptEntity {
  final ExportReceipt? exportReceipt;
  final List<ExportInfor>? exportInfor;

  PayloadCreateExportReceiptEntity({
    this.exportReceipt,
    this.exportInfor,
  });
}

class ExportInfor {
  final int? shipment;
  final int? exportNumber;
  final int? exportUnit;
  final int? storageUnit;
  final int? exportPrice;
  final int? totalExportPrice;
  final int? variant;

  ExportInfor({
    this.shipment,
    this.exportNumber,
    this.exportUnit,
    this.storageUnit,
    this.exportPrice,
    this.totalExportPrice,
    this.variant,
  });

  ExportInfor copyWith({
    int? shipment,
    int? exportNumber,
    int? exportUnit,
    int? storageUnit,
    int? exportPrice,
    int? totalExportPrice,
    int? variant,
  }) =>
      ExportInfor(
        shipment: shipment ?? this.shipment,
        exportNumber: exportNumber ?? this.exportNumber,
        exportUnit: exportUnit ?? this.exportUnit,
        storageUnit: storageUnit ?? this.storageUnit,
        exportPrice: exportPrice ?? this.exportPrice,
        totalExportPrice: totalExportPrice ?? this.totalExportPrice,
        variant: variant ?? this.variant,
      );

  Map<String, dynamic> toJson() => {
        'shipment': shipment,
        'export_number': exportNumber,
        'export_unit': exportUnit,
        'storage_unit': storageUnit,
        'export_price': exportPrice,
        'total_export_price': totalExportPrice,
        'variant': variant,
      };
}

class ExportReceipt {
  final String? code;
  final String? reason;
  final int? totalPrice;
  final int? warehouse;
  final int? userCreated;
  final int? userUpdated;

  ExportReceipt({
    this.code,
    this.reason,
    this.totalPrice,
    this.warehouse,
    this.userCreated,
    this.userUpdated,
  });

  ExportReceipt copyWith({
    String? code,
    String? reason,
    int? totalPrice,
    int? warehouse,
    int? userCreated,
    int? userUpdated,
  }) =>
      ExportReceipt(
        code: code ?? this.code,
        reason: reason ?? this.reason,
        totalPrice: totalPrice ?? this.totalPrice,
        warehouse: warehouse ?? this.warehouse,
        userCreated: userCreated ?? this.userCreated,
        userUpdated: userUpdated ?? this.userUpdated,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'reason': reason,
        'total_price': totalPrice,
        'warehouse': warehouse,
        'user_created': userCreated,
        'user_updated': userUpdated,
        'status': 3,
      };
}
