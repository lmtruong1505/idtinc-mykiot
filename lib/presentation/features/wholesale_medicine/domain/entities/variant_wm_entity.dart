import 'package:freezed_annotation/freezed_annotation.dart';

import 'promotion_detail_wm_entity.dart';
import 'promotion_item_wm_entity.dart';
part 'variant_wm_entity.freezed.dart';
part 'variant_wm_entity.g.dart';

@freezed
class VariantWmEntity with _$VariantWmEntity {
  const VariantWmEntity._();

  const factory VariantWmEntity({
    @Required() int? id,
    String? image,
    @Default('') String title,
    @Default('') String code,
    @Default('') String price,
    @Default(0) int amount,
    @Default(0) int amountRetail,
    @Default(0) int amountGift,
    @Default(0) int inventory,
    @Default(false) bool isChoose,
    @Default(0) int priceSell,
    @Default(0) int priceSellDefault,
    @Default(0) int priceSellUnit,
    // @Default(<OptionDataEntity>[]) List<OptionDataEntity> optionsData,
    @Default(null) PromotionItemEntity? promotionItem,
    List<PromotionDetailEntity>? promotionDetailEntity,
    PromotionDetailEntity? promotionDetailForCustomer,
    // PricePolicyEntity? pricePolicy,
  }) = _VariantWmEntity;

  factory VariantWmEntity.fromJson(Map<String, dynamic> json) =>
      _$VariantWmEntityFromJson(json);
}

// @freezed
// class PricePolicyEntity with _$PricePolicyEntity {
//   const PricePolicyEntity._();

//   const factory PricePolicyEntity({
//     List<PriceListEntity>? priceList,
//   }) = _PricePolicyEntity;

//   factory PricePolicyEntity.fromJson(Map<String, dynamic> json) => _$PricePolicyEntityFromJson(json);
// }
