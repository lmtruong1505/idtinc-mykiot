import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/ingredient_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/unit_entity.dart';

part 'product_detail_state.freezed.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(false) bool isLoading,
    @Default(0) int imageIndex,
    ProductEntity? product,
    ProductDetailEntity? productDetail,
    @Default(<UnitEntity>[]) List<UnitEntity> units,
    @Default(<VariantEntity>[]) List<VariantEntity> variants,
    @Default(<IngredientEntity>[]) List<IngredientEntity> ingredients,
  }) = _ProductDetailState;
}

enum MenuDetailProd {
  edit('Chỉnh sửa'),
  remove('Xoá');

  const MenuDetailProd(this.name);
  final String name;

}

