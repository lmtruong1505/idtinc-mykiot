import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_report_model.dart';

part 'customer_report_model.freezed.dart';
part 'customer_report_model.g.dart';

@freezed
class CustomerReportModel with _$CustomerReportModel{
  const factory CustomerReportModel({
    @Default(<ItemReportModel>[]) List<ItemReportModel> items,
    @JsonKey(name: 'current_value')
    @Default(0) int? currentValue,
    @JsonKey(name: 'last_value')
    @Default(0) int? lastValue,
  }) = _CustomerReportModel;

  factory CustomerReportModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerReportModelFromJson(json);
}