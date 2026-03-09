import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_v2_model.freezed.dart';
part 'payment_v2_model.g.dart';

@freezed
class PaymentV2Model with _$PaymentV2Model {
  const PaymentV2Model._();

  const factory PaymentV2Model({
    int? id,
    double? amount,
    String? method,
  }) = _PaymentV2Model;

  factory PaymentV2Model.fromJson(Map<String, dynamic> json) => _$PaymentV2ModelFromJson(json);
}
