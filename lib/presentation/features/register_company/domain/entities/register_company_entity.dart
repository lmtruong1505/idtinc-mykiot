import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_company_entity.freezed.dart';

@freezed
class RegisterCompanyEntity with _$RegisterCompanyEntity {
  const RegisterCompanyEntity._();

  const factory RegisterCompanyEntity({
    int? id,
    @Default("") String code,
    @Default("") String name,
    @Default("") String country,
    @Default("") String address,
    @Default("") String description,
    @Default(0) int number,
    @Default("") String userCreatedName,
    @Default("") String createdAt,
    @Default("") String userUpdatedName,
    @Default("") String updatedAt,
    @Default("") String company,
  }) = _RegisterCompanyEntity;
}
