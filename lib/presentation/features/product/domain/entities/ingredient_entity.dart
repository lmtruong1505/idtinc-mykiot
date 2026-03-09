import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_entity.freezed.dart';

@freezed
class IngredientEntity with _$IngredientEntity {
  const IngredientEntity._();

  const factory IngredientEntity({
    int? id,
    String? name,
    double? weight,
    String? unit,
  }) = _IngredientEntity;
}
