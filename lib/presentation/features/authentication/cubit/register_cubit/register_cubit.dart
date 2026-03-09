import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/authentication/domain/usecase/check_phone_use_case.dart';
import 'package:pharmago/presentation/shared/constants/enums/type_account_enum.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../shared/utils/event.dart';
import '../../domain/usecase/check_mail_use_case.dart';
import '../../domain/usecase/register_use_case.dart';
import '../reset_password_cubit/reset_password_state.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(
    this._registerUseCase,
    this._checkPhoneUseCase,
    this._checkEmailUseCase,
  ) : super(const RegisterState());

  final RegisterUseCase _registerUseCase;
  final CheckPhoneUseCase _checkPhoneUseCase;
  final CheckMailUseCase _checkEmailUseCase;

  void accountTypeChange(AccountTypeEnum value) {
    emit(state.copyWith(accountType: value));
  }

  void nameChange(String value) {
    emit(state.copyWith(name: value));
  }

  void formRegisterChange({
    String? fullName,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
  }) {
    emit(
      state.copyWith(
        fullName: fullName ?? state.fullName,
        phone: phone ?? state.phone,
        email: email ?? state.email,
        password: password ?? state.password,
        confirmPassword: confirmPassword ?? state.confirmPassword,
        referral: code ?? state.referral,
      ),
    );
    // if (phone != null) {
    //   checkPhone();
    // } else if (email != null) {
    //   checkEmail();
    // }
  }

  void showPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void showConfirmPassword() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  Future<void> checkPhone() async {
    if (state.phone.length != 10) {
      return;
    }
    emit(state.copyWith(isCheckingPhone: true));
    final input = CheckPhoneInput(phone: state.phone);
    final res = await _checkPhoneUseCase.execute(input);
    late TypeChecking status;
    switch (res.response.code) {
      case 200:
        status = TypeChecking.success;
        break;
      case 5:
        status = TypeChecking.notFound;
        break;
      default:
        status = TypeChecking.unCheck;
        break;
    }
    emit(
      state.copyWith(
        isCheckingPhone: false,
        statusCheck: status,
      ),
    );
  }

  Future<void> checkEmail() async {
    final valid = isEmailValid(state.email);
    if (!valid) {
      return;
    }
    emit(state.copyWith(isCheckingEmail: true));
    final input = CheckMailInput(email: state.email);
    final res = await _checkEmailUseCase.execute(input);
    late TypeChecking status;
    switch (res.response.code) {
      case 200:
        status = TypeChecking.success;
        break;
      case 5:
        status = TypeChecking.notFound;
        break;
      default:
        status = TypeChecking.unCheck;
        break;
    }
    emit(
      state.copyWith(
        isCheckingEmail: false,
        statusCheckEmail: status,
      ),
    );
  }
}

extension HandleApi on RegisterCubit {
  Future<BaseResponseModel> register() async {
    final input = RegisterInput(
      email: state.email,
      fullName: state.fullName,
      password: state.password,
      phone: state.phone,
      accountType: state.accountType.code,
      code: state.referral,
    );
    final res = await _registerUseCase.execute(input);
    return res.response;
  }
}
