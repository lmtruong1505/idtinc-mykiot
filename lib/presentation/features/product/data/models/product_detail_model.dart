import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/data/models/product_model.dart';

import 'ingredient_model.dart';
import 'unit_model.dart';
import 'variant_model.dart';

part 'product_detail_model.freezed.dart';
part 'product_detail_model.g.dart';

@freezed
class ProductDetailModel with _$ProductDetailModel {
  const factory ProductDetailModel({
    ProductModel? product,
    @Default(<UnitModel>[]) List<UnitModel> units,
    @Default(<VariantModel>[]) List<VariantModel> variants,
    @Default(<IngredientModel>[]) List<IngredientModel> ingredients,
  }) = _ProductDetailModel;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);
}