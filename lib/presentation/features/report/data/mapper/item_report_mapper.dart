import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/report/data/models/item_report_model.dart';
import 'package:pharmago/presentation/features/report/domain/entities/item_report_entity.dart';

@injectable
class ItemReportMapper extends BaseDataMapper<ItemReportModel, ItemReportEntity>{
  @override
  ItemReportEntity mapToEntity(ItemReportModel? data) {
    return ItemReportEntity(
      title: data?.title,
      value: data?.value,
      valueExtra: data?.valueExtra,
    );
  }

}