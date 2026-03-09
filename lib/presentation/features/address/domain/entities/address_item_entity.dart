import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_item_entity.freezed.dart';
part 'address_item_entity.g.dart';

@freezed
class AddressItemEntity with _$AddressItemEntity {
  const factory AddressItemEntity({
    @Required() String? code,
    String? name,
    String? nameEn,
    String? fullName,
    String? fullNameEn,
    String? codeName,
  }) = _AddressItemEntity;

  factory AddressItemEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressItemEntityFromJson(json);

  
}
