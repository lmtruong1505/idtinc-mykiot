import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/bank_repository.dart';

import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class GetAccNameBankUseCase extends BaseFutureUseCase<GetAccNameBankInput, GetAccNameBankOutput> {
  GetAccNameBankUseCase(this._repo);
  final BankRepository _repo;

  @override
  Future<GetAccNameBankOutput> buildUseCase(GetAccNameBankInput input) async {
    final res = await _repo.getAccNameBank(bank: input.bank, accountNumber: input.accountNumber);
    return GetAccNameBankOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
  }
}

class GetAccNameBankInput extends BaseInput {
  final int bank;
  final String accountNumber;
  GetAccNameBankInput({
    required this.bank,
    required this.accountNumber,
  });
}

class GetAccNameBankOutput extends BaseOutput {
  final BaseResponseModel<String> response;
  GetAccNameBankOutput({
    required this.response,
  });
}