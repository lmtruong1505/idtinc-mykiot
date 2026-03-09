import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../repositories/authentication_repository.dart';

@injectable
class SendCodeUseCase extends BaseFutureUseCase<SendCodeInput, SendCodeOutput> {
  SendCodeUseCase(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<SendCodeOutput> buildUseCase(SendCodeInput input) async {
    final res = await _authenticationRepository.sendCode(phone: input.phone);
    final output = SendCodeOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class SendCodeInput extends BaseInput {
  final String phone;
  SendCodeInput({required this.phone});
}

class SendCodeOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  SendCodeOutput({required this.response});
}
