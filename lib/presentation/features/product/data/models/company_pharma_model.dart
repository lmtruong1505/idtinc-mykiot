import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_pharma_model.freezed.dart';
part 'company_pharma_model.g.dart';

@freezed
class CompanyPharmaModel with _$CompanyPharmaModel {
  const CompanyPharmaModel._();

  const factory CompanyPharmaModel({
    int? id,
    String? code,
    String? name,
    String? country,
    String? address,
    String? type,
  }) = _CompanyPharmaModel;

  factory CompanyPharmaModel.fromJson(Map<String, dynamic> json) => _$CompanyPharmaModelFromJson(json);
}