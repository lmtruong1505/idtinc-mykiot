import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/variant_entity.dart';
import '../models/variant_model.dart';

@injectable
class VariantEntityMapper extends BaseDataMapper<VariantModel, VariantEntity> {
  VariantEntityMapper();

  @override
  VariantEntity mapToEntity(VariantModel? data) {
    final units = data?.units
        ?.map(
          (e) => UnitEntity(
            id: e.id,
            name: e.name,
            value: e.value ?? 1,
            sellPrice: e.sellPrice,
            level: e.level,
            isDefault: e.isDefault ?? false,
          ),
        )
        .toList();
    return VariantEntity(
      id: data?.id,
      code: data?.code,
      barcode: data?.barcode,
      name: data?.name,
      decisionNumber: data?.decisionNumber,
      registerNumber: data?.registerNumber,
      product: data?.product,
      longevity: data?.longevity,
      media: data?.media,
      quantityInStock: data?.quantityInStock ?? 0,
      vat: data?.vat,
      priceImport: data?.priceImport ?? 0,
      priceSell: data?.priceSell ?? 0,
      units: units,
      revenue: data?.revenue ?? 0,
      unitSelected: (units?.isNotEmpty ?? false)
          ? units?.firstWhere((e) => e.isDefault)
          : null,
      initialInventory: data?.initialInventory,
      realInventory: data?.realInventory,
    );
  }
}
