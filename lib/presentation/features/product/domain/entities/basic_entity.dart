import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_entity.freezed.dart';
part 'basic_entity.g.dart';

@freezed
class BasicEntity with _$BasicEntity {
  const BasicEntity._();

  const factory BasicEntity({
    int? id,
    String? code,
    String? name,
  }) = _BasicEntity;
  factory BasicEntity.fromJson(Map<String, dynamic> json) =>
      _$BasicEntityFromJson(json);
}
