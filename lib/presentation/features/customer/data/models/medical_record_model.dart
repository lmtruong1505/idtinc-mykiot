import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication/data/models/account_model.dart';
import '../../../product/data/models/variant_model.dart';

part 'medical_record_model.freezed.dart';
part 'medical_record_model.g.dart';

@freezed
class MedicalRecordModel with _$MedicalRecordModel {
  const MedicalRecordModel._();

  const factory MedicalRecordModel({
    int? id,
    String? code,
    int? customer,
    int? weight,
    int? long,
    String? symptom,
    String? diagnostic,
    String? result,
    AccountModel? doctor,
    @JsonKey(name: 're_examination')
    int? reExamination,
    String? note,
    List<VariantModel>? variants,
    @JsonKey(name: 'created_at')
    String? createdAt,
    @JsonKey(name: 'updated_at')
    String? updatedAt,
    AccountModel? userCreated,
  }) = _MedicalRecordModel;

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordModelFromJson(json);
}
