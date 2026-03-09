import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';

import '../../domain/entities/medical_record_payload.dart';

part 'medical_record_create_state.freezed.dart';

@freezed
class MedicalRecordCreateState with _$MedicalRecordCreateState {
  const factory MedicalRecordCreateState({
    @Default(MedicalRecordPayloadEntity()) MedicalRecordPayloadEntity medicalRecordPayload,
    EmployeeEntity? doctorSelected,
    CustomerEntity? customerSelected,
  }) = _MedicalRecordCreateState;
}
