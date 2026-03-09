import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication/domain/entities/account_entity.dart';
import '../../../product/domain/entities/variant_entity.dart';

part 'medical_record_entity.freezed.dart';

@freezed
class MedicalRecordEntity with _$MedicalRecordEntity {
  const MedicalRecordEntity._();

  const factory MedicalRecordEntity({
    @Required() int? id,
    @Required() String? code,
    @Required() int? customer,
    @Required() int? weight,
    @Required() int? long,
    @Required() String? symptom,
    @Required() String? diagnostic,
    @Required() String? result,
    @Required() AccountEntity? doctor,
    @Required() int? reExamination,
    @Required() String? note,
    @Required() List<VariantEntity>? variants,
    @Required() DateTime? createdAt,
    @Required() DateTime? updatedAt,
    @Required() AccountEntity? userCreated,
  })  = _MedicalRecordEntity;
}
