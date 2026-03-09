import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';

@injectable
class AddressItemMapper extends BaseDataMapper<dynamic, AddressItemEntity> {
  @override
  AddressItemEntity mapToEntity(data) {
    return AddressItemEntity(
      code: data?.code,
      codeName: data?.codeName,
      fullName: data?.fullName,
      fullNameEn: data?.fullNameEn,
      name: data?.name,
      nameEn: data?.nameEn,
    );
  }
}
