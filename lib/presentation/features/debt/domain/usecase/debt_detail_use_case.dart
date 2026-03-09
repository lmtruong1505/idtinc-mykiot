import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/debt/data/mapper/debt_note_mapper.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_note_entity.dart';
import 'package:pharmago/presentation/features/debt/domain/repositories/debt_repository.dart';

@injectable
class DebtDetailUseCase extends BaseFutureUseCase<DebtDetailInput, DebtDetailOutput> {
  DebtDetailUseCase(
    this._debtRepository,
    this._debtNoteMapper,
  );
  final DebtRepository _debtRepository;
  final DebtNoteMapper _debtNoteMapper;

  @override
  Future<DebtDetailOutput> buildUseCase(DebtDetailInput input) async {
    final res = await _debtRepository.detail(
      debtId: input.id,
    );
    final dataEntity = _debtNoteMapper.mapToEntity(res.data);
    final output = DebtDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class DebtDetailInput extends BaseInput {
  final int id;
  DebtDetailInput({
    required this.id,
  });
}

class DebtDetailOutput extends BaseOutput {
  final BaseResponseModel<DebtNoteEntity> response;
  DebtDetailOutput({required this.response});
}
