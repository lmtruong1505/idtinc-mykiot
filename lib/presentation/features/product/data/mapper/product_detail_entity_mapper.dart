import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/ingredient_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/product_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/product_detail_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_detail_entity.dart';

import 'unit_entity_mapper.dart';
import 'variant_entity_mapper.dart';

@injectable
class ProductDetailEntityMapper
    extends BaseDataMapper<ProductDetailModel, ProductDetailEntity> {
  @override
  ProductDetailEntity mapToEntity(ProductDetailModel? data) {
    return ProductDetailEntity(
      product: _productEntityMapper.mapToEntity(data?.product),
      units: data?.units.map((e) => _unitEntityMapper.mapToEntity(e)).toList() ?? [],
      variants: data?.variants.map((e) => _variantEntityMapper.mapToEntity(e)).toList() ?? [],
      ingredients: data?.ingredients.map((e) => _ingredientEntityMapper.mapToEntity(e)).toList() ?? [],
    );
  }

  ProductDetailEntityMapper(
    this._productEntityMapper,
    this._unitEntityMapper,
    this._variantEntityMapper,
    this._ingredientEntityMapper,
  );

  final ProductEntityMapper _productEntityMapper;
  final UnitEnityMapper _unitEntityMapper;
  final VariantEntityMapper _variantEntityMapper;
  final IngredientEntityMapper _ingredientEntityMapper;
}
