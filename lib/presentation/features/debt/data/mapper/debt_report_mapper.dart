import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/debt/data/models/debt_report_model.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_report_entity.dart';

@injectable
class DebtReportMapper
    extends BaseDataMapper<DebtReportModel, DebtReportEntity> {
  @override
  DebtReportEntity mapToEntity(DebtReportModel? data) {
    return DebtReportEntity(
      chart: data?.chart
          ?.map(
            (e) => DebtReportChartEntity(
              date: e.date,
              money: e.money,
              ticket: e.ticket,
            ),
          )
          .toList(),
      revenue: data?.revenue
          ?.map(
            (e) => DebtReportRevenueEntity(
              money: e.money,
              quantity: e.quantity,
              type: e.type,
            ),
          )
          .toList(),
    );
  }
}
