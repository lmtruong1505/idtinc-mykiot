
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_payment_payload_entity.freezed.dart';
part 'order_payment_payload_entity.g.dart';

@freezed
class OrderPaymentPayloadEntity with _$OrderPaymentPayloadEntity {
  const OrderPaymentPayloadEntity._();

  const factory OrderPaymentPayloadEntity({
    @JsonKey(name: 'must_paid')
    @Default(0) double mustPaid,
    @JsonKey(name: 'had_paid')
    @Default(0) double hadPaid,
    @JsonKey(name: 'need_pay')
    @Default(0) double needPay, 
  }) = _OrderPaymentPayloadEntity;

  factory OrderPaymentPayloadEntity.fromJson(Map<String, dynamic> json) => _$OrderPaymentPayloadEntityFromJson(json);
}