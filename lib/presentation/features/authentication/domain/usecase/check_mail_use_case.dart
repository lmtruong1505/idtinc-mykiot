

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../repositories/authentication_repository.dart';

@injectable
class CheckMailUseCase extends BaseFutureUseCase<CheckMailInput, CheckMailOutput> {
  CheckMailUseCase(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;
  
  @override
  Future<CheckMailOutput> buildUseCase(CheckMailInput input) async {
    final res = await _authenticationRepository.checkEmail(email: input.email);
    final output = CheckMailOutput(response: BaseResponseModel(
      code: res.code,
      message: res.message,
    ),);
    return output;
  }
}

class CheckMailInput extends BaseInput {
  final String email;
  CheckMailInput({required this.email});
}

class CheckMailOutput extends BaseOutput {
  final BaseResponseModel response;
  CheckMailOutput({required this.response});
}