import 'package:json_annotation/json_annotation.dart';

part 'count_entity.g.dart';

@JsonSerializable()
class CountEntity {
  final String name;
  final int value;
  final String code;
  CountEntity({
    required this.name,
    required this.value,
    required this.code,
  });
  factory CountEntity.fromJson(Map<String, dynamic> json) => _$CountEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CountEntityToJson(this);
}