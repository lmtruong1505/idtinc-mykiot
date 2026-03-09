import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_pharma_entity.freezed.dart';

@freezed
class CompanyPharmaEntity with _$CompanyPharmaEntity {
  const CompanyPharmaEntity._();

  const factory CompanyPharmaEntity({
    int? id,
    String? code,
    String? name,
    String? country,
    String? address,
    String? type,
  }) = _CompanyPharmaEntity;
}