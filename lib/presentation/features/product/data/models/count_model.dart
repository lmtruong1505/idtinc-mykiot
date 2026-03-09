import 'package:json_annotation/json_annotation.dart';

part 'count_model.g.dart';

@JsonSerializable()
class CountModel {
  String? name;
  String? code;
  int? value;
  CountModel({
    this.name,
    this.code,
    this.value,
  });
  factory CountModel.fromJson(Map<String, dynamic> json) => _$CountModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountModelToJson(this);
}