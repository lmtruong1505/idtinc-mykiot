import 'package:pharmago/presentation/features/address/data/models/district_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../address/data/models/address_model.dart';
import '../../../address/data/models/province_model.dart';
import '../../../address/data/models/ward_model.dart';
import '../../domain/entities/company_entity.dart';
import 'setting_point_model.dart';

class CompanyModel {
  String? workspaceName;
  int? id;
  String? name;
  String? code;
  String? type;
  String? taxCode;
  String? status;
  String? statusName;
  String? oaId;
  String? phone;
  String? timeOpen;
  String? timeClose;
  String? description;
  String? kafaCode;
  String? accountName;
  String? accountNumber;
  int? bank;
  int? totalEmployee;
  int? totalOrder;
  int? totalOrderBefore;
  int? totalCustomer;
  int? totalCustomerBefore;
  double? totalSales;
  double? totalSalesBefore;
  AddressModel? address;
  String? typeName;
  String? bankName;
  int? totalCompany;
  int? totalEmployeesAll;
  int? totalEmployeesOnly;
  String? statusUserInWorkspaceCode;
  String? statusUserInWorkspaceName;
  int? parentId;
  int? managerId;
  String? managerFullName;
  String? managerPhone;
  String? phoneNumber;
  String? workspaceCode;
  String? codeAssociate;
  SettingPointModel? settingPoint;

  CompanyModel({
    this.workspaceName,
    this.id,
    this.name,
    this.code,
    this.type,
    this.taxCode,
    this.status,
    this.statusName,
    this.oaId,
    this.phone,
    this.timeOpen,
    this.timeClose,
    this.description,
    this.kafaCode,
    this.accountName,
    this.accountNumber,
    this.bank,
    this.totalEmployee,
    this.totalOrder,
    this.totalOrderBefore,
    this.totalCustomer,
    this.totalCustomerBefore,
    this.totalSales,
    this.totalSalesBefore,
    this.address,
    this.typeName,
    this.bankName,
    this.totalCompany,
    this.totalEmployeesAll,
    this.totalEmployeesOnly,
    this.statusUserInWorkspaceCode,
    this.statusUserInWorkspaceName,
    this.parentId,
    this.managerId,
    this.managerFullName,
    this.managerPhone,
    this.phoneNumber,
    this.workspaceCode,
    this.codeAssociate,
    this.settingPoint,
  });

  CompanyModel.fromJson(Map<String, dynamic> json) {
    workspaceName = json['workspace_name'];
    id = json['id'];
    name = json['name'];
    code = json['code'];
    parentId = json['parent_id'];
    taxCode = json['tax_code'] ?? json['tax_number'];
    oaId = json['oa_id'];
    phone = json['phone'];
    timeOpen = json['time_open'];
    timeClose = json['time_close'];
    description = json['description'];
    kafaCode = json['kafa_code'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    bank = json['bank'] ?? json['bank_id'];
    totalEmployee = json['total_employee'].toString().toInt;
    totalOrder = json['total_order'].toString().toInt;
    totalOrderBefore = json['total_order_before'].toString().toInt;
    totalCustomer = json['total_customer'].toString().toInt;
    totalCustomerBefore = json['total_customer_before'].toString().toInt;
    totalSales = json['total_sales'].toString().toDouble;
    totalSalesBefore = json['total_sales_before'].toString().toDouble;

    if (json['status'] != null) {
      status = json['status']['status_code'];
      statusName = json['status']['status_name'];
    }
    if (json['type'] != null) {
      type = json['type']['type_code'];
      typeName = json['type']['type_name'];
    }
    bankName = json['bank_name'];
    totalCompany = json['total_company'].toString().toInt;
    totalEmployeesOnly =
        (json['total_employees_only'] ?? json['total_employee_only'])
            .toString()
            .toInt;
    totalEmployeesAll =
        (json['total_employees_all'] ?? json['total_employee_all'])
            .toString()
            .toInt;
    if (json['address'] != null) {
      address = AddressModel.fromJson(json['address']);
    }
    if (json['status_user_in_workspace'] != null) {
      statusUserInWorkspaceCode =
          json['status_user_in_workspace']['status_code'];
      statusUserInWorkspaceName =
          json['status_user_in_workspace']['status_name'];
    }
    managerId = json['manager__id'];
    managerFullName = json['manager__full_name'];
    managerPhone = json['manager__phone_number'];
    phoneNumber = json['phone_number'];
    workspaceCode = json['workspace_code'];
    codeAssociate = json['code_associate'];
    settingPoint = json['setting_point'] == null ? null : SettingPointModel.fromJson(json['setting_point']);
    if (json['manager'] is Map) {
      managerId = json['manager']['id'];
      managerFullName = json['manager']['full_name'];
      managerPhone = json['manager']['phone_number'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workspace_name'] = workspaceName;
    data['parent_id'] = parentId;
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['tax_code'] = taxCode;
    data['status'] = {
      'status_code': status,
      'status_name': statusName,
    };
    data['type'] = {
      'type_code': type,
      'type_name': typeName,
    };
    data['oa_id'] = oaId;
    data['phone'] = phone;
    data['time_open'] = timeOpen;
    data['time_close'] = timeClose;
    data['description'] = description;
    data['kafa_code'] = kafaCode;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['bank'] = bank;
    data['total_employee'] = totalEmployee;
    data['total_order'] = totalOrder;
    data['total_order_before'] = totalOrderBefore;
    data['total_customer'] = totalCustomer;
    data['total_customer_before'] = totalCustomerBefore;
    data['total_sales'] = totalSales;
    data['total_sales_before'] = totalSalesBefore;
    data['type_name'] = typeName;
    data['bank_name'] = bankName;
    data['total_company'] = totalCompany;
    data['total_employees_only'] = totalEmployeesOnly;
    data['total_employees_all'] = totalEmployeesAll;
    data['address'] = address?.toJson();
    data['status_user_in_workspace'] = {
      'status_code': statusUserInWorkspaceCode,
      'status_name': statusUserInWorkspaceName,
    };
    data['manager__id'] = managerId;
    data['manager__full_name'] = managerFullName;
    data['manager__phone_number'] = managerPhone;
    data['phone_number'] = phoneNumber;
    data['workspace_code'] = workspaceCode;
    data['code_associate'] = codeAssociate;
    data['setting_point'] = settingPoint?.toJson();
    return data;
  }

  CompanyModel.fromEntity(CompanyEntity entity) {
    workspaceName = entity.name;
    id = entity.id;
    name = entity.name;
    code = entity.code;
    parentId = entity.parentId;
    taxCode = entity.taxCode;
    oaId = entity.oaId;
    phone = entity.phone;
    timeOpen = entity.timeStart;
    timeClose = entity.timeEnd;
    description = entity.description;
    kafaCode = entity.kafaCode;
    accountName = entity.accountName;
    accountNumber = entity.accountNumber;
    bank = entity.bankId;
    totalEmployee = entity.totalEmployees;
    totalOrder = entity.totalOrder;
    totalOrderBefore = entity.totalOrderBefore;
    totalCustomer = entity.totalCustomer;
    totalCustomerBefore = entity.totalCustomerBefore;
    totalSales = entity.totalSales;
    totalSalesBefore = entity.totalSalesBefore;
    status = entity.status.toString();
    statusName = entity.statusName;
    type = entity.typeCode;
    typeName = entity.typeName;
    bankName = entity.bankName;
    totalCompany = entity.totalCompany;
    totalEmployeesOnly = entity.totalEmployeesOnly;
    totalEmployeesAll = entity.totalEmployeesAll;
    if (entity.address != null) {
      address = AddressModel(
        id: entity.address?.id,
        district: DistrictModel(
          code: entity.address?.district?.code,
          name: entity.address?.district?.name,
          codeName: entity.address?.district?.codeName,
          fullName: entity.address?.district?.fullName,
          fullNameEn: entity.address?.district?.fullNameEn,
          nameEn: entity.address?.district?.nameEn,
        ),
        province: ProvinceModel(
          code: entity.address?.province?.code,
          name: entity.address?.province?.name,
          codeName: entity.address?.province?.codeName,
          fullName: entity.address?.province?.fullName,
          fullNameEn: entity.address?.province?.fullNameEn,
          nameEn: entity.address?.province?.nameEn,
        ),
        ward: WardModel(
          code: entity.address?.ward?.code,
          name: entity.address?.ward?.name,
          codeName: entity.address?.ward?.codeName,
          fullName: entity.address?.ward?.fullName,
          fullNameEn: entity.address?.ward?.fullNameEn,
          nameEn: entity.address?.ward?.nameEn,
        ),
        title: entity.address?.title,
        lat: entity.address?.lat,
        lng: entity.address?.lng,
      );
    }
    statusUserInWorkspaceCode = entity.statusUserInWorkspaceCode;
    statusUserInWorkspaceName = entity.statusUserInWorkspaceName;
    managerId = entity.manager?.id;
    managerFullName = entity.manager?.fullName;
    managerPhone = entity.manager?.phoneNumber;
    phoneNumber = entity.phone;
    workspaceCode = entity.code;
  }
}
