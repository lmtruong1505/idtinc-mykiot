import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../../../di/di.dart';
import '../../../../../features_v2/models/product/image_model.dart';
import '../../../../../features_v2/models/product/product_v2_model.dart';
import '../../../../../features_v2/repositories/events/event_v2_repository.dart';
import '../../../data/models/pathology_model.dart';
import '../../../data/models/prescription_payload_model.dart';
import '../../../data/repo/schedule_repository.dart';
import 'medical_schedule_manager_state.dart';

@injectable
class MedicalScheduleManagerCubit extends Cubit<MedicalScheduleManagerState> {
  MedicalScheduleManagerCubit(
    this._scheduleRepository,
  ) : super(const MedicalScheduleManagerState());

  final _repo = getIt.get<EventV2Repository>();
  final ScheduleRepository _scheduleRepository;

  Future<void> getDetailSchedule(int id) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.detailV2(id);
    emit(
      state.copyWith(
        isLoading: false,
        detailSchedule: res.data,
      ),
    );
    getPrescription();
    getDiagnosis();
  }

  Future<void> getPrescription() async {
    if (state.detailSchedule?.id == null) return;
    final res = await _scheduleRepository.getPrescription(
        idSchedule: state.detailSchedule!.id!);
    emit(state.copyWith(prescription: res.data));
  }

  Future<void> getDiagnosis() async {
    if (state.detailSchedule?.id == null) return;
    final res = await _scheduleRepository.getDiagnosis(
        idSchedule: state.detailSchedule!.id!);
    emit(state.copyWith(diagnosis: res.data));
  }

  Future<void> createPrescription(List<ProductV2Model> products) async {
    final data = PrescriptionPayloadModel(
      appointment: state.detailSchedule?.id,
      items: products
          .map(
            (e) => PrescriptionPayload(
              lieuDung: e.ghiChu,
              product: e.id,
              quantity: e.quantity,
              unit: e.unitSell?.id,
            ),
          )
          .toList(),
    );
    await _scheduleRepository.createPrescription(data: data);
    getPrescription();
  }

  Future<bool> reSendEventZalo() async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.reSendEventZalo(state.detailSchedule!.id!);
    emit(state.copyWith(isLoading: false));
    return res.code == 200;
  }

  Future<bool> deleteSchedule() async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.remove(state.detailSchedule!.id!);
    emit(state.copyWith(isLoading: false));
    return res.code == 200;
  }

  Future<bool> updateStatus(String status) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.updateStatus(state.detailSchedule!.id!, status);
    emit(state.copyWith(isLoading: false));
    if (res.code == 200) {
      getDetailSchedule(state.detailSchedule!.id!);
    }
    return res.code == 200;
  }

  Future<bool> cancel(String reason) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.cancel(
      state.detailSchedule!.id!,
      reason,
    );
    if (res.code == 200) {
      getDetailSchedule(state.detailSchedule!.id!);
    }
    return res.code == 200;
  }

  Future<List<PathologyModel>> pathologies({
    required int page,
    String? search,
  }) async {
    final res = await _scheduleRepository.getPathologies(
      page: page,
      limit: 20,
      search: search,
    );
    return res.data ?? [];
  }

  Future<int?> createPathologies({
    required String name,
    required String code,
  }) async {
    final res = await _scheduleRepository.createPathologies(
      name: name,
      code: code,
    );
    return res.data ;
  }

  Future<void> createServiceConclusion({
    required int idService,
    required String conclusion,
    List<File>? files,
  }) async {
    final res = await _scheduleRepository.createConclusionService(
      idService: idService,
      conclusion: conclusion,
      files: files,
    );
    if (res.code == 200) {
      getDiagnosis();
    }
  }

  Future<void> updateServiceConclusion({
    required int idService,
    required String conclusion,
    List<File>? files,
    List<ImageModel>? filesUpdate,
  }) async {
    final serviceSchedule = state.diagnosis?.appointmentService
        ?.firstWhereOrNull((e) => e.id == idService);
    if (serviceSchedule == null) return;
    if (serviceSchedule.medicalBillData?.isEmpty ?? true) return;
    final res = await _scheduleRepository.updateConclusionService(
      id: serviceSchedule.medicalBillData!.first.id!,
      conclusion: conclusion,
      files: files,
      filesUpdate: filesUpdate,
    );
    if (res.code == 200) {
      getDiagnosis();
    }
  }
}
