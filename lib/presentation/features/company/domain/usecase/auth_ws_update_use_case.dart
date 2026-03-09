import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/auth_ws_entity.dart';
import '../repositories/auth_ws_repository.dart';

@injectable
class AuthWsUpdateUseCase
    extends BaseFutureUseCase<AuthWsUpdateInput, AuthWsUpdateOutput> {
  AuthWsUpdateUseCase(this._authWsRepository);
  final AuthWsRepository _authWsRepository;

  @override
  Future<AuthWsUpdateOutput> buildUseCase(AuthWsUpdateInput input) async {
    final res = await _authWsRepository.updateAuthWs(
      id: input.wsId,
      password: input.password,
    );
    return AuthWsUpdateOutput(res);
  }
}

class AuthWsUpdateInput extends BaseInput {
  final int wsId;
  final String password;
  AuthWsUpdateInput({
    required this.wsId,
    required this.password,
  });
}

class AuthWsUpdateOutput extends BaseOutput {
  final BaseResponseModel<AuthWsEntity> response;
  AuthWsUpdateOutput(this.response);
}
