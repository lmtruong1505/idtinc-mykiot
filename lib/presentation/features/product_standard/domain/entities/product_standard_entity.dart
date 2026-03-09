import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_standard_entity.freezed.dart';

@freezed
class ProductStandardEntity with _$ProductStandardEntity {
  const ProductStandardEntity._();

  const factory ProductStandardEntity({
    int? id,
    @Default("") String code,
    @Default("") String name,
    @Default(0) int valueExtra,
    @Default("") String userCreatedName,
    @Default("") String createdAt,
    @Default("") String description,
    @Default("") String company,
  }) = _ProductStandardEntity;
}
