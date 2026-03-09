import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

import '../../../../address/domain/entities/address_entity.dart';

part 'employee_entity.freezed.dart';
part 'employee_entity.g.dart';

@freezed
class EmployeeEntity with _$EmployeeEntity {
  const EmployeeEntity._();

  const factory EmployeeEntity({
    int? id,
    String? code,
    String? username,
    String? password,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    @JsonKey(name: 'account_type') String? accountType,
    String? phoneNumber,
    int? role,
    String? gender,
    String? licence,
    DateTime? dob,
    DateTime? createdAt,
    AddressEntity? address,
    int? company,
    String? companyName,
    String? avatar,
    List<BasicEntity>? roles,
    @Default(false) bool active,
    int? wpId,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}
