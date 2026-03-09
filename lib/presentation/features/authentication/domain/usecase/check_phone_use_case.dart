

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../repositories/authentication_repository.dart';

@injectable
class CheckPhoneUseCase extends BaseFutureUseCase<CheckPhoneInput, CheckPhoneOutput> {
  CheckPhoneUseCase(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;
  
  @override
  Future<CheckPhoneOutput> buildUseCase(CheckPhoneInput input) async {
    final res = await _authenticationRepository.checkPhone(phone: input.phone);
    final output = CheckPhoneOutput(response: BaseResponseModel(
      code: res.code,
      message: res.message,
    ),);
    return output;
  }
}

class CheckPhoneInput extends BaseInput {
  final String phone;
  CheckPhoneInput({required this.phone});
}

class CheckPhoneOutput extends BaseOutput {
  final BaseResponseModel response;
  CheckPhoneOutput({required this.response});
}