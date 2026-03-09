import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class VerifyAccountUsecase
    extends BaseFutureUseCase<VerifyAccountInput, VerifyAccountOutput> {
  VerifyAccountUsecase(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<VerifyAccountOutput> buildUseCase(VerifyAccountInput input) async {
    final res = await _authenticationRepository.verify(
      secretCode: input.secretCode,
      idVerify: input.idVerify,
    );
    final output = VerifyAccountOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class VerifyAccountInput extends BaseInput {
  final String secretCode;
  final int idVerify;
  VerifyAccountInput({
    required this.idVerify,
    required this.secretCode,
  });
}

class VerifyAccountOutput extends BaseOutput {
  final BaseResponseModel<bool> response;
  VerifyAccountOutput({required this.response});
}
