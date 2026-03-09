import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../data/models/base/response.dart';
import '../../domain/usecase/send_code_use_case.dart';
import '../../domain/usecase/verify_account_use_case.dart';
import 'verify_account_state.dart';

@injectable
class VerifyAccountCubit extends Cubit<VerifyAccountState> {
  VerifyAccountCubit(
    this._verifyAccountUsecase,
    this._sendCodeUseCase,
  ) : super(const VerifyAccountState());

  final VerifyAccountUsecase _verifyAccountUsecase;
  final SendCodeUseCase _sendCodeUseCase;

  void init(int idVerify) {
    emit(
      state.copyWith(
        idVerify: idVerify,
      ),
    );
  }

  void codeChange(String code) {
    emit(state.copyWith(code: code));
  }

  Future<BaseResponseModel<bool>> verifyAccount() async {
    final input = VerifyAccountInput(
      idVerify: state.idVerify,
      secretCode: state.code,
    );
    final res = await _verifyAccountUsecase.execute(input);
    return res.response;
  }

  resendCode(String phone) async {
    final input = SendCodeInput(phone: phone);
    final res = await _sendCodeUseCase.execute(input);
    if (res.response.code == 200) {
      emit(state.copyWith(idVerify: res.response.data!));
    }

    print(res.response.code);

    return res.response.code;
  }
}
