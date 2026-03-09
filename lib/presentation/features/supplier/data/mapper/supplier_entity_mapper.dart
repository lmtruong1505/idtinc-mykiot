import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import 'package:pharmago/presentation/features/supplier/domain/entities/supplier_entity.dart';

@injectable
class SupplierEntityMapper {
  SupplierEntity mapToSupplierEntity(dynamic data) {
    final addressData = data['address'];
    final province = AddressItemEntity(
      code: addressData['province']['code'],
      name: addressData['province']['name'],
      nameEn: addressData['province']['name_en'],
      fullName: addressData['province']['full_name'],
      fullNameEn: addressData['province']['full_name_en'],
    );
    final district = AddressItemEntity(
      code: addressData['district']['code'],
      name: addressData['district']['name'],
      nameEn: addressData['district']['name_en'],
      fullName: addressData['district']['full_name'],
      fullNameEn: addressData['district']['full_name_en'],
    );
    final ward = AddressItemEntity(
      code: addressData['ward']['code'],
      name: addressData['ward']['name'],
      nameEn: addressData['ward']['name_en'],
      fullName: addressData['ward']['full_name'],
      fullNameEn: addressData['ward']['full_name_en'],
    );
    final address = AddressEntity(
        province: province,
        district: district,
        ward: ward,
        title: addressData['title']);
    return SupplierEntity(
      id: data['id'],
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      deputyName: data['deputy_name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: address,
    );
  }

  Map<String, Object> supplierEntityToMap(SupplierEntity supplier) => {
        'code': supplier.code,
        'name': supplier.name,
        'deputy': supplier.deputyName,
        'phone': supplier.phone,
        'address': {
          'lat': supplier.address!.lat,
          'lng': supplier.address!.lng,
          'province': supplier.address!.province?.code,
          'district': supplier.address!.district?.code,
          'ward': supplier.address!.ward?.code,
          'title': supplier.address!.title,
        },
        'email': supplier.email,
        'company': supplier.company,
      };
}
