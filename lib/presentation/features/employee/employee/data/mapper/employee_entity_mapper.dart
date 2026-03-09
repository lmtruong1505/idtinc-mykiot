import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/address/data/mapper/address_mapper.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

@injectable
class EmployeeMapper extends BaseDataMapper<EmployeeModel, EmployeeEntity> {
  EmployeeMapper(this._addressMapper);
  final AddressMapper _addressMapper;

  @override
  EmployeeEntity mapToEntity(EmployeeModel? data) {
    return EmployeeEntity(
      id: data?.id,
      code: data?.code,
      fullName: data?.fullName,
      accountType: data?.accountType,
      active: data?.active ?? false,
      address: data?.address != null
          ? _addressMapper.mapToEntity(data?.address)
          : null,
      email: data?.email,
      username: data?.username,
      phoneNumber: data?.phoneNumber,
      dob: data?.dob,
      licence: data?.licence,
      role: data?.role,
      createdAt: data?.createdAt,
      companyName: data?.companyName,
      wpId: data?.wpId,
      roles: data?.roles
          ?.map(
            (e) => BasicEntity(id: e.id, code: e.code, name: e.name),
          )
          .toList(),
    );
  }
}
