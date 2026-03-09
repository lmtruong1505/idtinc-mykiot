import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_payload_entity.freezed.dart';

@freezed
class CompanyPayloadEntity with _$CompanyPayloadEntity {
  const CompanyPayloadEntity._();

  const factory CompanyPayloadEntity({
    @Required() String? cName,
    String? cTaxCode,
    String? cPhone,
    String? cDescription,
    String? timeOpen,
    String? timeClose,
    @Required() double? aLat,
    @Required() double? aLng,
    @Required() String? aProvince,
    @Required() String? aDistrict,
    @Required() String? aWard,
    @Required() String? aTitle,
    @Required() String? type,
    int? companyParent,
    int? manager,
    String? kafa,
    int? bank,
    String? accountNumber,
    String? nameAccount,
    String? status,
  }) = _CompanyPayloadEntity;

  Map<String, dynamic> toJson() {
    final company = {
      'name': cName,
      'type': type,
      'tax_number': cTaxCode,
      'phone': cPhone,
      'description': cDescription,
      'time_open': timeOpen,
      'time_close': timeClose,
      'company_parent': companyParent,
      'manager': manager,
      'kafa_code': kafa,
      'bank': bank,
      'account_number': accountNumber,
      'account_name': nameAccount,
      'status': status,
    };
    final address = {
      'lat': aLat,
      'lng': aLng,
      'province': aProvince,
      'district': aDistrict,
      'ward': aWard,
      'title': aTitle,
    };
    company.removeWhere((key, value) => value == null || value == '');
    address.removeWhere((key, value) => value == null || value == '');
    return {
      'company': company,
      'address': address,
    };
  }
}
