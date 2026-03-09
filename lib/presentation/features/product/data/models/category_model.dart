
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    int? id,
    String? code,
    String? name,
    int? company,
    String? description,
    int? products,
    @JsonKey(name: 'user_created_name')
    String? userCreated,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'user_updated_name')
    String? userUpdated,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}