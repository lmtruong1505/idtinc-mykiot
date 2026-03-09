import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import '../../domain/usecase/login_use_case.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._loginUseCase,
  ) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  void rememberPasswordHandle(bool? value) {
    if (value == null || !value) {
      AppSharedPreference.instance.setValue(PrefKeys.rememberPassword, false);
    }
    emit(state.copyWith(rememberPassword: value ?? false));
  }

  void showPasswordChange() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void fieldChange({
    String? username,
    String? password,
    bool? rememberPassword,
  }) {
    emit(
      state.copyWith(
        username: username ?? state.username,
        password: password ?? state.password,
        rememberPassword: rememberPassword ?? state.rememberPassword,
      ),
    );
  }

  Future<BaseResponseModel> login() async {
    final shared = AppSharedPreference.instance;
    final input = LoginInput(
      username: state.username,
      password: state.password,
    );
    final res = await _loginUseCase.execute(input);
    shared.setValue(PrefKeys.rememberPassword, state.rememberPassword);
    if (res.response.code == 200) {
      shared.setValue(PrefKeys.username, state.username);
      shared.setValue(PrefKeys.password, state.password);
    }
    return res.response;
  }
}
