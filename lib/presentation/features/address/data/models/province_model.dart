
import 'package:freezed_annotation/freezed_annotation.dart';

part 'province_model.freezed.dart';
part 'province_model.g.dart';
@freezed
class ProvinceModel with _$ProvinceModel {
  const ProvinceModel._();

  const factory ProvinceModel({
    String? code,
    String? name,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'full_name_en') String? fullNameEn,
    @JsonKey(name: 'code_name') String? codeName,
    @JsonKey(name: 'administrative_unit_id') int? administrativeUnitId,
    @JsonKey(name: 'administrative_region_id') int? administrativeRegionId,
  }) = _ProvinceModel;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => _$ProvinceModelFromJson(json);
}