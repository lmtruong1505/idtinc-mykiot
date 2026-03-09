import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/debt/data/models/payload/dept_note_payload.dart';
import 'package:pharmago/presentation/features/debt/domain/repositories/debt_repository.dart';

@injectable
class DebtCreateUseCase extends BaseFutureUseCase<DebtCreateInput, DebtCreateOutput> {
  DebtCreateUseCase(
    this._debtRepository,
  );
  final DebtRepository _debtRepository;

  @override
  Future<DebtCreateOutput> buildUseCase(DebtCreateInput input) async {
    final res = await _debtRepository.create(data: input.data);
    final output = DebtCreateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class DebtCreateInput extends BaseInput {
  final DebtNotePayload data;
  const DebtCreateInput({
    required this.data,
  });
}

class DebtCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  const DebtCreateOutput({required this.response});
}
