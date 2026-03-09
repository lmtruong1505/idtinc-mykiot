import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_model.freezed.dart';
part 'basic_model.g.dart';

@freezed
class BasicModel with _$BasicModel {
  const BasicModel._();

  const factory BasicModel({
    int? id,
    String? code,
    String? title,
    String? name,
    int? level,
    String? type,
    String? description,
    @JsonKey(name: 'name_vn') String? nameVn,
  }) = _BasicModel;

  factory BasicModel.fromJson(Map<String, dynamic> json) =>
      _$BasicModelFromJson(json);
}
