import 'package:freezed_annotation/freezed_annotation.dart';
part 'debt_repayment_payload.freezed.dart';
part 'debt_repayment_payload.g.dart';

@freezed
class DebtRepaymentPayload with _$DebtRepaymentPayload {
  const factory DebtRepaymentPayload({
    int? debt,
    double? money,
  }) = _DebtRepaymentPayload;
  factory DebtRepaymentPayload.fromJson(Map<String, dynamic> json) => _$DebtRepaymentPayloadFromJson(json);
}