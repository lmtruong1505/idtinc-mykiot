
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

@freezed
class BrandModel with _$BrandModel {
  const BrandModel._();

  const factory BrandModel({
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
  }) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) => _$BrandModelFromJson(json);
}