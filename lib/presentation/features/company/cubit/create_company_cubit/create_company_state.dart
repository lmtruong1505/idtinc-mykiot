import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../address/domain/entities/address_entity.dart';
import '../../../employee/employee/domain/entities/employee_entity.dart';
import '../../../product/domain/entities/basic_entity.dart';
import '../../domain/entities/bank_entity.dart';

part 'create_company_state.freezed.dart';

@freezed
class CreateCompanyState with _$CreateCompanyState {
  const factory CreateCompanyState({
    @Default('') String name,
    BasicEntity? type,
    @Default('') String taxCode,
    @Default('') String phone,
    @Default('') String description,
    @Default('') String? registerNumber,
    @Default('') String? praticeCetificateNumber,
    TimeOfDay? timeOpen,
    TimeOfDay? timeClose,
    AddressEntity? addressEntity,
    @Default([]) List<BasicEntity> companyTypes,
    @Default([]) List<BankEntity> banks,
    BankEntity? bank,
    String? accountNumber,
    String? nameAccount,
    String? kafa,
    EmployeeEntity? manager,
    @Default('ACTIVE') String? status,
  }) = _CreateCompanyState;
}

enum TypeCompany {
  drugstore(title: 'Nhà thuốc', code: 'DRUGSTORE'),
  clinic(title: 'Phòng khám', code: 'CLINIC'),
  gym(title: 'Phòng GYM', code: 'GYM'),
  spa(title: 'Spa', code: 'SPA');

  final String title;
  final String code;

  const TypeCompany({required this.code, required this.title});
  static TypeCompany fromCode(String code) {
    return TypeCompany.values.firstWhere(
      (type) => type.code == code,
      orElse: () => TypeCompany.clinic,
    );
  }
}
