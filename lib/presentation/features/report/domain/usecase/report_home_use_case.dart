import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/report/data/mapper/home_report_mapper.dart';
import 'package:pharmago/presentation/features/report/domain/entities/home_report_entity.dart';
import 'package:pharmago/presentation/features/report/domain/repositories/report_repository.dart';

@injectable
class ReportHomeUseCase
    extends BaseFutureUseCase<ReportHomeInput, ReportHomeOutput> {
  ReportHomeUseCase(
    this._reportRepository,
    this._homeReportMapper,
  );

  final ReportRepository _reportRepository;
  final HomeReportMapper _homeReportMapper;

  @override
  Future<ReportHomeOutput> buildUseCase(ReportHomeInput input) async {
    final res = await _reportRepository.homeReport(
      company: input.company,
    );
    final dataEntity = _homeReportMapper.mapToEntity(res.data);
    final output = ReportHomeOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class ReportHomeInput extends BaseInput {
  final int company;
  ReportHomeInput(this.company);
}

class ReportHomeOutput extends BaseOutput {
  final BaseResponseModel<HomeReportEntity> response;
  ReportHomeOutput({required this.response});
}
