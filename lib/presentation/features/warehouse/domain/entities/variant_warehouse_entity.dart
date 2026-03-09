import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

part 'variant_warehouse_entity.freezed.dart';

@freezed
class VariantWarehouseEntity with _$VariantWarehouseEntity {
  const VariantWarehouseEntity._();

  const factory VariantWarehouseEntity({
    @Default(0) int id,
    @Default('') String code,
    @Default('') String name,
    @Default(PrefKeys.imgProductDefault) String image,
    @Default(0) int amount,
    @Default(0) int priceImport,
    @Default([]) List<BatchEntity> batchs,
  }) = _VariantWarehouseEntity;
}
