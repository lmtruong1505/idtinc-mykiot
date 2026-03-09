import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/data/models/medical_record_model.dart';

import '../../data/models/medical_record_customer_model.dart';

abstract class MedicalRecordRepository {
  Future<BaseResponseModel<List<MedicalRecordModel>>> getList({
    required int customer,
    String? search,
    int? page,
    int? limit,
  });
  Future<BaseResponseModel<MedicalRecordModel>> getDetail(int id);
  Future<BaseResponseModel<int>> create(Map<String, dynamic> payload);
  Future<BaseResponseModel<List<MedicalRecordCustomerModel>>>
      medicalRecordsCustomer(
    int idCustomer,
    String search,
  );
}
