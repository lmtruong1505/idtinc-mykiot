import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool rememberPassword,
    @Default(false) bool showPassword,
    @Default('') String username,
    @Default('') String password,
  }) = _LoginState;
}
