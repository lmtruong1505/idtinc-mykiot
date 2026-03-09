import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_order_payload_v2_entity.freezed.dart';

part 'item_order_payload_v2_entity.g.dart';

@freezed
class ItemOrderPayloadV2Entity with _$ItemOrderPayloadV2Entity {
  const ItemOrderPayloadV2Entity._();

  const factory ItemOrderPayloadV2Entity({
    @JsonKey(name: 'item_id') int? id,
    int? quantity,
    @JsonKey(name: 'unit_price') double? unitPrice,
    double? discount,
    int? unit,
    int? level,
  }) = _ItemOrderPayloadV2Entity;

  factory ItemOrderPayloadV2Entity.fromJson(Map<String, dynamic> json) =>
      _$ItemOrderPayloadV2EntityFromJson(json);
}
