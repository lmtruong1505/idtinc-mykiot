import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../address/domain/entities/address_entity.dart';
part 'account_entity.freezed.dart';

@freezed
class AccountEntity with _$AccountEntity {
  const AccountEntity._();

  const factory AccountEntity({
    int? id,
    String? avatar,
    String? code,
    String? fullName,
    String? phone,
    String? phoneNumber,
    String? address,
    int? regionId,
    String? email,
    String? birthday,
    int? gender,
    String? licenseId,
    String? regionTitle,
    String? idPerson,
    AddressEntity? addressData,
    @Default(true) bool isActive,
  }) = _AccountEntity;
}