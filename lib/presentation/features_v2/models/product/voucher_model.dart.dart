import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher_model.dart.freezed.dart';
part 'voucher_model.dart.g.dart';

@freezed
class VoucherModel with _$VoucherModel {
  const factory VoucherModel({
    final int? id,
    final String? title,
    final String? code,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    final String? description,
    @JsonKey(name: 'attach_files') final String? attachFiles,
    @JsonKey(name: 'apply_promotion') final num? applyPromotion,
    @JsonKey(name: 'promotion_number') final dynamic promotionNumber,
    @JsonKey(name: 'same_time') final bool? sameTime,
    @JsonKey(name: 'many_time') final bool? manyTime,
    final num? priority,
    @JsonKey(name: 'variant_consumer') final dynamic variantConsumer,
    final num? status,
    final num? company,
    final num? system,
    @JsonKey(name: 'promotion_type') final num? type,
    @JsonKey(name: 'variant_consumer_data') final dynamic variantConsumerData,
    @JsonKey(name: 'promotion_type_data')
    final PromotionType? promotionTypeData,
    @JsonKey(name: 'status_data') final PromotionType? statusData,
    @JsonKey(name: 'promotion_item_data')
    final List<PromotionVoucherItem>? promotionItems,
  }) = _VoucherModel;

  factory VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);
}

@freezed
class PromotionType with _$PromotionType {
  const factory PromotionType({
    int? id,
    String? title,
    String? code,
  }) = _PromotionType;

  factory PromotionType.fromJson(Map<String, dynamic> json) =>
      _$PromotionTypeFromJson(json);
}

@freezed
class StatusData with _$StatusData {
  const factory StatusData({
    int? id,
    String? title,
    String? code,
  }) = _StatusData;

  factory StatusData.fromJson(Map<String, dynamic> json) =>
      _$StatusDataFromJson(json);
}

@freezed
class PromotionVoucherItem with _$PromotionVoucherItem {
  const factory PromotionVoucherItem({
    final int? id,
    @JsonKey(name: 'value_min') final num? valueMin,
    @JsonKey(name: 'value_max') final num? valueMax,
    final num? quantity,
    final dynamic price,
    @JsonKey(name: 'discount_value') final num? discount,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'variant_value_data') final List<dynamic>? variantValueData,
    @JsonKey(name: 'promotion_value_data')
    final PromotionValue? promotionValueData,
    @JsonKey(name: 'type_discount_data')
    final TypeDiscountData? typeDiscountData,
    @JsonKey(name: 'promotion_value') final num? promotionValue,
    final num? promotion,
    @JsonKey(name: 'type_discount') final num? type,
  }) = _PromotionVoucherItem;

  factory PromotionVoucherItem.fromJson(Map<String, dynamic> json) =>
      _$PromotionVoucherItemFromJson(json);
}

@freezed
class PromotionValue with _$PromotionValue {
  const factory PromotionValue({
    int? id,
    String? title,
    @JsonKey(name: 'promotion_type') int? type,
  }) = _PromotionValue;

  factory PromotionValue.fromJson(Map<String, dynamic> json) =>
      _$PromotionValueFromJson(json);
}

@freezed
class TypeDiscountData with _$TypeDiscountData {
  const factory TypeDiscountData({
    int? id,
    String? title,
  }) = _TypeDiscountData;

  factory TypeDiscountData.fromJson(Map<String, dynamic> json) =>
      _$TypeDiscountDataFromJson(json);
}
