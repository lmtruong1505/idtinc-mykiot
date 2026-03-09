
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_type_entity.freezed.dart';

@freezed
class ProductTypeEntity with _$ProductTypeEntity {
  const ProductTypeEntity._();

  const factory ProductTypeEntity({
    int? id,
    String? code,
    String? name,
    int? company,
  }) = _ProductTypeEntity;

}