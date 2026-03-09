import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_report_model.freezed.dart';
part 'revenue_report_model.g.dart';

@freezed
class RevenueReportModel with _$RevenueReportModel {
  const RevenueReportModel._();

  const factory RevenueReportModel({
    DateTime? title,
    double? value,
    @JsonKey(name: 'value_extra')
    double? valueExtra,
  }) = _RevenueReportModel;

  factory RevenueReportModel.fromJson(Map<String, dynamic> json) => _$RevenueReportModelFromJson(json);
}