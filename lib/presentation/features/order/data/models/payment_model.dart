

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const PaymentModel._();

  const factory PaymentModel({
    int? id,
    String? code,
    @JsonKey(name: 'must_paid')
    double? totalPrice,
    @JsonKey(name: 'had_paid')
    double? hadPaid,
    @JsonKey(name: 'need_pay')
    double? needPay,
    List<PaymentItemModel>? items,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}

@freezed
class PaymentItemModel with _$PaymentItemModel {
  const PaymentItemModel._();

  const factory PaymentItemModel({
    int? id,
    BasicModel? type,
    int? value,
    @JsonKey(name: 'is_paid')
    @Default(false) bool isPaid,
  }) = _PaymentItemModel;

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) => _$PaymentItemModelFromJson(json);
}