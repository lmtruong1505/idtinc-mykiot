import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../../data/models/payload/debt_repayment_payload.dart';
import '../repositories/repayment_repository.dart';

@injectable
class DebtRepaymentCreateUseCase extends BaseFutureUseCase<
    DebtRepaymentCreateInput, DebtRepaymentCreateOutput> {
  DebtRepaymentCreateUseCase(this._repaymentRepository);
  final RepaymentRepository _repaymentRepository;

  @override
  Future<DebtRepaymentCreateOutput> buildUseCase(
      DebtRepaymentCreateInput input) async {
    final data = DebtRepaymentPayload(
      debt: input.debt,
      money: input.money,
    );
    final res = await _repaymentRepository.create(data: data);
    return DebtRepaymentCreateOutput(
      response: res,
    );
  }
}

class DebtRepaymentCreateInput extends BaseInput {
  final int? debt;
  final double? money;
  DebtRepaymentCreateInput({this.money, this.debt});
}

class DebtRepaymentCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  DebtRepaymentCreateOutput({required this.response});
}
