
import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_report_model.dart';

part 'order_report_model.freezed.dart';
part 'order_report_model.g.dart';

@freezed
class OrderReportModel with _$OrderReportModel {
  const OrderReportModel._();

  const factory OrderReportModel({
    @Default(<ItemReportModel>[]) List<ItemReportModel> items,
    @JsonKey(name: 'current_value')
    @Default(0) int? currentValue,
    @JsonKey(name: 'last_value')
    @Default(0) int? lastValue,
  }) = _OrderReportModel;

  factory OrderReportModel.fromJson(Map<String, dynamic> json) => _$OrderReportModelFromJson(json);
}
