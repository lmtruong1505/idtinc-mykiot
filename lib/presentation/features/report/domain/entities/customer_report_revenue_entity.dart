import 'package:freezed_annotation/freezed_annotation.dart';
part 'customer_report_revenue_entity.freezed.dart';

@freezed
class ReportCustomerRevenueEntity with _$ReportCustomerRevenueEntity {
  const ReportCustomerRevenueEntity._();

  const factory ReportCustomerRevenueEntity({
    List<ItemReportCustomerRevenueEntity>? details,
    int? total,
    num? average,
    num? averageRevenue,
  }) = _ReportCustomerRevenueEntity;
}

@freezed
class ItemReportCustomerRevenueEntity with _$ItemReportCustomerRevenueEntity {
  const ItemReportCustomerRevenueEntity._();

  const factory ItemReportCustomerRevenueEntity({
    int? id,
    String? fullName,
    String? image,
    int? quantity,
    num? revenue,
  }) = _ItemReportCustomerRevenueEntity;
}