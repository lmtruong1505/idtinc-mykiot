import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/authentication/domain/usecase/check_mail_use_case.dart';
import 'package:pharmago/presentation/features/authentication/domain/usecase/reset_password_use_case.dart';
import 'package:pharmago/presentation/features/authentication/domain/usecase/send_code_use_case.dart';
import 'package:pharmago/presentation/features/authentication/domain/usecase/verify_code_use_case.dart';

import '../../../../../data/models/base/response.dart';
import 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(
    this._resetPasswordUseCase,
    this._checkMailUseCase,
    this._sendCodeUseCase,
    this._verifyCodeUseCase,
  ) : super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPasswordUseCase;
  final CheckMailUseCase _checkMailUseCase;
  final SendCodeUseCase _sendCodeUseCase;
  final VerifyCodeUseCase _verifyCodeUseCase;

  Timer? timer;

  void phoneChange(String value) {
    emit(
      state.copyWith(
        phone: value,
        status: TypeChecking.isChecking,
      ),
    );

    if (timer != null) {
      timer?.cancel();
    }

    timer = Timer(const Duration(milliseconds: 500), () {
      _checkMail();
    });
  }

  void codeChange(String value) {
    emit(state.copyWith(code: value));
  }

  void passwordChange({
    String? password,
    String? confirmPassword,
  }) {
    emit(
      state.copyWith(
        password: password ?? state.password,
        confirmPassword: confirmPassword ?? state.confirmPassword,
      ),
    );
  }

  void showPasswordChange() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  Future<void> _checkMail() async {
    final input = CheckMailInput(email: state.phone);
    final res = await _checkMailUseCase.execute(input);
    if (res.response.code == 200) {
      emit(state.copyWith(status: TypeChecking.success));
    } else {
      emit(state.copyWith(status: TypeChecking.notFound));
    }
  }

  Future<void> sendCode() async {
    final input = SendCodeInput(phone: state.phone);
    final res = await _sendCodeUseCase.execute(input);
    if (res.response.code == 200) {
      emit(
        state.copyWith(
          idVerify: res.response.data,
        ),
      );
    }
  }

  Future<BaseResponseModel?> verifyCode() async {
    if (state.idVerify == null) return null;
    final input = VerifyCodeInput(id: state.idVerify!, code: state.code);
    final res = await _verifyCodeUseCase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel> changePassword() async {
    final input = ResetPasswordInput(
      id: state.idVerify!,
      code: state.code,
      password: state.password,
    );
    final res = await _resetPasswordUseCase.execute(input);
    return res.response;
  }
}
