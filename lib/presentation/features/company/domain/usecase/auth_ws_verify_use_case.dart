import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/auth_ws_repository.dart';

@injectable
class AuthWsVerifyUseCase
    extends BaseFutureUseCase<AuthWsVerifyInput, AuthWsVerifyOutput> {
  AuthWsVerifyUseCase(this._authWsRepository);
  final AuthWsRepository _authWsRepository;

  @override
  Future<AuthWsVerifyOutput> buildUseCase(AuthWsVerifyInput input) async {
    final res = await _authWsRepository.verifyAuthWs(
      id: input.wsId,
      password: input.password,
    );
    return AuthWsVerifyOutput(res);
  }
}

class AuthWsVerifyInput extends BaseInput {
  final int wsId;
  final String password;
  AuthWsVerifyInput({
    required this.wsId,
    required this.password,
  });
}

class AuthWsVerifyOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  AuthWsVerifyOutput(this.response);
}
