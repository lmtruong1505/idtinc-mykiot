import 'package:freezed_annotation/freezed_annotation.dart';
part 'account_type_entity.freezed.dart';

@freezed
class AccountTypeEntity with _$AccountTypeEntity {
  const AccountTypeEntity._();

  const factory AccountTypeEntity({
    String? title,
    String? code,
  }) = _AccountTypeEntity;
}