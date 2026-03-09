import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_report_entity.freezed.dart';

@freezed
class DebtReportEntity with _$DebtReportEntity {
  const DebtReportEntity._();

  factory DebtReportEntity({
    List<DebtReportChartEntity>? chart,
    List<DebtReportRevenueEntity>? revenue,
  }) = _DebtReportEntity;
}

@freezed
class DebtReportChartEntity with _$DebtReportChartEntity {
  const DebtReportChartEntity._();

  factory DebtReportChartEntity({
    DateTime? date,
    int? ticket,
    double? money,
  }) = _DebtReportChartEntity;
}

@freezed
class DebtReportRevenueEntity with _$DebtReportRevenueEntity {
  const DebtReportRevenueEntity._();

  factory DebtReportRevenueEntity({
    String? type,
    int? quantity,
    double? money,
  }) = _DebtReportRevenueEntity;
}
