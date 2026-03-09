import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_account_state.freezed.dart';

@freezed
class VerifyAccountState with _$VerifyAccountState {
  const factory VerifyAccountState({
    @Default('') String code,
    @Default(0) int idVerify,
  }) = _VerifyAccountState;
}
