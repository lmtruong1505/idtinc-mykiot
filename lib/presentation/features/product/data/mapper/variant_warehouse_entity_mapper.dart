import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_warehouse_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_warehouse_entity.dart';

@injectable
class VariantWarehouseEntityMapper
    extends BaseDataMapper<VariantWarehouseModel, VariantWarehouseEntity> {
  VariantWarehouseEntityMapper(this._variantEntityMapper);

  final VariantEntityMapper _variantEntityMapper;

  @override
  VariantWarehouseEntity mapToEntity(VariantWarehouseModel? data) {
    return VariantWarehouseEntity(
      id: data?.id,
      variant: _variantEntityMapper.mapToEntity(data?.variantData),
      amount: data?.amountData ?? 0,
      priceImport: data?.priceImport ?? 0,
    );
  }
}
