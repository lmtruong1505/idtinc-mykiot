import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_report_entity.freezed.dart';

@freezed
class RevenueReportEntity with _$RevenueReportEntity {
  const RevenueReportEntity._();

  const factory RevenueReportEntity({
    DateTime? title,
    double? value,
    double? valueExtra,
  }) = _RevenueReportEntity;
}