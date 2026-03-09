import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/report/data/models/revenue_report_model.dart';
import 'package:pharmago/presentation/features/report/domain/entities/revenue_report_entity.dart';

@injectable
class RevenueReportMapper
    extends BaseDataMapper<RevenueReportModel, RevenueReportEntity> {
  RevenueReportMapper();
  @override
  RevenueReportEntity mapToEntity(RevenueReportModel? data) {
    return RevenueReportEntity(
      title: data?.title,
      value: data?.value,
      valueExtra: data?.valueExtra,
    );
  }
}
