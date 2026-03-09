
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_payment_item_payload_entity.freezed.dart';
part 'order_payment_item_payload_entity.g.dart';

@freezed
class OrderPaymentItemPayloadEntity with _$OrderPaymentItemPayloadEntity {
  const OrderPaymentItemPayloadEntity._();

  const factory OrderPaymentItemPayloadEntity({
    @Required() String? type,
    String? title,
    @Default(0.0) double value,
    @JsonKey(name: 'is_paid')
    @Default(false) bool isPaid,
    @JsonKey(name: 'extra_note')
    @Default('') String extraNote,
  }) = _OrderPaymentItemPayloadEntity;

  factory OrderPaymentItemPayloadEntity.fromJson(Map<String, dynamic> json) => _$OrderPaymentItemPayloadEntityFromJson(json);
}