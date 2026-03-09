import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';

import '../../domain/entities/customer_report_revenue_entity.dart';
import '../models/item_report_model.dart';

@injectable
class CustomerRevenueReportMapper extends BaseDataMapper<
    ReportCustomerRevenueModel, ReportCustomerRevenueEntity> {
  final ItemCustomerRevenueReportMapper _itemReportMapper;
  @override
  ReportCustomerRevenueEntity mapToEntity(ReportCustomerRevenueModel? data) {
    return ReportCustomerRevenueEntity(
      average: data?.average,
      details: _itemReportMapper.mapToListEntity(data?.details),
      total: data?.total,
       averageRevenue: data?.averageRevenue,
    );
  }

  CustomerRevenueReportMapper(this._itemReportMapper);
}

@injectable
class ItemCustomerRevenueReportMapper extends BaseDataMapper<
    ItemReportCustomerRevenueModel, ItemReportCustomerRevenueEntity> {
  @override
  ItemReportCustomerRevenueEntity mapToEntity(
      ItemReportCustomerRevenueModel? data) {
    return ItemReportCustomerRevenueEntity(
      fullName: data?.fullName,
      id: data?.id,
      image: data?.image,
      quantity: data?.quantity,
      revenue: data?.revenue,
    );
  }
}
