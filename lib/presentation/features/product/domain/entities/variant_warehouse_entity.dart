import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
part 'variant_warehouse_entity.freezed.dart';

@freezed
class VariantWarehouseEntity with _$VariantWarehouseEntity {
  const VariantWarehouseEntity._();

  const factory VariantWarehouseEntity({
    @Required() int? id,
    @Required() VariantEntity? variant,
    @Default(0) int amount,
    @Default(0) double priceImport,
  }) = _VariantWarehouseEntity;
}
