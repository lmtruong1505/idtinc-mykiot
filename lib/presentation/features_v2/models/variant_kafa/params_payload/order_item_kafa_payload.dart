import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_kafa_payload.freezed.dart';
part 'order_item_kafa_payload.g.dart';

@freezed
class OrderItemKafaPayload with _$OrderItemKafaPayload {
  const OrderItemKafaPayload._();

  const factory OrderItemKafaPayload({
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
    @Default(0) num minValueApply,
    @Default(0) double price,
  }) = _OrderItemKafaPayload;

  factory OrderItemKafaPayload.fromJson(Map<String, dynamic> json) => _$OrderItemKafaPayloadFromJson(json);
}

@freezed
class KafaOrderPayload with _$KafaOrderPayload {
  const KafaOrderPayload._();

  const factory KafaOrderPayload({
    @Default(OrderKafaInfo()) OrderKafaInfo? order,
    @Default([]) List<OrderItemKafaPayload> items,
  }) = _KafaOrderPayload;

  factory KafaOrderPayload.fromJson(Map<String, dynamic> json) => _$KafaOrderPayloadFromJson(json);
}

@freezed
class OrderKafaInfo with _$OrderKafaInfo {
  const OrderKafaInfo._();

  const factory OrderKafaInfo({
    double? total,
    double? costs,
    double? discount,
    @JsonKey(name: 'red_invoice')
    bool? redInvoice,
    @Default([]) List<int> promotions,
    int? company,
    @Default([]) List<OrderItemKafaPayload> discountOrder,
  }) = _OrderKafaInfo;

  factory OrderKafaInfo.fromJson(Map<String, dynamic> json) => _$OrderKafaInfoFromJson(json);
}


