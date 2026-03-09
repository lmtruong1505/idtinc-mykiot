
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_type_model.freezed.dart';
part 'product_type_model.g.dart';

@freezed
class ProductTypeModel with _$ProductTypeModel {
  const ProductTypeModel._();

  const factory ProductTypeModel({
    int? id,
    String? code,
    String? name,
    int? company,
  }) = _ProductTypeModel;

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) => _$ProductTypeModelFromJson(json);
}