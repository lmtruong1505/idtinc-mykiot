import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_entity_mapper.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/inventory_entity.dart';

@injectable
class InventoryEntityMapper
    extends BaseDataMapper<InventoryModel, InventoryEntity> {
      InventoryEntityMapper(this._variantEntityMapper);
      final VariantEntityMapper _variantEntityMapper;

  @override
  InventoryEntity mapToEntity(InventoryModel? data) => InventoryEntity(
        id: data?.id,
        code: data?.code,
        name: data?.variant?.name,
        amount: data?.inventory ?? 0,
        variant: _variantEntityMapper.mapToEntity(data?.variant),
        price: data?.inventory ?? 0,
        image: data?.variant?.media,
      );
}
