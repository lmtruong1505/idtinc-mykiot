import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/price_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/price_entity.dart';

@injectable
class PriceEntityMapper extends BaseDataMapper<PriceModel, PriceEntity> {
  @override
  PriceEntity mapToEntity(PriceModel? data) {
    return PriceEntity(
        id: data?.id,
        code: data?.code,
        name: data?.name,
        priceImport: data?.priceImport,
        priceSell: data?.priceSell,
        unit: data?.unit,
        unitName: data?.unitName,
        image: data?.image);
  }
}
