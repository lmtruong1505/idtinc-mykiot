import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_record_state.freezed.dart';

@freezed
class MedicalRecordState with _$MedicalRecordState {
  const factory MedicalRecordState({
    int? id,
    @Default('') String search,
    @Default(false) bool isLoading,
  }) = _MedicalRecordState;
}
