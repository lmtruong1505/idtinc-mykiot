import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../../data/mapper/debt_report_mapper.dart';
import '../entities/debt_report_entity.dart';
import '../repositories/debt_repository.dart';

@injectable
class DebtReportUseCase extends BaseFutureUseCase<DebtReportInput, DebtReportOutput> {
  DebtReportUseCase(
    this._debtRepository,
    this._debtReportMapper,
  );
  final DebtRepository _debtRepository;
  final DebtReportMapper _debtReportMapper;

  @override
  Future<DebtReportOutput> buildUseCase(DebtReportInput input) async {
    final res = await _debtRepository.report(
      status: input.status,
      company: input.company,
      type: input.type,
    );
    final dataEntity = _debtReportMapper.mapToEntity(res.data);
    final output = DebtReportOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class DebtReportInput extends BaseInput {
  final int company;
  final String? status;
  final String? type;
  DebtReportInput({
    required this.company,
    this.type,
    this.status,
  });
}

class DebtReportOutput extends BaseOutput {
  final BaseResponseModel<DebtReportEntity> response;
  DebtReportOutput({required this.response});
}
