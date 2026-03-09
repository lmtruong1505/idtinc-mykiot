
import 'package:freezed_annotation/freezed_annotation.dart';

part 'district_model.freezed.dart';
part 'district_model.g.dart';
@freezed
class DistrictModel with _$DistrictModel {
  const DistrictModel._();

  const factory DistrictModel({
    String? code,
    String? name,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'full_name_en') String? fullNameEn,
    @JsonKey(name: 'code_name') String? codeName,
    @JsonKey(name: 'province_code') String? provinceCode,
    @JsonKey(name: 'administrative_unit') int? administrativeUnit,
  }) = _DistrictModel;

  factory DistrictModel.fromJson(Map<String, dynamic> json) => _$DistrictModelFromJson(json);
}