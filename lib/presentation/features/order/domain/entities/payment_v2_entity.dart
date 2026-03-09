import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_v2_entity.freezed.dart';


@freezed
class PaymentV2Entity with _$PaymentV2Entity {
  const PaymentV2Entity._();

  const factory PaymentV2Entity({
    int? id,
    double? amount,
    PaymentMethod? method,
  }) = _PaymentV2Entity;

}

enum PaymentMethod {
  cash('Tiền mặt', 'cash'),
  bank('Chuyển khoản', 'bank');

  const PaymentMethod(this.name, this.code);
  final String name;
  final String code;
}
