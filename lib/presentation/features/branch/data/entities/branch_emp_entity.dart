import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';

part 'branch_emp_entity.freezed.dart';
part 'branch_emp_entity.g.dart';

@freezed
class BranchEmpEntity with _$BranchEmpEntity {
  const BranchEmpEntity._();

  const factory BranchEmpEntity({
    EmployeeEntity? employee,
    @Default(false) bool isSelect,
  }) = _BranchEmpEntity;

  factory BranchEmpEntity.fromJson(Map<String, dynamic> json) => _$BranchEmpEntityFromJson(json);
}
