
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_payload_entity.freezed.dart';
part 'ingredient_payload_entity.g.dart';

@freezed
class IngredientPayloadEntity with _$IngredientPayloadEntity {
  const IngredientPayloadEntity._();

  const factory IngredientPayloadEntity({
    int? id,
    String? name,
    double? weight,
    String? unit,
  }) = _IngredientPayloadEntity;

  factory IngredientPayloadEntity.fromJson(Map<String, dynamic> json) => _$IngredientPayloadEntityFromJson(json);
}