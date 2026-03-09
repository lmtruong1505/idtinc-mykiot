import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/unit_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';

@injectable
class UnitEnityMapper extends BaseDataMapper<UnitModel, UnitEntity> {
  @override
  UnitEntity mapToEntity(UnitModel? data) {
    return UnitEntity(
      id: data?.id,
      level: data?.level,
      name: data?.name,
      priceSell: data?.priceSell ?? 0,
      priceImport: data?.priceImport,
      sellPrice: data?.sellPrice,
      importPrice: data?.importPrice,
      value: data?.value ?? 1,
      isDefault: data?.isDefault ?? false,
      weight: data?.weight,
      weightUnit: data?.weightUnit,
      conversions: (data?.conversions ?? [])
          .map(
            (e) => UnitConversionEntity(
              id: e.id,
              priceImport: e.priceImport ?? 0,
              priceSell: e.priceSell,
              times: e.times,
              title: e.title,
              unit: e.unit,
            ),
          )
          .toList(),
    );
  }
}
