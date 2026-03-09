import '../../domain/entities/image_receipt_entity.dart';
import '../../domain/entities/receipt_ai_extract_response.dart';

class ReceiptAiExtractResponseModel extends ReceiptAiExtractResponse {
  ReceiptAiExtractResponseModel({
    required super.message,
    required super.code,
    required super.details,
    required super.images,
  });

  factory ReceiptAiExtractResponseModel.fromJson(Map<String, dynamic> json) {
    return ReceiptAiExtractResponseModel(
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      details: (json['details'] as List<dynamic>?)
              ?.map((item) => ReceiptAiExtractItemModel.fromJson(item))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((item) => ImageReceiptModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ReceiptAiExtractItemModel extends ReceiptAiExtractItem {
  ReceiptAiExtractItemModel({
    super.chietKhauExtract,
    super.hanSuDung,
    super.nameDb,
    super.nameExtract,
    super.quantityExtract,
    super.soLo,
    super.thueSuatExtract,
    super.unitExtract,
    super.unitPriceExtract,
  });

  factory ReceiptAiExtractItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptAiExtractItemModel(
      nameExtract: json['name_extract'] ?? '',
      unitExtract: json['unit_extract'] ?? '',
      soLo: json['so_lo'],
      hanSuDung: json['han_su_dung'],
      quantityExtract: json['quantity_extract']?.toString() ?? '',
      unitPriceExtract: (json['unit_price_extract'] ?? 0).toDouble(),
      chietKhauExtract: json['chiet_khau_extract'],
      thueSuatExtract: json['thue_suat_extract'],
      nameDb: (json['name_db'] as List<dynamic>?)
              ?.map((item) => item)
              .toList() ??
          [],
    );
  }
}

class ImageReceiptModel extends ImageReceiptEntity {
  ImageReceiptModel({
    super.messageAi,
    super.name,
    super.path,
    super.source,
    super.statusAi,
    super.count,
  });

  factory ImageReceiptModel.fromJson(Map<String, dynamic> json) {
    return ImageReceiptModel(
      name: json['filename'],
      count: json['count'],
      messageAi: json['status'],
    );
  }
}
