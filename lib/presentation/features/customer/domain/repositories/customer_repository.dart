import 'package:image_picker/image_picker.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';

abstract class CustomerRepository {
  Future<BaseResponseModel<List<CustomerModel>>> getList(
      int company, String search, int page);
  Future<BaseResponseModel<CustomerModel>> getDetail(int id);
  Future<BaseResponseModel<CustomerModel>> create(Map<String, dynamic> data);
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data);
  Future<BaseResponseModel> delete(int id);
  Future<BaseResponseModel> uploadFile({
    required int customerId,
    required XFile file,
    required String type,
  });
  Future<BaseResponseModel<List<FileModel>>> getFile({
    required int customerId,
    required String type,
     String? appointmentSchedule,
  });
}
