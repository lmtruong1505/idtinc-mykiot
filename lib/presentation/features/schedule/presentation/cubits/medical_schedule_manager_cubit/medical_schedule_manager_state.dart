import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/appointment_schedule_model.dart';
import '../../../data/models/diagnosis_model.dart';
import '../../../data/models/pathology_model.dart';
import '../../../data/models/prescription_model.dart';

part 'medical_schedule_manager_state.freezed.dart';

@freezed
class MedicalScheduleManagerState with _$MedicalScheduleManagerState {
  const factory MedicalScheduleManagerState({
    @Default(false) bool isLoading,
    AppointmentScheduleModel? detailSchedule,
    PrescriptionModel? prescription,
    DiagnosisModel? diagnosis,
    List<PathologyModel>? pathologies,
  }) = _MedicalScheduleManagerState;
}
