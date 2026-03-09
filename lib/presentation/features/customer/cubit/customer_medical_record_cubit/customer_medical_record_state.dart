import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../features_v2/models/customer/v2/customer_model.dart';
import '../../data/models/medical_record_customer_model.dart';

part 'customer_medical_record_state.freezed.dart';

@freezed
class CustomerMedicalRecordState with _$CustomerMedicalRecordState {
  const factory CustomerMedicalRecordState({
    CustomerV2Model? customer,
    /// customers is members
    @Default(<CustomerV2Model>[]) List<CustomerV2Model> customers,
    CustomerV2Model? customerSelected,
    @Default(0) int page,
    @Default(20) int limit,
    @Default('') String search,
    @Default(<MedicalRecordCustomerModel>[]) List<MedicalRecordCustomerModel> medicalRecords,
  }) = _CustomerMedicalRecordState;
}
