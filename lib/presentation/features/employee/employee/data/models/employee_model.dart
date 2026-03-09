import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';

import '../../../role/data/models/role_model.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel {
  const EmployeeModel._();

  const factory EmployeeModel({
    int? id,
    String? code,
    String? username,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    @JsonKey(name: 'verify_id') String? verifyId,
    @JsonKey(name: 'oa_id') String? oaId,
    @JsonKey(name: 'password_changed_at') String? passwordChangedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? password,
    @JsonKey(name: 'account_type') String? accountType,
    int? role,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'roleData') RoleModel? roleData,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    String? gender,
    String? licence,
    DateTime? dob,
    AddressModel? address,
    int? company,
    @JsonKey(name: 'companyId') int? companyId,
    String? companyName,
    String? avatar,
    @JsonKey(name: 'is_active') bool? active,
    List<BasicModel>? roles,
    @JsonKey(name: 'wp_id')
    int? wpId,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}
