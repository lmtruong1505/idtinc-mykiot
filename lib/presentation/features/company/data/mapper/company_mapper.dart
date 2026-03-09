import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/address/data/mapper/address_mapper.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';

import '../../cubit/create_company_cubit/create_company_state.dart';
import '../../domain/entities/setting_point_entity.dart';

@injectable
class CompanyMapper extends BaseDataMapper<CompanyModel, CompanyEntity> {
  CompanyMapper(this._addressMapper);
  final AddressMapper _addressMapper;

  @override
  CompanyEntity mapToEntity(CompanyModel? data) {
    late TypeCompany type;

    switch (data?.type) {
      case 'CLINIC':
        type = TypeCompany.clinic;
        break;
      default:
        type = TypeCompany.drugstore;
    }

    return CompanyEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
      type: type,
      taxCode: data?.taxCode,
      phone: data?.phone,
      address: _addressMapper.mapToEntity(data?.address),
      timeEnd: data?.timeClose,
      timeStart: data?.timeOpen,
      totalStaff: data?.totalEmployee,
      oaId: data?.oaId,
      totalCustomer: data?.totalCustomer,
      totalCustomerBefore: data?.totalCustomerBefore,
      totalEmployees: data?.totalEmployee,
      totalOrder: data?.totalOrder,
      totalOrderBefore: data?.totalOrderBefore,
      totalSales: data?.totalSales,
      totalSalesBefore: data?.totalSalesBefore,
      status: data?.status == 'ACTIVE',
      accountName: data?.accountName,
      accountNumber: data?.accountNumber,
      description: data?.description,
      kafaCode: data?.kafaCode,
      bankId: data?.bank,
      typeCode: data?.type,
      typeName: data?.typeName,
      statusCode: data?.status,
      statusName: data?.statusName,
      bankName: data?.bankName,
      totalCompany: data?.totalCompany,
      totalEmployeesAll: data?.totalEmployeesAll,
      totalEmployeesOnly: data?.totalEmployeesOnly,
      statusUserInWorkspaceCode: data?.statusUserInWorkspaceCode,
      statusUserInWorkspaceName: data?.statusUserInWorkspaceName,
      statusUserWorkPending: data?.statusUserInWorkspaceCode == 'PENDING',
      parentId: data?.parentId,
      codeAssociate: data?.codeAssociate,
      manager: EmployeeEntity(
        fullName: data?.managerFullName,
        id: data?.managerId,
        phoneNumber: data?.managerPhone,
      ),
      settingPoint: SettingPointEntity(
        isApplyProductPoint: data?.settingPoint?.isApplyProductPoint ?? false,
        isApplyOrderPoint: data?.settingPoint?.isApplyOrderPoint ?? false,
        orderExchangeMoney: data?.settingPoint?.orderExchangeMoney ?? 0,
        orderExchangePoint: data?.settingPoint?.orderExchangePoint ?? 0,
        isApplyPaymentPoint: data?.settingPoint?.isApplyPaymentPoint ?? false,
        paymentExchangeMoney: data?.settingPoint?.paymentExchangeMoney ?? 0,
        paymentExchangePoint: data?.settingPoint?.paymentExchangePoint ?? 0,
      ),
    );
  }
}
