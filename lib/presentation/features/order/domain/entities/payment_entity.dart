

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/domain/entities/basic_entity.dart';

part 'payment_entity.freezed.dart';

@freezed
class PaymentItemEntity with _$PaymentItemEntity {
  const PaymentItemEntity._();

  const factory PaymentItemEntity({
    int? id,
    BasicEntity? type,
    int? value,
    @JsonKey(name: 'is_paid')
    @Default(false) bool isPaid,
  }) = _PaymentItemEntity;
}

@freezed
class PaymentEntity with _$PaymentEntity {
  const PaymentEntity._();

  const factory PaymentEntity({
    int? id,
    String? code,
    @JsonKey(name: 'must_paid')
    double? totalPrice,
    @JsonKey(name: 'had_paid')
    double? hadPaid,
    @JsonKey(name: 'need_pay')
    double? needPay,
    List<PaymentItemEntity>? items,
  }) = _PaymentEntity;
}