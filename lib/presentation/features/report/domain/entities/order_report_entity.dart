import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/report/domain/entities/item_report_entity.dart';

part 'order_report_entity.freezed.dart';


@freezed
class OrderReportEntity with _$OrderReportEntity {
  const OrderReportEntity._();

  const factory OrderReportEntity({
    @Default(<ItemReportEntity>[]) List<ItemReportEntity> items,
    @Default(0) int? currentValue,
    @Default(0) int? lastValue,
  }) = _OrderReportEntity;
}
