import 'package:freezed_annotation/freezed_annotation.dart';

import 'variant_wm_entity.dart';

part 'order_wm_entity.freezed.dart';
part 'order_wm_entity.g.dart';

@freezed
class OrderWmDetailEntity with _$OrderWmDetailEntity {
  const OrderWmDetailEntity._();

  const factory OrderWmDetailEntity({
    @Required() int? id,
    int? dloId,
    @Default('') String title,
    @Default('') String note,
    @Default('') String noteCancel,
    @Required() String? code,
    @Default(0) num total,
    @Default(0) num discount,
    @Required() OrderWmStatusEntity? orderStatus,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @Required() DateTime? createAt,
    // @JsonKey(name: 'customer_data') CustomerEntity? customerData,
    // @JsonKey(name: 'account_data') CustomerEntity? senderData,
    // @Required() ShopDataEnity? shopData,
    @Default(<OrderItemEntity>[]) List<OrderItemEntity> variants,
    @Default(<DiscountOrderEntity>[]) List<DiscountOrderEntity> discountOrder,
    @Default(false) bool isQRPayment,
    // @Default(StatusPayment.unpaid) StatusPayment statusPayment,
    // @Default(null) QrCodePayment? qrCodePayment,
    @Default(false) bool orderRed,
  }) = _OrderWmDetailEntity;

  factory OrderWmDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderWmDetailEntityFromJson(json);
}

@freezed
class OrderWmStatusEntity with _$OrderWmStatusEntity {
  const OrderWmStatusEntity._();

  const factory OrderWmStatusEntity({
    @Default('') String title,
    @Default('') String code,
    @Default(0) int id,
  }) = _OrderWmStatusEntity;

  factory OrderWmStatusEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderWmStatusEntityFromJson(json);
}

@freezed
class DiscountOrderEntity with _$DiscountOrderEntity {
  const DiscountOrderEntity._();

  factory DiscountOrderEntity({
    int? id,
    @JsonKey(name: 'promotion_title') String? title,
    @JsonKey(name: 'times_apply_promotion') int? timesApplyPromotion,
    @JsonKey(name: 'discount_value') double? discountValue,
    @JsonKey(name: 'type_discount') String? typeDiscount,
    @JsonKey(name: 'value_min') double? valueMin,
  }) = _DiscountOrderEntity;

  factory DiscountOrderEntity.fromJson(Map<String, dynamic> json) =>
      _$DiscountOrderEntityFromJson(json);
}

@freezed
class ShopDataEnity with _$ShopDataEnity {
  const ShopDataEnity._();

  const factory ShopDataEnity({
    @Required() String? name,
    @Required() String? phone,
    @Required() String? address,
  }) = _ShopDataEnity;

  factory ShopDataEnity.fromJson(Map<String, dynamic> json) =>
      _$ShopDataEnityFromJson(json);
}

@freezed
class OrderItemEntity with _$OrderItemEntity {
  const OrderItemEntity._();

  const factory OrderItemEntity({
    @Default(null) int? id,
    @Required() String? name,
    @Required() int? amount,
    @Required() int? quantityInStock,
    @Required() int? priceSell,
    @Required() String? image,
    String? models,
    @Required() int? type,
    @Default({}) Map promotions,
    int? variantParentPromo,
    VariantWmEntity? variant,
  }) = _OrderItemEntity;

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderItemEntityFromJson(json);
}
