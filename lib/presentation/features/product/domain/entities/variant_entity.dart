
import 'package:freezed_annotation/freezed_annotation.dart';

import 'unit_entity.dart';

part 'variant_entity.freezed.dart';

@freezed
class VariantEntity with _$VariantEntity {
  const VariantEntity._();

  const factory VariantEntity({
    @Required() int? id,
    @Required() String? code,
    String? name,
    String? barcode,
    String? decisionNumber,
    String? registerNumber,
    String? longevity,
    double? vat,
    int? product,
    String? media,
    @Default(0) int quantityInStock,
    List<UnitEntity>? units,
    @Default(0) double? priceSell,
    @Default(0) double? priceImport,
    @Default(0) int amount,
    @Default(0) int amountUnit,
    @Default(0) double discount,
    @Default(0) double revenue,
    UnitEntity? unitSelected,
    int? initialInventory,
    int? realInventory,
    @Default(false) bool isChoose,
    UnitEntity? unit,
  }) = _VariantEntity;
}