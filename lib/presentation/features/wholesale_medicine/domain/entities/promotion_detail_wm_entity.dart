import 'package:freezed_annotation/freezed_annotation.dart';

import 'variant_wm_entity.dart';

part 'promotion_detail_wm_entity.freezed.dart';
part 'promotion_detail_wm_entity.g.dart';

enum TypePromotion { product, orderTotal }

@freezed
class PromotionDetailEntity with _$PromotionDetailEntity {
  const PromotionDetailEntity._();

  const factory PromotionDetailEntity({
    int? id,
    String? title,
    String? code,
    bool? sameTime,
    bool? manyTime,
    bool? limitOrder,
    int? applyPromotion,
    ConsumerDataEntity? consumerData,
    List<PromotionItemDataEntity>? promotionItemData,
    PromotionTypeData? promotionTypeData,
    PromotionStatusData? promotionStatusData,
    DateTime? startDate,
    DateTime? endDate,
  }) = _PromotionDetailEntity;

  factory PromotionDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$PromotionDetailEntityFromJson(json);
}

@freezed
class PromotionItemDataEntity with _$PromotionItemDataEntity {
  const PromotionItemDataEntity._();

  const factory PromotionItemDataEntity({
    int? id,
    double? valueMin,
    double? valueMax,
    int? quantity,
    int? promotionValue,
    int? typeDiscount,
    List<VariantValueDataEntity>? variantValueData,
    TypePromotionItem? type,
    @Default(0) int quantitySelected,
    @Default(0) int gifForOneApply,
    @Default(0) num discountValue,
    int? amountProductPromoForCustomerByOneQuantitySelected,
    @Default([]) List<GroupVariantItemEntity> groupVariantData,
  }) = _PromotionItemDataEntity;

  factory PromotionItemDataEntity.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemDataEntityFromJson(json);
}

enum TypePromotionItem {
  discountTicket(typePromoParent: 'GTDH'),
  groupPackageVariant(typePromoParent: 'GTDH'),
  groupVariant(typePromoParent: 'GTDH');

  final String typePromoParent;

  const TypePromotionItem({required this.typePromoParent});
}

@freezed
class GroupVariantItemEntity with _$GroupVariantItemEntity {
  const GroupVariantItemEntity._();

  const factory GroupVariantItemEntity({
    int? id,
    int? promotionId,
    List<GroupVariantValueEntity>? variantValue,
    @Default(0) int amount,
  }) = _GroupVariantItemEntity;

  factory GroupVariantItemEntity.fromJson(Map<String, dynamic> json) =>
      _$GroupVariantItemEntityFromJson(json);
}

@freezed
class GroupVariantValueEntity with _$GroupVariantValueEntity {
  const GroupVariantValueEntity._();

  const factory GroupVariantValueEntity({
    int? id,
    int? quantity,
    VariantWmEntity? variant,
  }) = _GroupVariantValueEntity;

  factory GroupVariantValueEntity.fromJson(Map<String, dynamic> json) =>
      _$GroupVariantValueEntityFromJson(json);
}

@freezed
class VariantValueDataEntity with _$VariantValueDataEntity {
  const VariantValueDataEntity._();

  const factory VariantValueDataEntity({
    int? id,
    int? variant,
    String? title,
    String? code,
    String? image,
    double? priceSell,
    double? priceImport,
    int? quantity,
  }) = _VariantValueDataEntity;

  factory VariantValueDataEntity.fromJson(Map<String, dynamic> json) =>
      _$VariantValueDataEntityFromJson(json);
}

@freezed
class ConsumerDataEntity with _$ConsumerDataEntity {
  const ConsumerDataEntity._();

  const factory ConsumerDataEntity({
    int? id,
    int? variantId,
    String? variantTitle,
    String? variantCode,
    String? variantImage,
    double? variantPriceSell,
    int? quantityBuy,
    int? quantityBonus,
    @Default(0) numOfApplications,
  }) = _ConsumerDataEntity;

  factory ConsumerDataEntity.fromJson(Map<String, dynamic> json) =>
      _$ConsumerDataEntityFromJson(json);
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
