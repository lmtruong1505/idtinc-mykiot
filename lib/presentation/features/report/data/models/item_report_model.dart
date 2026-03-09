import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_report_model.freezed.dart';
part 'item_report_model.g.dart';

@freezed
class ItemReportModel with _$ItemReportModel {
  const ItemReportModel._();

  const factory ItemReportModel({
    String? title,
    int? value,
    @JsonKey(name: 'value_extra') int? valueExtra,
  }) = _ItemReportModel;

  factory ItemReportModel.fromJson(Map<String, dynamic> json) =>
      _$ItemReportModelFromJson(json);
}

@freezed
class ReportCustomerRevenueModel with _$ReportCustomerRevenueModel {
  const ReportCustomerRevenueModel._();

  const factory ReportCustomerRevenueModel({
    List<ItemReportCustomerRevenueModel>? details,
    int? total,
    num? average,
    num? averageRevenue,
  }) = _ReportCustomerRevenueModel;

  factory ReportCustomerRevenueModel.fromJson(Map<String, dynamic> json) =>
      _$ReportCustomerRevenueModelFromJson(json);
}

@freezed
class ItemReportCustomerRevenueModel with _$ItemReportCustomerRevenueModel {
  const ItemReportCustomerRevenueModel._();

  const factory ItemReportCustomerRevenueModel({
    int? id,
    @JsonKey(name: 'full_name') String? fullName,
    String? image,
    int? quantity,
    num? revenue,
  }) = _ItemReportCustomerRevenueModel;

  factory ItemReportCustomerRevenueModel.fromJson(Map<String, dynamic> json) =>
      _$ItemReportCustomerRevenueModelFromJson(json);
}
