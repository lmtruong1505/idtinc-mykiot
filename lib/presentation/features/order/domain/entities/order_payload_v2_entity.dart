import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_payload_v2_entity.freezed.dart';
part 'order_payload_v2_entity.g.dart';

@freezed
class OrderPayloadV2Entity with _$OrderPayloadV2Entity {
  const OrderPayloadV2Entity._();

  const factory OrderPayloadV2Entity({
    int? customer,
    String? description,
    double? vat,
    @JsonKey(name: 'is_send_red_invoice')
    bool? red,
    String? type,
    int? company,
    @JsonKey(name: 'mb_uuid')
    String? mbUuid,
  }) = _OrderPayloadV2Entity;

  factory OrderPayloadV2Entity.fromJson(Map<String, dynamic> json) => _$OrderPayloadV2EntityFromJson(json);
}
