import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
part 'address_entity.freezed.dart';
part 'address_entity.g.dart';

@freezed
class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    int? id,
    double? lat,
    double? lng,
    AddressItemEntity? province,
    AddressItemEntity? district,
    AddressItemEntity? ward,
    String? title,
    String? detail,
  }) = _AddressEntity;

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);
}

extension AddressEntityExt on AddressEntity {
  String get fullAddress {
    return '${title ?? ''}, ${ward?.name ?? ''}, ${district?.name ?? ''}, ${province?.name ?? ''}';
  }

  String get formatAddress {
    final String addressText = title == null ? '' : '$title, ';

    final String wardText = ward?.name == null ? '' : '${ward?.name}, ';
    final String districtText =
        district?.name == null ? '' : '${district?.name}, ';
    final String provinceText =
        province?.name == null ? '' : '${province?.name}';

    return '$addressText$wardText$districtText$provinceText';
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'title': title ?? detail,
      'ward': ward?.code,
      'district': district?.code,
      'province': province?.code,
      'lat': lat,
      'lng': lng,
    };
  }
}
