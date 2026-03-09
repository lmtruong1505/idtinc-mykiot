import 'package:freezed_annotation/freezed_annotation.dart';

part 'prepare_entity.freezed.dart';

@freezed
class PrepareEntity with _$PrepareEntity {
  const PrepareEntity._();

  const factory PrepareEntity({
    int? id,
    @Default("") String code,
    @Default("") String name,
    @Default(0) int valueExtra,
    @Default("") String userCreatedName,
    @Default("") String createdAt,
    @Default("") String description,
    @Default("") String company,
  }) = _PrepareEntity;
}
