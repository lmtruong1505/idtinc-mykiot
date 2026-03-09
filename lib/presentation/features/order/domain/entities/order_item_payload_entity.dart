

import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_payload_entity.freezed.dart';
part 'order_item_payload_entity.g.dart';

@freezed
class OrderItemPayloadEntity with _$OrderItemPayloadEntity {
  const OrderItemPayloadEntity._();

  const factory OrderItemPayloadEntity({
    @Required() int? variant,
    @Required() int? value,
    int? consignment,
    double? priceSell,
    double? discount,
    @JsonKey(name: 'total_price')
    double? totalPrice,
  }) = _OrderItemPayloadEntity;

  factory OrderItemPayloadEntity.fromJson(Map<String, dynamic> json) => _$OrderItemPayloadEntityFromJson(json);
}