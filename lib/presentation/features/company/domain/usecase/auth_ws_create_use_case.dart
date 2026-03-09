import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/auth_ws_entity.dart';
import '../repositories/auth_ws_repository.dart';

@injectable
class AuthWsCreateUseCase
    extends BaseFutureUseCase<AuthWsCreateInput, AuthWsCreateOutput> {
  AuthWsCreateUseCase(this._authWsRepository);
  final AuthWsRepository _authWsRepository;

  @override
  Future<AuthWsCreateOutput> buildUseCase(AuthWsCreateInput input) async {
    final res = await _authWsRepository.createAuthWs(
      id: input.wsId,
      password: input.password,
      endDate: input.endDate,
    );
    return AuthWsCreateOutput(res);
  }
}

class AuthWsCreateInput extends BaseInput {
  final int wsId;
  final String password;
  final DateTime? endDate;
  AuthWsCreateInput({
    required this.wsId,
    required this.password,
    this.endDate,
  });
}

class AuthWsCreateOutput extends BaseOutput {
  final BaseResponseModel<AuthWsEntity> response;
  AuthWsCreateOutput(this.response);
}
