import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/domain/entities/variant_entity.dart';

part 'inventory_entity.freezed.dart';

@freezed
class InventoryEntity with _$InventoryEntity {
  const InventoryEntity._();

  const factory InventoryEntity({
    int? id,
    String? code,
    String? name,
    int? amount,
    VariantEntity? variant,
    int? price,
    String? image,
  }) = _InventoryEntity;
}
