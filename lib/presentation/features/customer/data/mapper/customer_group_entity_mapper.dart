import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_group_model.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_group_entity.dart';

@injectable
class CustomerGroupEntityMapper extends BaseDataMapper<CustomerGroupModel, CustomerGroupEntity>{
  @override
  CustomerGroupEntity mapToEntity(CustomerGroupModel? data) {
    return CustomerGroupEntity(
      id: data?.id,
      code: data?.code,
      name: data?.name,
      company: data?.company,
      note: data?.note,
      userCreated: data?.userCreated,
      userUpdated: data?.userUpdated,
      userCreatedName: data?.userCreatedName,
      userUpdatedName: data?.userUpdatedName,
      createdAt: DateTime.parse(data?.createdAt ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(data?.updatedAt ?? DateTime.now().toString()),
    );
  }
}