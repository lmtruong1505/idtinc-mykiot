
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

@freezed
class CategoryEntity with _$CategoryEntity {
  const CategoryEntity._();

  const factory CategoryEntity({
    int? id,
    String? code,
    String? name,
    int? company,
    String? description,
    @Default(0) int products,
    String? userCreated,
    DateTime? createdAt,
    String? userUpdated,
    DateTime? updatedAt,
  }) = _CategoryEntity;
}