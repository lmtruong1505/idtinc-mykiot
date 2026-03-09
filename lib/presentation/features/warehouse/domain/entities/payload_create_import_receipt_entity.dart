import '../../../image_picker/domain/entities/image_receipt_entity.dart';
import 'shipment_data_entity.dart';

class PayloadCreateImportReceiptEntity {
  final PayloadCreateImportReceiptDataEntity? data;
  final List<ImageReceiptEntity>? file;

  PayloadCreateImportReceiptEntity({
    this.data,
    this.file,
  });

  PayloadCreateImportReceiptEntity copyWith({
    PayloadCreateImportReceiptDataEntity? data,
  }) =>
      PayloadCreateImportReceiptEntity(
        data: data ?? this.data,
      );

  factory PayloadCreateImportReceiptEntity.fromJson(
    Map<String, dynamic> json,
  ) =>
      PayloadCreateImportReceiptEntity(
        data: json['data'] == null
            ? null
            : PayloadCreateImportReceiptDataEntity.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}

class PayloadUpdateImportReceiptEntity {
  final int id;
  final PayloadUpdateImportReceiptDataEntity? data;
  final List<ImageReceiptEntity>? file;

  PayloadUpdateImportReceiptEntity({
    required this.id,
    this.data,
    this.file,
  });

  PayloadUpdateImportReceiptEntity copyWith({
    int? id,
    PayloadUpdateImportReceiptDataEntity? data,
    List<ImageReceiptEntity>? file,
  }) =>
      PayloadUpdateImportReceiptEntity(
        id: id ?? this.id,
        data: data ?? this.data,
        file: file ?? this.file,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}

class PayloadCreateImportReceiptDataEntity {
  final ImportReceipt? importReceipt;
  final List<ShipmentItemEntity>? shipment;

  PayloadCreateImportReceiptDataEntity({
    this.importReceipt,
    this.shipment,
  });

  PayloadCreateImportReceiptDataEntity copyWith({
    ImportReceipt? importReceipt,
    List<ShipmentItemEntity>? shipment,
  }) =>
      PayloadCreateImportReceiptDataEntity(
        importReceipt: importReceipt ?? this.importReceipt,
        shipment: shipment ?? this.shipment,
      );

  factory PayloadCreateImportReceiptDataEntity.fromJson(
    Map<String, dynamic> json,
  ) =>
      PayloadCreateImportReceiptDataEntity(
        importReceipt: json['import_receipt'] == null
            ? null
            : ImportReceipt.fromJson(json['import_receipt']),
        shipment: json['shipment'] == null
            ? []
            : List<ShipmentItemEntity>.from(
                json['shipment']!.map((x) => ShipmentItemEntity.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'import_receipt': importReceipt?.toJson(),
        'shipment': shipment == null
            ? []
            : List<dynamic>.from(
                shipment!.map(
                  (x) => x.toJsonPayloadCreateImportReceipt(),
                ),
              ),
      };
}

class PayloadUpdateImportReceiptDataEntity {
  final ImportReceipt? importReceipt;
  final List<ShipmentItemEntity>? shipment;
  final List<int>? fileDelete;
  final List<int>? shipmentDelete;

  PayloadUpdateImportReceiptDataEntity({
    this.importReceipt,
    this.shipment,
    this.fileDelete,
    this.shipmentDelete,
  });

  PayloadUpdateImportReceiptDataEntity copyWith({
    ImportReceipt? importReceipt,
    List<ShipmentItemEntity>? shipment,
    List<int>? fileDelete,
    List<int>? shipmentDelete,
  }) =>
      PayloadUpdateImportReceiptDataEntity(
        importReceipt: importReceipt ?? this.importReceipt,
        shipment: shipment ?? this.shipment,
        fileDelete: fileDelete ?? this.fileDelete,
        shipmentDelete: shipmentDelete ?? this.shipmentDelete,
      );

  factory PayloadUpdateImportReceiptDataEntity.fromJson(
    Map<String, dynamic> json,
  ) =>
      PayloadUpdateImportReceiptDataEntity(
        importReceipt: json['import_receipt'] == null
            ? null
            : ImportReceipt.fromJson(json['import_receipt']),
        shipment: json['shipment'] == null
            ? []
            : List<ShipmentItemEntity>.from(
                json['shipment']!.map((x) => ShipmentItemEntity.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'import_receipt': importReceipt?.toJson(),
        'shipment': shipment == null
            ? []
            : List<dynamic>.from(
                shipment!.map(
                  (x) => x.toJsonPayloadCreateImportReceipt(),
                ),
              ),
        'file_delete': fileDelete ?? [],
        'shipment_delete': shipmentDelete ?? [],
      };
}

class ImportReceipt {
  final String? reason;
  final int? warehouse;
  final int? totalPrice;
  final String? provider;
  final int? checker;

  ImportReceipt({
    this.reason,
    this.warehouse,
    this.totalPrice,
    this.provider,
    this.checker,
  });

  ImportReceipt copyWith({
    String? reason,
    int? warehouse,
    int? totalPrice,
    String? provider,
    int? checker,
  }) =>
      ImportReceipt(
        reason: reason ?? this.reason,
        warehouse: warehouse ?? this.warehouse,
        totalPrice: totalPrice ?? this.totalPrice,
        provider: provider ?? this.provider,
        checker: checker ?? this.checker,
      );

  factory ImportReceipt.fromJson(Map<String, dynamic> json) => ImportReceipt(
        reason: json['reason'],
        warehouse: json['warehouse'],
        totalPrice: json['total_price'],
        provider: json['provider'],
        checker: json['checker'],
      );

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'warehouse': warehouse,
        'total_price': totalPrice,
        'provider': provider,
        'checker': checker,
      };
}
