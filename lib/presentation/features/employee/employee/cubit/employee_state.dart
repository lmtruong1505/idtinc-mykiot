import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/employee_entity.dart';

part 'employee_state.freezed.dart';

@freezed
class EmployeeState with _$EmployeeState {
  const factory EmployeeState({
    @Default('') String search,
    @Default(0) int total,
    @Default(20) int limit,
    @Default(
      EmployeeEntity(accountType: 'EMPLOYEE'),
    )
    EmployeeEntity employee,
    @Default([]) List<DropdownMenuItem<int>> roles,
    @Default(false) bool isCheckPhone,
    @Default(false) bool isCheckEmail,
  }) = _EmployeeState;
}
