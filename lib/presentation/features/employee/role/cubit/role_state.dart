import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/item_entity.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/role_entity.dart';

part 'role_state.freezed.dart';

@freezed
class RoleState with _$RoleState {
  const factory RoleState({
    @Default('') String search,
    @Default(0) int total,
    @Default(RoleEntity()) RoleEntity role,
    @Default([]) List<EmployeeEntity> employees,
    @Default([]) List<String> optionSelected,
    @Default({}) Map<ItemEntity, List<ItemEntity>> optionRoles,
  }) = _RoleState;
}
