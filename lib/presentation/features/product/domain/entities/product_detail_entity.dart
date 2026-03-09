import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/ingredient_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';

import 'unit_entity.dart';
import 'variant_entity.dart';

part 'product_detail_entity.freezed.dart';

@freezed
class ProductDetailEntity with _$ProductDetailEntity{
  const ProductDetailEntity._();

  const factory ProductDetailEntity({
    ProductEntity? product,
    @Default(<UnitEntity>[]) List<UnitEntity> units,
    @Default(<VariantEntity>[]) List<VariantEntity> variants,
    @Default(<IngredientEntity>[]) List<IngredientEntity> ingredients,
  }) = _ProductDetailEntity;
}