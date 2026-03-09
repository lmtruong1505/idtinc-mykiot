import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/report/data/models/customer_report_model.dart';
import 'package:pharmago/presentation/features/report/domain/entities/customer_report_entity.dart';

import 'item_report_mapper.dart';

@injectable
class CustomerReportMapper extends BaseDataMapper<CustomerReportModel, CustomerReportEntity>{
  @override
  CustomerReportEntity mapToEntity(CustomerReportModel? data) {
    return CustomerReportEntity(
      items: _itemReportMapper.mapToListEntity(data?.items),
      currentValue: data?.currentValue,
      lastValue: data?.lastValue,
    );
  }

  CustomerReportMapper(this._itemReportMapper);

  final ItemReportMapper _itemReportMapper;

}