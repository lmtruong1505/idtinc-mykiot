

import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_service_item_payload_entity.freezed.dart';
part 'order_service_item_payload_entity.g.dart';

@freezed
class OrderServiceItemPayloadEntity with _$OrderServiceItemPayloadEntity {
  const OrderServiceItemPayloadEntity._();

  const factory OrderServiceItemPayloadEntity({
    @Required() int? service,
    @JsonKey(name: 'unit_price')
    double? unitPrice,
    double? discount,
    @JsonKey(name: 'total_price')
    double? totalPrice,
    int? quantity,
  }) = _OrderServiceItemPayloadEntity;

  factory OrderServiceItemPayloadEntity.fromJson(Map<String, dynamic> json) => _$OrderServiceItemPayloadEntityFromJson(json);
}