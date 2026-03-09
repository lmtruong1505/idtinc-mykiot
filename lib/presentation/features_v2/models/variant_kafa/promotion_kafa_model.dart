import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';

part 'promotion_kafa_model.freezed.dart';
part 'promotion_kafa_model.g.dart';

@freezed
class PromotionDetailModel with _$PromotionDetailModel {
  const PromotionDetailModel._();

  const factory PromotionDetailModel({
    int? id,
    String? title,
    String? code,
    @JsonKey(name: 'same_time') bool? sameTime,
    @JsonKey(name: 'many_time') bool? manyTime,
    @JsonKey(name: 'limit_order') bool? limitOrder,
    @JsonKey(name: 'apply_promotion') int? applyPromotion,
    @JsonKey(name: 'variant_consumer_data') ConsumerDataModel? consumerData,
    @JsonKey(name: 'promotion_item_data')
    List<PromotionItemDataModel>? promotionItemData,
    @JsonKey(name: 'promotion_type_data') PromotionTypeData? promotionTypeData,
    @JsonKey(name: 'promotion_status_data')
    PromotionStatusData? promotionStatusData,
    @JsonKey(name: 'promotion_data') List<PromotionData>? promotionData,
  }) = _PromotionDetailModel;

  factory PromotionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionDetailModelFromJson(json);
}

@freezed
class ConsumerDataModel with _$ConsumerDataModel {
  const ConsumerDataModel._();

  const factory ConsumerDataModel({
    int? id,
    @JsonKey(name: 'variant_id') int? variantId,
    @JsonKey(name: 'quantity_buy') int? quantityBuy,
    @JsonKey(name: 'quantity_bonus') int? quantityBonus,
    @JsonKey(name: 'variant_data') VariantDataModel? variantData,
  }) = _ConsumerDataModel;

  factory ConsumerDataModel.fromJson(Map<String, dynamic> json) =>
      _$ConsumerDataModelFromJson(json);
}

@freezed
class PromotionItemDataModel with _$PromotionItemDataModel {
  const PromotionItemDataModel._();

  const factory PromotionItemDataModel({
    int? id,
    @JsonKey(name: 'value_min') double? valueMin,
    @JsonKey(name: 'value_max') double? valueMax,
    int? quantity,
    @JsonKey(name: 'promotion_value') int? promotionValue,
    @JsonKey(name: 'type_discount')
    int?
        typeDiscount, // null: Tang san pham, 1: Giam gia tien mat, 2: Giam gia tien theo %
    @JsonKey(name: 'variant_value_data')
    List<VariantValueDataModel>? variantValueData,
    TypePromotionItem? type,
    @Default(0) int quantitySelected,
    @Default(0) int gifForOneApply,
    @Default(0) num discountValue,
    int? amountProductPromoForCustomerByOneQuantitySelected,
    @JsonKey(name: 'group_variant_data')
    @Default([])
    List<GroupVariantItemModel> groupVariantData,
  }) = _PromotionItemDataModel;

  factory PromotionItemDataModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemDataModelFromJson(json);
}

@freezed
class PromotionTypeData with _$PromotionTypeData {
  const PromotionTypeData._();

  const factory PromotionTypeData({
    int? id,
    String? title,
    String? code,
  }) = _PromotionTypeData;

  factory PromotionTypeData.fromJson(Map<String, dynamic> json) =>
      _$PromotionTypeDataFromJson(json);
}

@freezed
class PromotionStatusData with _$PromotionStatusData {
  const PromotionStatusData._();

  const factory PromotionStatusData({
    int? id,
    String? title,
    String? code,
  }) = _PromotionStatusData;

  factory PromotionStatusData.fromJson(Map<String, dynamic> json) =>
      _$PromotionStatusDataFromJson(json);
}

@freezed
class VariantValueDataModel with _$VariantValueDataModel {
  const VariantValueDataModel._();

  const factory VariantValueDataModel({
    int? id,
    @JsonKey(name: 'variant_id') int? variantId,
    int? quantity,
    @JsonKey(name: 'variant_data') VariantDataModel? variantData,
  }) = _VariantValueDataModel;

  factory VariantValueDataModel.fromJson(Map<String, dynamic> json) =>
      _$VariantValueDataModelFromJson(json);
}

@freezed
class VariantDataModel with _$VariantDataModel {
  const VariantDataModel._();

  const factory VariantDataModel({
    int? id,
    String? title,
    String? code,
    String? image,
    @JsonKey(name: 'price_sell') double? priceSell,
    @JsonKey(name: 'price_import') double? priceImport,
  }) = _VariantDataModel;

  factory VariantDataModel.fromJson(Map<String, dynamic> json) =>
      _$VariantDataModelFromJson(json);
}

@freezed
class GroupVariantItemModel with _$GroupVariantItemModel {
  const GroupVariantItemModel._();

  const factory GroupVariantItemModel({
    int? id,
    @JsonKey(name: 'promotion_id') int? promotionId,
    @JsonKey(name: 'variant_value') List<GroupVariantValueModel>? variantValue,
    @Default(0) int amount,
  }) = _GroupVariantItemModel;

  factory GroupVariantItemModel.fromJson(Map<String, dynamic> json) =>
      _$GroupVariantItemModelFromJson(json);
}

@freezed
class GroupVariantValueModel with _$GroupVariantValueModel {
  const GroupVariantValueModel._();

  const factory GroupVariantValueModel({
    int? id,
    int? quantity,
    VariantModel? variant,
  }) = _GroupVariantValueModel;

  factory GroupVariantValueModel.fromJson(Map<String, dynamic> json) =>
      _$GroupVariantValueModelFromJson(json);
}

@freezed
class VariantModel with _$VariantModel {
  const VariantModel._();

  const factory VariantModel({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String code,
    @Default('') String barCode,
    @JsonKey(name: 'price_sell') @Default(0) double priceSell,
    @JsonKey(name: 'price_sell_default') @Default(0) double priceSellDefault,
    @JsonKey(name: 'price_import') @Default(0) double priceImport,
    @Default(true) bool status,
    @Default('') String image,
    @Default(0) int amount,
    @JsonKey(name: 'product_data')
    @Default(ProductDataModel())
    ProductDataModel productData,
    @Default(null) PromotionItemModel? promotion,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);
}

@freezed
class ProductDataModel with _$ProductDataModel {
  const factory ProductDataModel({
    @Default('') String title,
    @Default('') String code,
    @Default('') String image,
    @Default('') String brand,
    @Default('') String category,
    @Default('') String group,
    @JsonKey(name: 'code_system_data') @Default('') String codeSystemData,
  }) = _ProductDataModel;

  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDataModelFromJson(json);
}

@freezed
class PromotionItemModel with _$PromotionItemModel {
  const factory PromotionItemModel({
    @Default(1) int promotion,
    @Default(0.0) double discount,
    @Default(0) int quantity,
    @JsonKey(name: 'type_discount') @Default(1) int typeDiscount,
  }) = _PromotionItemModel;

  factory PromotionItemModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemModelFromJson(json);
}

enum TypePromotionItem {
  discountTicket(typePromoParent: 'GTDH'),
  groupPackageVariant(typePromoParent: 'GTDH'),
  groupVariant(typePromoParent: 'GTDH');

  final String typePromoParent;

  const TypePromotionItem({required this.typePromoParent});
}
