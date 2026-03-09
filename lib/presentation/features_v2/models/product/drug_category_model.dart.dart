import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug_category_model.dart.freezed.dart';
part 'drug_category_model.dart.g.dart';

@freezed
class DrugCategoryModel with _$DrugCategoryModel {
  const factory DrugCategoryModel({
    String? title,
    @JsonKey(name: 'value') List<DrugProductModel>? products,
    @Default(false) bool isSelect,
  }) = _DrugCategoryProductModel;

  factory DrugCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$DrugCategoryModelFromJson(json);
}

@freezed
class DrugProductModel with _$DrugProductModel {
  const factory DrugProductModel({
    @JsonKey(name: 'product_kafa_id') int? id,
    int? quantity,
    @JsonKey(name: 'product_data') ProductData? product,
    @Default(false) bool isSelect,
  }) = _DrugProductModel;

  factory DrugProductModel.fromJson(Map<String, dynamic> json) =>
      _$DrugProductModelFromJson(json);
}

@freezed
class ProductData with _$ProductData {
  const factory ProductData({
    int? id,
    String? title,
    String? code,
    int? price,
    String? image,
    @JsonKey(name: 'promotion_data') List<PromotionData>? promotions,
    int? promotion,
    @JsonKey(name: 'brand_data') List<BrandData>? brand,
    @JsonKey(name: 'status_pmg') String? status,
    num? quantity,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
}

@freezed
class PromotionData with _$PromotionData {
  const factory PromotionData({
    final int? id,
    final String? title,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'promotion_item_data')
    final List<PromotionItem>? promotionItems,
  }) = _PromotionData;

  factory PromotionData.fromJson(Map<String, dynamic> json) =>
      _$PromotionDataFromJson(json);
}

@freezed
class BonusVariantInfor with _$BonusVariantInfor {
  const factory BonusVariantInfor({
    int? quantity,
    @JsonKey(name: 'variant_data') VariantData? variant,
  }) = _BonusVariantInfor;

  factory BonusVariantInfor.fromJson(Map<String, dynamic> json) =>
      _$BonusVariantInforFromJson(json);
}

@freezed
class VariantData with _$VariantData {
  const factory VariantData({
    int? id,
    String? title,
    String? code,
    @JsonKey(name: 'price_sell') int? price,
    @JsonKey(name: 'image_data') String? image,
  }) = _VariantData;

  factory VariantData.fromJson(Map<String, dynamic> json) =>
      _$VariantDataFromJson(json);
}

@freezed
class BrandData with _$BrandData {
  const factory BrandData({
    int? id,
    String? title,
  }) = _BrandData;

  factory BrandData.fromJson(Map<String, dynamic> json) =>
      _$BrandDataFromJson(json);
}

@freezed
class PromotionItem with _$PromotionItem {
  const factory PromotionItem({
    final int? id,
    @JsonKey(name: 'value_range') final num? valueRange,
    @JsonKey(name: 'bonus_variant_infor')
    final List<BonusVariantInfor>? bonusVariantInfor,
  }) = _PromotionItem;

  factory PromotionItem.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemFromJson(json);
}
