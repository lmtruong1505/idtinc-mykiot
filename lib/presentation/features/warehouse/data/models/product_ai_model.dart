import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
part 'product_ai_model.freezed.dart';
part 'product_ai_model.g.dart';

@freezed
class ProductAIModel with _$ProductAIModel {
  const factory ProductAIModel({
    @JsonKey(name: 'name_extract') final String? name,
    @JsonKey(name: 'unit_extract') final String? unitExtract,
    @JsonKey(name: 'so_lo') final String? soLo,
    @JsonKey(name: 'han_su_dung') final String? hanSuDung,
    @JsonKey(name: 'chiet_khau_extract') final String? chietKhau,
    @JsonKey(name: 'thue_suat_extract') final String? thueSuat,
    @JsonKey(name: 'quantity_extract') final String? quantityExtract,
    @JsonKey(name: 'unit_price_extract') final num? unitPriceExtract,
    @JsonKey(name: 'total_amount_extract') final num? totalAmountExtract,
  }) = _ProductAIModel;

  factory ProductAIModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAIModelFromJson(json);
}

extension ProductAIMapper on ProductAIModel {
  ProductV3Model mapperToPrd() {
    final inputQuantity = int.tryParse(quantityExtract ?? '');
    return ProductV3Model(
      name: name,
      units: [UnitV3Model(name: unitExtract)],
      unitSell: UnitV3Model(name: unitExtract),
      quantityExtract: inputQuantity,
      unitPriceExtract: unitPriceExtract,
      totalAmountExtract: totalAmountExtract,
    );
  }
}

@freezed
class ImageAIStatusModel with _$ImageAIStatusModel {
  const factory ImageAIStatusModel({
    final String? filename,
    final String? status,
    final int? count,
  }) = _ImageAIStatusModel;

  factory ImageAIStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ImageAIStatusModelFromJson(json);
}
