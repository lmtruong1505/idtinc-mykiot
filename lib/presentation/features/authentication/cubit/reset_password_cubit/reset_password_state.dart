import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default('') String phone,
    @Default('') String code,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool showPassword,
    @Default(TypeChecking.unCheck) TypeChecking status,
    int? idVerify,
  }) = _ResetPasswordState;
}

enum TypeChecking {
  unCheck,
  isChecking,
  success,
  notFound,
}
