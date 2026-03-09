
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_report_model.freezed.dart';
part 'debt_report_model.g.dart';

@freezed
class DebtReportModel with _$DebtReportModel {
  const DebtReportModel._();

  factory DebtReportModel({
    List<DebtReportChartModel>? chart,
    List<DebtReportRevenueModel>? revenue,
  }) = _DebtReportModel;

  factory DebtReportModel.fromJson(Map<String, dynamic> json) => _$DebtReportModelFromJson(json);
}

@freezed
class DebtReportChartModel with _$DebtReportChartModel {
  const DebtReportChartModel._();

  factory DebtReportChartModel({
    DateTime? date,
    int? ticket,
    double? money,
  }) = _DebtReportChartModel;

  factory DebtReportChartModel.fromJson(Map<String, dynamic> json) => _$DebtReportChartModelFromJson(json);
}

@freezed
class DebtReportRevenueModel with _$DebtReportRevenueModel {
  const DebtReportRevenueModel._();

  factory DebtReportRevenueModel({
    String? type,
    int? quantity,
    double? money,
  }) = _DebtReportRevenueModel;

  factory DebtReportRevenueModel.fromJson(Map<String, dynamic> json) => _$DebtReportRevenueModelFromJson(json);
}