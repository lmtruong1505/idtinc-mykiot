import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/usecase/medical_record_create_use_case.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../domain/usecase/customer_use_case.dart';
import 'medical_record_create_state.dart';

@injectable
class MedicalRecordCreateCubit extends Cubit<MedicalRecordCreateState> {
  MedicalRecordCreateCubit(
    this._medicalRecordCreateUseCase,
    this._customerUseCase,
  ) : super(const MedicalRecordCreateState());

  final MedicalRecordCreateUseCase _medicalRecordCreateUseCase;
  final CustomerUseCase _customerUseCase;

  Future<BaseResponseModel?> createMedicalRecord() async {
    final input = MedicalRecordCreateInput(
      payload: state.medicalRecordPayload,
    );
    final res = await _medicalRecordCreateUseCase.execute(input);
    return res.response;
  }

  void infoFormChange({
    int? customer,
    double? weight,
    double? long,
    String? symptom,
    String? diagnostic,
    String? result,
    int? doctor,
    int? reExamination,
    String? note,
  }) {
    final medicalRecordPayload = state.medicalRecordPayload.copyWith(
      customer: customer ?? state.medicalRecordPayload.customer,
      weight: weight ?? state.medicalRecordPayload.weight,
      long: long ?? state.medicalRecordPayload.long,
      symptom: symptom ?? state.medicalRecordPayload.symptom,
      diagnostic: diagnostic ?? state.medicalRecordPayload.diagnostic,
      result: result ?? state.medicalRecordPayload.result,
      doctor: doctor ?? state.medicalRecordPayload.doctor,
      reExamination: reExamination ?? state.medicalRecordPayload.reExamination,
      note: note ?? state.medicalRecordPayload.note,
    );
    emit(state.copyWith(medicalRecordPayload: medicalRecordPayload));
  }

  void selectDoctor(EmployeeEntity? value) {
    emit(
      state.copyWith(
        doctorSelected: value,
        medicalRecordPayload:
            state.medicalRecordPayload.copyWith(doctor: value?.id),
      ),
    );
  }

  void selectCustomer(CustomerEntity? value) {
    emit(
      state.copyWith(
        customerSelected: value,
        medicalRecordPayload:
            state.medicalRecordPayload.copyWith(customer: value?.id),
      ),
    );
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    var customer = id == null ? const CustomerEntity() : await _customerUseCase.getDetail(id);
    final company =
    AppSharedPreference.instance.getValue(PrefKeys.company) as int?;

    if (company == null) {
      if(context.mounted) {
        Navigator.of(context).pop();
      }
    }
    if (customer.company == 0) customer = customer.copyWith(company: company!);
    emit(state.copyWith(customerSelected: customer));
  }
}
