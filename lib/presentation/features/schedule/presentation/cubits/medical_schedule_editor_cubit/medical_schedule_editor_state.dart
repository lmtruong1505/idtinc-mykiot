import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../features_v2/blocs/event/reminder_bloc.dart';
import '../../../../../features_v2/models/customer/v2/customer_model.dart';
import '../../../../../features_v2/models/service/service.dart';
import '../../../../customer/data/models/medical_record_customer_model.dart';
import '../../../data/models/pathology_model.dart';

part 'medical_schedule_editor_state.freezed.dart';

@freezed
class MedicalScheduleEditorState with _$MedicalScheduleEditorState {
  const factory MedicalScheduleEditorState({
    int? idSchedule,
    CustomerV2Model? customer,
    CustomerV2Model? patient,
    @Default(true) bool forMyself,
    String? trieuChung,
    String? mach,
    String? nhietDo,
    String? huyetAp,
    String? nhipTho,
    String? canNang,
    String? chieuCao,
    String? conclusion,
    DateTime? timeBooking,
    bool? isUseZaloOa,
    String? scheduleNote,
    @Default(<File>[]) List<File> images,
    @Default(<File>[]) List<File> files,
    @Default(<PathologyModel>[]) List<PathologyModel> pathologies,
    List<ReminderModel>? remindData,
    String? remindNote,
    @Default(<ServiceV2Model>[]) List<ServiceV2Model> services,
    @Default(<MedicalRecordCustomerModel>[]) List<MedicalRecordCustomerModel> medicalRecords,
  }) = _MedicalScheduleEditorState;
}
