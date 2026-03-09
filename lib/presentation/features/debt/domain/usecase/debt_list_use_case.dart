import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/debt/data/mapper/debt_note_mapper.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_note_entity.dart';
import 'package:pharmago/presentation/features/debt/domain/repositories/debt_repository.dart';

@injectable
class DebtListUseCase extends BaseFutureUseCase<DebtListInput, DebtListOutput> {
  DebtListUseCase(
    this._debtRepository,
    this._debtNoteMapper,
  );
  final DebtRepository _debtRepository;
  final DebtNoteMapper _debtNoteMapper;

  @override
  Future<DebtListOutput> buildUseCase(DebtListInput input) async {
    final res = await _debtRepository.list(
      page: input.page,
      limit: input.limit,
      search: input.search,
      company: input.company,
      type: input.type,
    );
    final dataEntity = _debtNoteMapper.mapToListEntity(res.data);
    final output = DebtListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class DebtListInput extends BaseInput {
  final int company;
  final int? page;
  final int? limit;
  final String? type;
  final String? search;
  DebtListInput({
    required this.company,
    this.limit,
    this.page,
    this.type,
    this.search,
  });
}

class DebtListOutput extends BaseOutput {
  final BaseResponseModel<List<DebtNoteEntity>> response;
  DebtListOutput({required this.response});
}
