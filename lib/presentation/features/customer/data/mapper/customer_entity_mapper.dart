import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

import '../../../address/data/mapper/address_mapper.dart';
import '../../../conversation/data/mapper/chat_entity_mapper.dart';
import '../../domain/entities/customer_entity.dart';
import '../models/customer_model.dart';

@injectable
class CustomerEntityMapper
    extends BaseDataMapper<CustomerModel, CustomerEntity> {
  CustomerEntityMapper(this._addressMapper, this._conversationMapper,);
  final AddressMapper _addressMapper;
  final ConversationEntityMapper _conversationMapper;

  @override
  CustomerEntity mapToEntity(CustomerModel? data) {
    return CustomerEntity(
      address: data?.address == null
          ? const AddressEntity()
          : _addressMapper.mapToEntity(data?.address),
      id: data?.id,
      name: data?.fullName,
      code: data?.code,
      phone: data?.phone,
      email: data?.email,
      company: data?.company,
      birthday: data?.birthday,
      gender: data?.gender,
      group: data?.group,
      license: data?.license,
      orders: data?.orders,
      revenue: data?.revenue,
      title: data?.title,
      licenseDate: data?.licenseDate,
      contactName: data?.contactName,
      contactTitle: data?.contactTitle,
      contactPhone: data?.contactPhone,
      contactEmail: data?.contactEmail,
      contactAddress: data?.contactAddress == null
          ? const AddressEntity()
          : _addressMapper.mapToEntity(data?.contactAddress),
      accountNumber: data?.accountNumber,
      bankName: data?.bankName,
      bankBranch: data?.bankBranch,
      conversation: _conversationMapper.mapToEntity(data?.conversation),
    );
  }
}
