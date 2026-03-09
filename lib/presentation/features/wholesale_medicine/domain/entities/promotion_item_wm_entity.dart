import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_item_wm_entity.freezed.dart';
part 'promotion_item_wm_entity.g.dart';

@freezed
class PromotionItemEntity with _$PromotionItemEntity {
  const factory PromotionItemEntity({
    @Default(1) int promotion,
    @Default(0.0) double discount,
    @Default(0) int quantity,
    @Default(1) int typeDiscount,
  }) = _PromotionItemEntity;

  factory PromotionItemEntity.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemEntityFromJson(json);
}