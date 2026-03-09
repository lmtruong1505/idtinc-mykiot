import 'package:freezed_annotation/freezed_annotation.dart';

part 'ward_model.freezed.dart';
part 'ward_model.g.dart';

@freezed
class WardModel with _$WardModel {
  const WardModel._();

  const factory WardModel({
    String? code,
    String? name,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'full_name_en') String? fullNameEn,
    @JsonKey(name: 'code_name') String? codeName,
    @JsonKey(name: 'district_code') String? districtCode,
    @JsonKey(name: 'administrative_unit_id') int? administrativeUnitId,
  }) = _WardModel;

  factory WardModel.fromJson(Map<String, dynamic> json) =>
      _$WardModelFromJson(json);
}
