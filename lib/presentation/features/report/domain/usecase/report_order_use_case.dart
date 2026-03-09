import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/report/data/mapper/item_report_mapper.dart';
import 'package:pharmago/presentation/features/report/domain/entities/item_report_entity.dart';
import 'package:pharmago/presentation/features/report/domain/repositories/report_repository.dart';


@injectable
class ReportOrderUseCase
    extends BaseFutureUseCase<ReportOrderInput, ReportOrderOutput> {
  @override
  Future<ReportOrderOutput> buildUseCase(ReportOrderInput input) async {
    final res = await _reportRepository.orderReport(
      company: input.company,
      filter: input.filter,
      startDate: input.startDate,
      endDate: input.endDate,
    );
    final dataEntity = _itemReportMapper.mapToListEntity(res.data);
    return ReportOrderOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
    );
  }

  ReportOrderUseCase(
    this._reportRepository,
    this._itemReportMapper,
  );

  final ReportRepository _reportRepository;
  final ItemReportMapper _itemReportMapper;
}

class ReportOrderInput extends BaseInput {
  ReportOrderInput({
    required this.company,
    this.filter,
    this.startDate,
    this.endDate,
  });

  final int company;
  final String? filter;
  final String? startDate;
  final String? endDate;
}

class ReportOrderOutput extends BaseOutput {
  final BaseResponseModel<List<ItemReportEntity>> response;

  ReportOrderOutput({required this.response});
}
