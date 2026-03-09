import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_record_payload.freezed.dart';
part 'medical_record_payload.g.dart';

@freezed
class MedicalRecordPayloadEntity with _$MedicalRecordPayloadEntity {
  const MedicalRecordPayloadEntity._();

  const factory MedicalRecordPayloadEntity({
    int? customer,
    double? weight,
    double? long,
    String? symptom,
    String? diagnostic,
    String? result,
    int? doctor,
    @JsonKey(name: 're_examination')
    int? reExamination,
    String? note,

  }) = _MedicalRecordPayloadEntity;

  factory MedicalRecordPayloadEntity.fromJson(Map<String, dynamic> json) => _$MedicalRecordPayloadEntityFromJson(json);
}
