import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';

import '../../../../../features_v2/blocs/event/reminder_bloc.dart';
import '../../../../../features_v2/models/customer/v2/customer_model.dart';
import '../../../../../features_v2/models/service/service.dart';
import '../../../../customer/domain/repositories/medical_record_repository.dart';
import '../../../data/models/appointment_payload_data.dart';
import '../../../data/models/appointment_schedule_model.dart';
import '../../../data/models/diagnosis_model.dart';
import '../../../data/models/pathology_model.dart';
import '../../../data/repo/schedule_repository.dart';
import 'medical_schedule_editor_state.dart';

@injectable
class MedicalScheduleEditorCubit extends Cubit<MedicalScheduleEditorState> {
  MedicalScheduleEditorCubit(
    this._scheduleRepository,
    this._medicalRecordRepository,
  ) : super(const MedicalScheduleEditorState());

  final ScheduleRepository _scheduleRepository;
  final MedicalRecordRepository _medicalRecordRepository;

  void initData(
    AppointmentScheduleModel detailSchedule,
    DiagnosisModel diagnosis,
  ) {
    emit(
      state.copyWith(
        idSchedule: detailSchedule.id,
        customer: detailSchedule.customer,
        scheduleNote: detailSchedule.note,
        forMyself: !(detailSchedule.isRelatives ?? false),
        patient: detailSchedule.patient,
        mach: diagnosis.vitalSigns?.mch,
        nhietDo: diagnosis.vitalSigns?.nhit,
        huyetAp: diagnosis.vitalSigns?.huytP,
        nhipTho: diagnosis.vitalSigns?.nhipTh,
        canNang: diagnosis.vitalSigns?.cnNng,
        chieuCao: diagnosis.vitalSigns?.chiuCao,
        timeBooking: detailSchedule.meetingAt,
        services: detailSchedule.services?.map((e) {
              return e.serviceData!.copyWith(
                serviceEventId: e.id,
              );
            }).toList() ??
            [],
        pathologies: diagnosis.diagnosis ?? [],
        conclusion: diagnosis.conclusion,
      ),
    );
  }

  void stateChange({
    bool? forMyself,
    String? trieuChung,
    String? mach,
    String? nhietDo,
    String? huyetAp,
    String? nhipTho,
    String? canNang,
    String? chieuCao,
    DateTime? timeBooking,
    bool? isUseZaloOa,
    String? scheduleNote,
    String? conclusion,
    List<File>? images,
    List<File>? files,
    List<ReminderModel>? remindData,
    String? remindNote,
    List<ServiceV2Model>? services,
    List<PathologyModel>? pathologies,
  }) {
    emit(
      state.copyWith(
        forMyself: forMyself ?? state.forMyself,
        trieuChung: trieuChung ?? state.trieuChung,
        mach: mach ?? state.mach,
        nhietDo: nhietDo ?? state.nhietDo,
        huyetAp: huyetAp ?? state.huyetAp,
        nhipTho: nhipTho ?? state.nhipTho,
        canNang: canNang ?? state.canNang,
        chieuCao: chieuCao ?? state.chieuCao,
        timeBooking: timeBooking ?? state.timeBooking,
        isUseZaloOa: isUseZaloOa ?? state.isUseZaloOa,
        scheduleNote: scheduleNote ?? state.scheduleNote,
        images: images ?? state.images,
        files: files ?? state.files,
        remindData: remindData ?? state.remindData,
        remindNote: remindNote ?? state.remindNote,
        services: services ?? state.services,
        pathologies: pathologies ?? state.pathologies,
        conclusion: conclusion ?? state.conclusion,
      ),
    );
  }

  void customerChange(CustomerV2Model? customer) {
    emit(state.copyWith(customer: customer));
  }

  void patientChange(CustomerV2Model? patient) {
    emit(state.copyWith(patient: patient));
    _getMedicalRecordsCustomer();
  }

  void deleteImage(File image) {
    final listCopy = List<File>.from(
      state.images,
    );
    listCopy.removeWhere((e) => e.path == image.path);
    emit(state.copyWith(images: listCopy));
  }

  void deleteFile(File image) {
    final listCopy = List<File>.from(
      state.files,
    );
    listCopy.removeWhere((e) => e.path == image.path);
    emit(state.copyWith(files: listCopy));
  }

  Future<int?> create() async {
    final payload = AppointmentPayloadData(
      sendZns: state.isUseZaloOa,
      customerId: state.customer?.id,
      customerName: state.customer?.id == null ? state.customer?.fullName : null,
      customerPhone: state.customer?.id == null ? state.customer?.phone : null,
      customer: state.customer,
      note: state.scheduleNote,
      isRelatives: !state.forMyself,
      relatives: state.patient,
      relativesData: !state.forMyself
          ? RelativesData(
              relativesPhone: state.patient?.phone,
              relativesName: state.patient?.fullName,
            )
          : null,
      vitalSigns: VitalSigns(
        mch: state.mach,
        nhit: state.nhietDo,
        huytP: state.huyetAp,
        nhipTh: state.nhipTho,
        cnNng: state.canNang,
        chiuCao: state.chieuCao,
      ),
      company: getCompany,
      meetingAt: (state.timeBooking ?? DateTime.now())
          .fomatCustom(fomat: 'yyyy-MM-dd HH:mm'),
      services: state.services
          .map(
            (e) => Service(
              employeeId: e.employee?.employee,
              priceId: e.price?.id,
              serviceId: e.id,
            ),
          )
          .toList(),
      reminders: state.remindData
          ?.map(
            (e) => Reminder(
              message: state.remindNote,
              quantity: e.count,
              unit: e.type.code,
            ),
          )
          .toList(),
    );
    final res = await _scheduleRepository.create(
      data: payload,
      images: state.images,
      files: state.files,
    );
    return res.data;
  }

  Future<int?> update() async {
    final payload = AppointmentPayloadData(
      customerId: state.customer?.id,
      symptoms: state.scheduleNote,
      note: state.scheduleNote,
      isRelatives: !state.forMyself,
      conclusion: state.conclusion,
      relativesData: !state.forMyself
          ? RelativesData(
              relativesPhone: state.patient?.phone,
              relativesName: state.patient?.fullName,
            )
          : null,
      vitalSigns: VitalSigns(
        mch: state.mach,
        nhit: state.nhietDo,
        huytP: state.huyetAp,
        nhipTh: state.nhipTho,
        cnNng: state.canNang,
        chiuCao: state.chieuCao,
      ),
      pathology: state.pathologies.map((e) => e.id!).toList(),
      company: getCompany,
      meetingAt: (state.timeBooking ?? DateTime.now())
          .fomatCustom(fomat: 'yyyy-MM-dd HH:mm'),
      services: state.services
          .map(
            (e) => Service(
              id: e.serviceEventId,
              employeeId: e.employee?.employee,
              priceId: e.price?.id,
              serviceId: e.id,
            ),
          )
          .toList(),
      reminders: state.remindData
          ?.map(
            (e) => Reminder(
              message: state.remindNote,
              quantity: e.count,
              unit: e.type.code,
            ),
          )
          .toList(),
    );
    final res = await _scheduleRepository.update(
      data: payload,
      id: state.idSchedule!,
    );
    return res.data;
  }

  Future<int?> updateConclusion() async {
    final res = await _scheduleRepository.updateConclusion(
      idSchedule: state.idSchedule!,
      conclusion: state.conclusion ?? '',
      note: state.scheduleNote ?? '',
      images: state.images,
      files: state.files,
    );
    return res.data;
  }

  void _getMedicalRecordsCustomer() async {
    if (state.patient?.id == null) {
      emit(state.copyWith(medicalRecords: []));
      return;
    }
    final res = await _medicalRecordRepository.medicalRecordsCustomer(
      state.patient!.id!,
      '',
    );
    emit(state.copyWith(medicalRecords: res.data ?? []));
  }
}
