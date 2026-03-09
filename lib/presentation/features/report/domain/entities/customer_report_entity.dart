import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_report_entity.dart';

part 'customer_report_entity.freezed.dart';

@freezed
class CustomerReportEntity with _$CustomerReportEntity {
  const CustomerReportEntity._();

  const factory CustomerReportEntity({
    @Default(<ItemReportEntity>[]) List<ItemReportEntity> items,
    @Default(0) int? currentValue,
    @Default(0) int? lastValue,
  }) = _CustomerReportEntity;
}
