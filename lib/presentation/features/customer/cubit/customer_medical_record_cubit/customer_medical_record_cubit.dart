import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../features_v2/models/customer/v2/customer_model.dart';
import '../../../../features_v2/repositories/customer/customer_repository_v2.dart';
import '../../domain/repositories/medical_record_repository.dart';
import 'customer_medical_record_state.dart';

@injectable
class CustomerMedicalRecordCubit extends Cubit<CustomerMedicalRecordState> {
  CustomerMedicalRecordCubit(
    this._customerRepositoryV2,
    this._medicalRecordRepository,
  ) : super(const CustomerMedicalRecordState());

  final CustomerRepositoryV2 _customerRepositoryV2;
  final MedicalRecordRepository _medicalRecordRepository;

  void initCustomer(CustomerV2Model item) {
    emit(
      state.copyWith(
        customer: item,
        customerSelected: item,
      ),
    );
    _getListMember();
    _getMedicalRecordsCustomer();
  }

  void customerChange(CustomerV2Model item) {
    emit(state.copyWith(customerSelected: item));
    _getMedicalRecordsCustomer();
  }

  void searchChange(String value) {
    emit(state.copyWith(search: value));
    _getMedicalRecordsCustomer();
  }

  void _getListMember() async {
    final res = await _customerRepositoryV2.getList(
      companyId: getCompany!,
      parentCustomer: state.customer?.id,
    );
    emit(state.copyWith(customers: res.data ?? []));
  }

  void _getMedicalRecordsCustomer() async {
    if (state.customerSelected?.id == null) return;
    final res = await _medicalRecordRepository.medicalRecordsCustomer(
      state.customerSelected!.id!,
      state.search,
    );
    emit(state.copyWith(medicalRecords: res.data ?? []));
  }
}
