import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/item_report_mapper.dart';
import '../entities/item_report_entity.dart';
import '../repositories/report_repository.dart';

@injectable
class ReportCustomerUseCase
    extends BaseFutureUseCase<ReportCustomerInput, ReportCustomerOutput> {
  @override
  Future<ReportCustomerOutput> buildUseCase(ReportCustomerInput input) async {
    final res = await _reportRepository.customerReport(
      company: input.company,
      filter: input.filter,
      startDate: input.startDate,
      endDate: input.endDate,
    );

    final dataEntity = _itemReportMapper.mapToListEntity(res.data);
    return ReportCustomerOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
    );

  }

  ReportCustomerUseCase(
    this._reportRepository,
    this._itemReportMapper,
  );

  final ReportRepository _reportRepository;
  final ItemReportMapper _itemReportMapper;
}

class ReportCustomerInput extends BaseInput {
  ReportCustomerInput({
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

class ReportCustomerOutput extends BaseOutput {
  final BaseResponseModel<List<ItemReportEntity>> response;

  ReportCustomerOutput({required this.response});
}
