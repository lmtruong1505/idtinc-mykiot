
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_payload_entity.freezed.dart';
part 'unit_payload_entity.g.dart';

@freezed
class UnitPayloadEntity with _$UnitPayloadEntity {
  const UnitPayloadEntity._();

  const factory UnitPayloadEntity({
    String? name,
    @JsonKey(name: 'sell_price') double? sellPrice,
    @JsonKey(name: 'import_price') double? importPrice,
    double? weight,
    @JsonKey(name: 'weight_unit') String? weightUnit,

  }) = _UnitPayloadEntity;

  factory UnitPayloadEntity.fromJson(Map<String, dynamic> json) => _$UnitPayloadEntityFromJson(json);
}

@freezed
class UnitChangePayloadEntity with _$UnitChangePayloadEntity {
  const UnitChangePayloadEntity._();

  const factory UnitChangePayloadEntity({
    String? name,
    int? value,
    @JsonKey(name: 'sellPrice') double? sellPrice,
  }) = _UnitChangePayloadEntity;

  factory UnitChangePayloadEntity.fromJson(Map<String, dynamic> json) => _$UnitChangePayloadEntityFromJson(json);
}