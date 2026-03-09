

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/account/domain/repositories/account_repository.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

@injectable
class CheckTokenUseCase extends BaseFutureUseCase<CheckTokenInput, CheckTokenOutput> {
  CheckTokenUseCase(this._accountRepository);

  final AccountRepository _accountRepository;

  @override
  Future<CheckTokenOutput> buildUseCase(CheckTokenInput input) async {
    final token = AppSharedPreference.instance.getValue(PrefKeys.token) as String?;
    final res = await _accountRepository.checkToken(token!);
    return CheckTokenOutput(res);
  }
}

class CheckTokenInput extends BaseInput {

}

class CheckTokenOutput extends BaseOutput {
  final BaseResponseModel<DateTime> response;
  CheckTokenOutput(this.response);
}