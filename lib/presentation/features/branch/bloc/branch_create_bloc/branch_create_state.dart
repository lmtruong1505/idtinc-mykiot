import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';

import '../../../address/domain/entities/address_entity.dart';
import '../../../company/cubit/create_company_cubit/create_company_state.dart';

part 'branch_create_state.freezed.dart';

@freezed
class BranchCreateState with _$BranchCreateState {
  const factory BranchCreateState({
    TypeCompany? type,
    String? name,
    AddressEntity? address,
    EmployeeEntity? staffSelected,
    @Default([
      TypeCompany.drugstore,
      TypeCompany.clinic,
    ])
    List<TypeCompany> branchType,
  }) = _BranchCreateState;
}
