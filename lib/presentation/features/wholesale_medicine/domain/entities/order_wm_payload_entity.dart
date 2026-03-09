import 'package:freezed_annotation/freezed_annotation.dart';

import 'variant_wm_entity.dart';
part 'order_wm_payload_entity.freezed.dart';
part 'order_wm_payload_entity.g.dart';

@freezed
class OrderWmCreatePayloadEntity with _$OrderWmCreatePayloadEntity {
  const OrderWmCreatePayloadEntity._();

  const factory OrderWmCreatePayloadEntity({
    @JsonKey(name: 'order')
    @Default(OrderWmInfoPayload())
    OrderWmInfoPayload order,
    @JsonKey(name: 'orderitem')
    @Default(<OrderWmItemPayload>[])
    List<OrderWmItemPayload> orderWmItemPayload,
  }) = _OrderWmCreatePayloadEntity;

  factory OrderWmCreatePayloadEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderWmCreatePayloadEntityFromJson(json);
}

@freezed
class OrderWmInfoPayload with _$OrderWmInfoPayload {
  const OrderWmInfoPayload._();

  const factory OrderWmInfoPayload({
    @Default('Đơn hàng') String title,
    @Default(0) double discount,
    @Default(null) int? customer,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @Default('') String note,
    @Default(0) int total,
    int? account,
    @JsonKey(name: 'order_red') @Default(false) bool orderRed,
    @JsonKey(name: 'tag_systems') String? tagSystem,
    @Default('0987775096') @JsonKey(name: 'user_system') String userPhone,
    @Default(1) @JsonKey(name: 'user_system_id') int userId,
    @Default([]) List<int> promotions,
    @JsonKey(name: 'discount_order') @Default([]) List<OrderWmItemPayload> discountOrder,
  }) = _OrderWmInfoPayload;

  factory OrderWmInfoPayload.fromJson(Map<String, dynamic> json) =>
      _$OrderWmInfoPayloadFromJson(json);
}

@freezed
class OrderWmItemPayload with _$OrderWmItemPayload {
  const OrderWmItemPayload._();

  const factory OrderWmItemPayload({
    @Default(0) int quantity,
    @Default(0) num discount,
    // Phân biệt giữa giảm tiền mặt : 1 và % : 2
    int? typeDiscount,
    int? variant,
    int? promotion,
    @Default(0) int type,
    @JsonKey(name: 'variant_promotion') int? variantPromotion,
    @JsonKey(name: 'promotion_order') int? promotionOrder,
    @JsonKey(name: 'promotion_item') int? promotionItem,
    @JsonKey(name: 'times_apply_promotion') int? timesApplyPromotion,
    @JsonKey(name: 'promotions') List<int>? promotions,
    // @JsonKey(name: 'price_list') List<PriceListEntity>? priceList,
    @Default(0) num minValueAplly,
    VariantWmEntity? variantData,
  }) = _OrderWmItemPayload;

  factory OrderWmItemPayload.fromJson(Map<String, dynamic> json) =>
      _$OrderWmItemPayloadFromJson(json);
}
