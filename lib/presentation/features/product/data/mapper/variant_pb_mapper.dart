import 'package:injectable/injectable.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../../../../pb/service.pb.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/entities/variant_entity.dart';

@injectable
class VariantPbMapper extends BaseDataMapper<Variant, VariantEntity> {
  VariantPbMapper();

  @override
  VariantEntity mapToEntity(Variant? data) {
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
      units: data?.units
          .map(
            (e) => UnitEntity(
              id: e.id,
              name: e.name,
              value: e.value,
              isDefault: e.default_8,
            ),
          )
          .toList(),
      revenue: data?.revenue ?? 0,
    );
  }
}
