import 'package:freezed_annotation/freezed_annotation.dart';

part 'variant_wm_model.freezed.dart';
part 'variant_wm_model.g.dart';

@freezed
class VariantWmModel with _$VariantWmModel {
  const VariantWmModel._();

  const factory VariantWmModel({
    final int? id,
    final String? title,
    final String? code,
    final String? barcode,
    // @JsonKey(name: 'price_sell') final double? priceSell,
    @JsonKey(name: 'price_sell') final double? priceSellUnit,
    @JsonKey(name: 'price_import') final double? priceImport,
    final bool? status,
    final double? quantity,
    // final Settings? settings,
    final String? image,
    final int? product,
    final int? account,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    // @JsonKey(name: 'options_data') final List<OptionModel>? optionsData,
    @JsonKey(name: 'quantity_in_stock') final double? quantityInStock,
    // @JsonKey(name: 'product_data') final ProductDataModel? productData,
    @JsonKey(name: 'promotion_item_data')
    final List<PromotionItemModel>? promotionItemData,
    @JsonKey(name: 'promotion_item_system')
    final List<PromotionItemModel>? promotionItemSystem,
    @JsonKey(name: 'promotion_item_me')
    final List<PromotionItemModel>? promotionItemMe,
    // @JsonKey(name: 'price_policy')
    // final PricePolicyModel? pricePolicy,
  }) = _VariantWmModel;

  factory VariantWmModel.fromJson(Map<String, dynamic> json) =>
      _$VariantWmModelFromJson(json);
}

@freezed
class PromotionItemModel with _$PromotionItemModel {
  const PromotionItemModel._();

  const factory PromotionItemModel({
    final int? id,
    final int? quantity,
    final double? discount,
    // final PromotionItemModelSettings? settings,
    final int? typeDiscount,
    final int? promotion,
    final PromotionData? promotionData,
    final int? variant,
    final List<int>? system,
    final TypeDiscountDataModel? typeDiscountData,
    final List<TypeDiscountDataModel>? systemData,
  }) = _PromotionItemModel;

  factory PromotionItemModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemModelFromJson(json);
}

@freezed
class TypeDiscountDataModel with _$TypeDiscountDataModel {
  const TypeDiscountDataModel._();

  const factory TypeDiscountDataModel({
    final int? id,
    final String? title,
    final String? code,
  }) = _TypeDiscountDataModel;

  factory TypeDiscountDataModel.fromJson(Map<String, dynamic> json) =>
      _$TypeDiscountDataModelFromJson(json);
}

@freezed
class PromotionData with _$PromotionData {
  const PromotionData._();

  const factory PromotionData({
    final int? id,
    final String? title,
    final String? code,
  }) = _PromotionData;

  factory PromotionData.fromJson(Map<String, dynamic> json) =>
      _$PromotionDataFromJson(json);
}
