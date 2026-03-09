import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';

import 'promotion_kafa_model.dart';

part 'variant_kafa_model.freezed.dart';
part 'variant_kafa_model.g.dart';

@freezed
class VariantKafaModel with _$VariantKafaModel {
  const VariantKafaModel._();

  const factory VariantKafaModel({
    int? id,
    int? promotion,
    String? title,
    String? code,
    @JsonKey(name: 'price_sell') double? price,
    String? image,
    @Default([]) List<PromotionDetailModel> promotionDetail,
    @Default(0) int amount,
    @JsonKey(name: 'quanity_in_cart') @Default(0) int quantityInCart,
    @JsonKey(name: 'settings') SettingModel? setting,
    @JsonKey(name: 'quantity_promotion_apply') num? quantityPromotionApply,
    @JsonKey(name: 'count_quantity') num? countQuantity,
    @Default(true) bool isReadyForOrder,
    @Default([])
    @JsonKey(name: 'promotion_data')
    List<PromotionData> promotionData,
    @Default([]) @JsonKey(name: 'brand_data') List<BrandData> brandData,
  }) = _VariantKafaModel;

  factory VariantKafaModel.fromJson(Map<String, dynamic> json) =>
      _$VariantKafaModelFromJson(json);
}

@freezed
class VariantKafaPreviewModel with _$VariantKafaPreviewModel {
  const VariantKafaPreviewModel._();

  const factory VariantKafaPreviewModel({
    int? id,
    int? promotion,
    String? title,
    double? price,
    String? image,
    @JsonKey(name: 'quanity_in_cart') @Default(0) int quantity,
  }) = _VariantKafaPreviewModel;

  factory VariantKafaPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$VariantKafaPreviewModelFromJson(json);
}

@freezed
class SettingModel with _$SettingModel {
  const SettingModel._();

  const factory SettingModel({
    @JsonKey(name: 'made in') String? madeIn,
    String? description,
    @JsonKey(name: 'dosage_form') String? dosageForm,
    @JsonKey(name: 'package_form') String? packageForm,
    @JsonKey(name: 'products_by_manufacturer') String? productsByManufacturer,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}

@freezed
class BrandData with _$BrandData {
  const BrandData._();

  const factory BrandData({
    int? id,
    String? title,
    @JsonKey(name: 'image_data') String? image,
  }) = _BrandData;

  factory BrandData.fromJson(Map<String, dynamic> json) =>
      _$BrandDataFromJson(json);
}

extension VariantKafaMapper on VariantKafaModel {
  DrugCategoryModel toDrugCategoryModel() {
    return DrugCategoryModel(
      title: title,
      products: [
        DrugProductModel(
          id: id,
          quantity: quantityInCart,
          product: ProductData(
            id: id,
            title: title,
            code: code,
            image: image,
            price: price?.toInt(),
            promotion: promotion,
            quantity: quantityInCart,
            promotions: promotionData,
          ),
        )
      ],
    );
  }
}

extension VariantToProductModelMapper on VariantKafaModel {
  DrugProductModel toDrugProductModel() {
    return DrugProductModel(
      id: id,
      quantity: quantityInCart,
      product: ProductData(
        id: id,
        title: title,
        code: code,
        image: image,
        price: price?.toInt(),
        promotion: promotion,
        quantity: quantityInCart,
        promotions: promotionData,
      ),
    );
  }
}
