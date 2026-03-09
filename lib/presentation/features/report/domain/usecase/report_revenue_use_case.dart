import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/report/data/mapper/revenue_report_mapper.dart';
import 'package:pharmago/presentation/features/report/domain/entities/revenue_report_entity.dart';
import 'package:pharmago/presentation/features/report/domain/repositories/report_repository.dart';

@injectable
class ReportRevenueUseCase
    extends BaseFutureUseCase<ReportRevenueInput, ReportRevenueOutput> {
  ReportRevenueUseCase(
    this._reportRepository,
    this._revenueReportMapper,
  );

  final ReportRepository _reportRepository;
  final RevenueReportMapper _revenueReportMapper;

  @override
  Future<ReportRevenueOutput> buildUseCase(ReportRevenueInput input) async {
    final res = await _reportRepository.revenueReport(
      company: input.company,
      filter: input.filter,
    );
    final dataEntity = _revenueReportMapper.mapToListEntity(res.data);
    final output = ReportRevenueOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
    );
    return output;
  }
}

class ReportRevenueInput extends BaseInput {
  final int company;
  final String filter;
  ReportRevenueInput({required this.company, required this.filter});
}

class ReportRevenueOutput extends BaseOutput {
  final BaseResponseModel<List<RevenueReportEntity>> response;
  ReportRevenueOutput({required this.response});
}
