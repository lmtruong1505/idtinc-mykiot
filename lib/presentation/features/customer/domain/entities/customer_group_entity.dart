import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group_entity.freezed.dart';

@freezed
class CustomerGroupEntity with _$CustomerGroupEntity{
  const CustomerGroupEntity._();

  const factory CustomerGroupEntity({
    int? id,
    String? code,
    String? name,
    int? company,
    String? note,
    int? userCreated,
    int? userUpdated,
    String? userCreatedName,
    String? userUpdatedName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomerGroupEntity;
}