import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../repositories/authentication_repository.dart';

@injectable
class ResetPasswordUseCase
    extends BaseFutureUseCase<ResetPasswordInput, ResetPasswordOutput> {
  ResetPasswordUseCase(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<ResetPasswordOutput> buildUseCase(ResetPasswordInput input) async {
    final res = await _authenticationRepository.resetPassword(
      idVerify: input.id,
      codeVerify: input.code,
      password: input.password,
    );
    final output = ResetPasswordOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
      ),
    );
    return output;
  }
}

class ResetPasswordInput extends BaseInput {
  final int id;
  final String code;
  final String password;
  ResetPasswordInput({
    required this.id,
    required this.code,
    required this.password,
  });
}

class ResetPasswordOutput extends BaseOutput {
  final BaseResponseModel response;
  ResetPasswordOutput({required this.response});
}
