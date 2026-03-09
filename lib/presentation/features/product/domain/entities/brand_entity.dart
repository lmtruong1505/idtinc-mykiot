
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_entity.freezed.dart';

@freezed
class BrandEntity with _$BrandEntity {
  const BrandEntity._();

  const factory BrandEntity({
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
  }) = _BrandEntity;
}