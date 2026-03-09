import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/address/data/mapper/address_item_mapper.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

@injectable
class AddressMapper extends BaseDataMapper<AddressModel, AddressEntity> {
  AddressMapper(this._addressItemMapper);
  final AddressItemMapper _addressItemMapper;

  @override
  AddressEntity mapToEntity(AddressModel? data) {
    final province = _addressItemMapper.mapToEntity(data?.province);
    final district = _addressItemMapper.mapToEntity(data?.district);
    final ward = _addressItemMapper.mapToEntity(data?.ward);
    return AddressEntity(
      id: data?.id,
      lat: data?.lat,
      lng: data?.lng,
      province: province,
      district: district,
      ward: ward,
      title: data?.title,
      detail:
          '${data?.title}, ${ward.fullName}, ${district.fullName}, ${province.fullName}',
    );
  }
}
