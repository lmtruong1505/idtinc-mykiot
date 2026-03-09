import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/report/data/mapper/item_report_mapper.dart';
import 'package:pharmago/presentation/features/report/data/models/order_report_model.dart';
import 'package:pharmago/presentation/features/report/domain/entities/order_report_entity.dart';

@injectable
class OrderReportMapper extends BaseDataMapper<OrderReportModel, OrderReportEntity>{
  @override
  OrderReportEntity mapToEntity(OrderReportModel? data) {
    return OrderReportEntity(
      items: data?.items.map((e) => _itemReportMapper.mapToEntity(e)).toList() ?? [],
      currentValue: data?.currentValue,
      lastValue: data?.lastValue,
    );
  }

  OrderReportMapper(this._itemReportMapper);

  final ItemReportMapper _itemReportMapper;

}