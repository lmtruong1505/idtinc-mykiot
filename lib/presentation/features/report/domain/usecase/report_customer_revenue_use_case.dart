import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/customer_revenue_report_mapper.dart';
import '../entities/customer_report_revenue_entity.dart';
import '../repositories/report_repository.dart';

@injectable
class ReportCustomerRevenueUseCase
    extends BaseFutureUseCase<ReportCustomerRevenueInput, ReportCustomerRevenueOutput> {
  @override
  Future<ReportCustomerRevenueOutput> buildUseCase(ReportCustomerRevenueInput input) async {
    final res = await _reportRepository.customerRevenueReport(
      company: input.company,
      filter: input.filter,
      startDate: input.startDate,
      endDate: input.endDate,
    );

    final dataEntity = _itemReportMapper.mapToEntity(res.data);
    return ReportCustomerRevenueOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
    );

  }

  ReportCustomerRevenueUseCase(
    this._reportRepository,
    this._itemReportMapper,
  );

  final ReportRepository _reportRepository;
  final CustomerRevenueReportMapper _itemReportMapper;
}

class ReportCustomerRevenueInput extends BaseInput {
  ReportCustomerRevenueInput({
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

class ReportCustomerRevenueOutput extends BaseOutput {
  final BaseResponseModel<ReportCustomerRevenueEntity> response;

  ReportCustomerRevenueOutput({required this.response});
}
