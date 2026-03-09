import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/item_entity.dart';

part 'role_entity.freezed.dart';

@freezed
class RoleEntity with _$RoleEntity {
  const RoleEntity._();

  const factory RoleEntity({
    int? id,
    @Default('') String code,
    @Default('') String title,
    @Default('') String note,
    @Default('') String company,
    @Default('') String userCreatedName,
    @Default('') String userUpdatedName,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default([]) List<ItemEntity> items,
  }) = _RoleEntity;
}
