import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/authentication_repository.dart';

@injectable
class RegisterUseCase extends BaseFutureUseCase<RegisterInput, RegisterOuput> {
  final AuthenticationRepository _authnticationRepocitory;
  RegisterUseCase(
    this._authnticationRepocitory,
  );
  @override
  Future<RegisterOuput> buildUseCase(RegisterInput input) async {
    final res = await _authnticationRepocitory.register(
      fullName: input.fullName,
      email: input.email,
      password: input.password,
      phone: input.phone,
      accountType: input.accountType,
      code: input.code,
    );
    return RegisterOuput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        extra: res.extra,
      ),
    );
  }
}

class RegisterInput extends BaseInput {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String accountType;
  final String? code;

  RegisterInput({
    required this.email,
    required this.fullName,
    required this.password,
    required this.phone,
    required this.accountType,
    required this.code,
  });
}

class RegisterOuput extends BaseOutput {
  final BaseResponseModel response;
  RegisterOuput({required this.response});
}
