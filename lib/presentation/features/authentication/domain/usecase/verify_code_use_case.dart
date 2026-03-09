import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../repositories/authentication_repository.dart';

@injectable
class VerifyCodeUseCase
    extends BaseFutureUseCase<VerifyCodeInput, VerifyCodeOutput> {
  VerifyCodeUseCase(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<VerifyCodeOutput> buildUseCase(VerifyCodeInput input) async {
    final res = await _authenticationRepository.verifyCode(
      id: input.id,
      code: input.code,
    );
    final output = VerifyCodeOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
      ),
    );
    return output;
  }
}

class VerifyCodeInput extends BaseInput {
  final int id;
  final String code;
  VerifyCodeInput({required this.id, required this.code});
}

class VerifyCodeOutput extends BaseOutput {
  final BaseResponseModel response;
  VerifyCodeOutput({required this.response});
}
