import 'package:flutter/widgets.dart';

import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

import '../../../employee/employee/domain/entities/employee_entity.dart';
import '../../cubit/create_company_cubit/create_company_state.dart';
import 'setting_point_entity.dart';

class CompanyEntity {
  int? id;
  String? name;
  TypeCompany? type;
  String? code;
  String? taxCode;
  String? phone;
  AddressEntity? address;
  int? owner;
  String? oaId;
  String? timeStart;
  String? timeEnd;
  int? totalStaff;
  // branch
  EmployeeEntity? manager;
  EmployeeEntity? userCreated;
  EmployeeEntity? userUpdated;
  int? totalEmployees;
  int? totalEmployeesAll;
  int? totalEmployeesOnly;
  int? totalOrder;
  int? totalOrderBefore;
  int? totalCustomer;
  int? totalCustomerBefore;
  int? totalCompany;
  double? totalSales;
  double? totalSalesBefore;
  bool status;
  String? description;
  String? kafaCode;
  String? accountName;
  String? accountNumber;
  int? bankId;
  String? typeCode;
  String? typeName;
  String? statusCode;
  String? statusName;
  String? bankName;
  String? statusUserInWorkspaceCode;
  String? statusUserInWorkspaceName;
  bool statusUserWorkPending;
  int? parentId;
  String? codeAssociate;
  SettingPointEntity? settingPoint;
  
  CompanyEntity({
    this.id,
    this.name,
    this.type,
    this.code,
    this.taxCode,
    this.phone,
    this.address,
    this.owner,
    this.oaId,
    this.timeStart,
    this.timeEnd,
    this.totalStaff,
    this.manager,
    this.userCreated,
    this.userUpdated,
    this.totalEmployees,
    this.totalEmployeesAll,
    this.totalEmployeesOnly,
    this.totalOrder,
    this.totalOrderBefore,
    this.totalCustomer,
    this.totalCustomerBefore,
    this.totalCompany,
    this.totalSales,
    this.totalSalesBefore,
    this.status = false,
    this.description,
    this.kafaCode,
    this.accountName,
    this.accountNumber,
    this.bankId,
    this.typeCode,
    this.typeName,
    this.statusCode,
    this.statusName,
    this.bankName,
    this.statusUserInWorkspaceCode,
    this.statusUserInWorkspaceName,
    this.statusUserWorkPending = false,
    this.parentId,
    this.codeAssociate,
    this.settingPoint,
  });

  CompanyEntity copyWith({
    ValueGetter<int?>? id,
    ValueGetter<String?>? name,
    ValueGetter<TypeCompany?>? type,
    ValueGetter<String?>? code,
    ValueGetter<String?>? taxCode,
    ValueGetter<String?>? phone,
    ValueGetter<AddressEntity?>? address,
    ValueGetter<int?>? owner,
    ValueGetter<String?>? oaId,
    ValueGetter<String?>? timeStart,
    ValueGetter<String?>? timeEnd,
    ValueGetter<int?>? totalStaff,
    ValueGetter<EmployeeEntity?>? manager,
    ValueGetter<EmployeeEntity?>? userCreated,
    ValueGetter<EmployeeEntity?>? userUpdated,
    ValueGetter<int?>? totalEmployees,
    ValueGetter<int?>? totalEmployeesAll,
    ValueGetter<int?>? totalEmployeesOnly,
    ValueGetter<int?>? totalOrder,
    ValueGetter<int?>? totalOrderBefore,
    ValueGetter<int?>? totalCustomer,
    ValueGetter<int?>? totalCustomerBefore,
    ValueGetter<int?>? totalCompany,
    ValueGetter<double?>? totalSales,
    ValueGetter<double?>? totalSalesBefore,
    bool? status,
    ValueGetter<String?>? description,
    ValueGetter<String?>? kafaCode,
    ValueGetter<String?>? accountName,
    ValueGetter<String?>? accountNumber,
    ValueGetter<int?>? bankId,
    ValueGetter<String?>? typeCode,
    ValueGetter<String?>? typeName,
    ValueGetter<String?>? statusCode,
    ValueGetter<String?>? statusName,
    ValueGetter<String?>? bankName,
    ValueGetter<String?>? statusUserInWorkspaceCode,
    ValueGetter<String?>? statusUserInWorkspaceName,
    bool? statusUserWorkPending,
    ValueGetter<int?>? parentId,
    ValueGetter<SettingPointEntity?>? settingPoint,
  }) {
    return CompanyEntity(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      type: type != null ? type() : this.type,
      code: code != null ? code() : this.code,
      taxCode: taxCode != null ? taxCode() : this.taxCode,
      phone: phone != null ? phone() : this.phone,
      address: address != null ? address() : this.address,
      owner: owner != null ? owner() : this.owner,
      oaId: oaId != null ? oaId() : this.oaId,
      timeStart: timeStart != null ? timeStart() : this.timeStart,
      timeEnd: timeEnd != null ? timeEnd() : this.timeEnd,
      totalStaff: totalStaff != null ? totalStaff() : this.totalStaff,
      manager: manager != null ? manager() : this.manager,
      userCreated: userCreated != null ? userCreated() : this.userCreated,
      userUpdated: userUpdated != null ? userUpdated() : this.userUpdated,
      totalEmployees: totalEmployees != null ? totalEmployees() : this.totalEmployees,
      totalEmployeesAll: totalEmployeesAll != null ? totalEmployeesAll() : this.totalEmployeesAll,
      totalEmployeesOnly: totalEmployeesOnly != null ? totalEmployeesOnly() : this.totalEmployeesOnly,
      totalOrder: totalOrder != null ? totalOrder() : this.totalOrder,
      totalOrderBefore: totalOrderBefore != null ? totalOrderBefore() : this.totalOrderBefore,
      totalCustomer: totalCustomer != null ? totalCustomer() : this.totalCustomer,
      totalCustomerBefore: totalCustomerBefore != null ? totalCustomerBefore() : this.totalCustomerBefore,
      totalCompany: totalCompany != null ? totalCompany() : this.totalCompany,
      totalSales: totalSales != null ? totalSales() : this.totalSales,
      totalSalesBefore: totalSalesBefore != null ? totalSalesBefore() : this.totalSalesBefore,
      status: status ?? this.status,
      description: description != null ? description() : this.description,
      kafaCode: kafaCode != null ? kafaCode() : this.kafaCode,
      accountName: accountName != null ? accountName() : this.accountName,
      accountNumber: accountNumber != null ? accountNumber() : this.accountNumber,
      bankId: bankId != null ? bankId() : this.bankId,
      typeCode: typeCode != null ? typeCode() : this.typeCode,
      typeName: typeName != null ? typeName() : this.typeName,
      statusCode: statusCode != null ? statusCode() : this.statusCode,
      statusName: statusName != null ? statusName() : this.statusName,
      bankName: bankName != null ? bankName() : this.bankName,
      statusUserInWorkspaceCode: statusUserInWorkspaceCode != null ? statusUserInWorkspaceCode() : this.statusUserInWorkspaceCode,
      statusUserInWorkspaceName: statusUserInWorkspaceName != null ? statusUserInWorkspaceName() : this.statusUserInWorkspaceName,
      statusUserWorkPending: statusUserWorkPending ?? this.statusUserWorkPending,
      parentId: parentId != null ? parentId() : this.parentId,
      settingPoint:settingPoint != null ? settingPoint() : this.settingPoint,
    );
  }
}
