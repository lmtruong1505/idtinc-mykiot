
import 'package:freezed_annotation/freezed_annotation.dart';

part 'variant_payload_entity.freezed.dart';
part 'variant_payload_entity.g.dart';

@freezed
class VariantPayloadEntity with _$VariantPayloadEntity {
  const VariantPayloadEntity._();

  const factory VariantPayloadEntity({
    String? name,
    String? barcode,
    double? vat,
    String? decisionNumber,
    String? registerNumber,
    String? code,
    String? longevity,
    String? image,
    @Default(false) bool isDefault,
    int? initialInventory,
  }) = _VariantPayloadEntity;

  factory VariantPayloadEntity.fromJson(Map<String, dynamic> json) => _$VariantPayloadEntityFromJson(json);
}