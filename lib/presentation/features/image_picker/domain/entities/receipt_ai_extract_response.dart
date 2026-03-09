import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../warehouse/domain/entities/shipment_data_entity.dart';
import 'image_receipt_entity.dart';

class ReceiptAiExtractResponse {
  final String message;
  final int code;
  final List<ReceiptAiExtractItem> details;
  final List<ImageReceiptEntity> images;

  ReceiptAiExtractResponse({
    required this.message,
    required this.code,
    required this.details,
    required this.images,
  });
}

// domain/entities/extract_detail.dart
class ReceiptAiExtractItem {
  final String? nameExtract;
  final String? unitExtract;
  final String? soLo;
  final String? hanSuDung;
  final String? quantityExtract;
  final double? unitPriceExtract;
  final String? chietKhauExtract;
  final String? thueSuatExtract;
  final List<dynamic>? nameDb;

  ReceiptAiExtractItem({
    this.nameExtract,
    this.unitExtract,
    this.soLo,
    this.hanSuDung,
    this.quantityExtract,
    this.unitPriceExtract,
    this.chietKhauExtract,
    this.thueSuatExtract,
    this.nameDb,
  });

  ReceiptAiExtractItem copyWith({
    String? nameExtract,
    String? unitExtract,
    String? soLo,
    String? hanSuDung,
    String? quantityExtract,
    double? unitPriceExtract,
    String? chietKhauExtract,
    String? thueSuatExtract,
    List<dynamic>? nameDb,
  }) {
    return ReceiptAiExtractItem(
      nameExtract: nameExtract ?? this.nameExtract,
      unitExtract: unitExtract ?? this.unitExtract,
      soLo: soLo ?? this.soLo,
      hanSuDung: hanSuDung ?? this.hanSuDung,
      quantityExtract: quantityExtract ?? this.quantityExtract,
      unitPriceExtract: unitPriceExtract ?? this.unitPriceExtract,
      chietKhauExtract: chietKhauExtract ?? this.chietKhauExtract,
      thueSuatExtract: thueSuatExtract ?? this.thueSuatExtract,
      nameDb: nameDb ?? this.nameDb,
    );
  }

  ShipmentItemEntity get toShipmentItemEntity {
    ProductV2Model? productData = ProductV2Model(
      name: nameExtract,
      unitSell: UnitV2Model(
        name: (unitExtract.isEmptyOrNull) ? 'Hộp' : unitExtract,
        sellPrice: unitPriceExtract,
      ),
    );
    if (nameDb?.isNotEmpty ?? false) {
      final unitSell = (nameDb!.first['units'] as List).firstWhereOrNull(
        (e) {
          return e['sell_unit'];
        },
      );
      productData = ProductV2Model(
        id: nameDb!.first['id_product'],
        name: nameDb!.first['name'],
        unitSell: UnitV2Model(
          id: unitSell['id_unit'],
          name: unitSell['name_unit'] ?? ((unitExtract.isEmptyOrNull) ? 'Hộp' : unitExtract),
          sellPrice: unitSell['sell_price'] ?? unitPriceExtract,
        ),
        unit: (nameDb!.first['units'] as List).map((e) {
          return UnitV2Model(
            id: e['id_unit'],
            name: e['name_unit'],
            level: e['level'],
            sellPrice: e['sell_price'],
            sellUnit: e['sell_unit'],
          );
        }).toList(),
      );
    }
    return ShipmentItemEntity(
      productData: productData,
      code: soLo,
      receiptName: nameExtract,
      inputQuantity: int.tryParse(quantityExtract ?? '0') ?? 0,
      vat: int.tryParse(thueSuatExtract ?? '0') ?? 0,
      discount: int.tryParse(chietKhauExtract ?? '0') ?? 0,
      endDate: DateFormat('dd/MM/y').tryParse(
        hanSuDung ?? '',
      ),
      inputUnitData: productData.unitSell?.name,
      inputUnit: productData.unitSell?.id,
    );
  }
}

class ReceiptAiExtractPayload {
  final List<File> files;
  final String workspaceId;

  ReceiptAiExtractPayload({
    required this.files,
    required this.workspaceId,
  });
}
