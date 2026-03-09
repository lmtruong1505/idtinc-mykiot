

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/auth_ws_entity.dart';
import '../repositories/auth_ws_repository.dart';

@injectable
class AuthWsGetUseCase extends BaseFutureUseCase<AuthWsGetInput, AuthWsGetOutput> {
  AuthWsGetUseCase(this._authWsRepository);
  final AuthWsRepository _authWsRepository;
  
  @override
  Future<AuthWsGetOutput> buildUseCase(AuthWsGetInput input) async {
    final res = await _authWsRepository.getAuthWs(input.wsId);
    return AuthWsGetOutput(res);
  }

}

class AuthWsGetInput extends BaseInput {
  final int wsId;
  AuthWsGetInput(this.wsId);
}

class AuthWsGetOutput extends BaseOutput {
  final BaseResponseModel<AuthWsEntity> response;
  AuthWsGetOutput(this.response);
}