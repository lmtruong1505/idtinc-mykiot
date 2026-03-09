import '../../../../../data/models/base/response.dart';
import '../../data/models/customer_group_model.dart';

abstract class CustomerGroupRepository {
  Future<BaseResponseModel<List<CustomerGroupModel>>> getList({required int? company, String? search, int? page, int? limit});
  Future<BaseResponseModel<CustomerGroupModel>> getDetail({required int id});
  Future<BaseResponseModel> create({required Map<String, dynamic> payload});
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data);
  Future<BaseResponseModel> delete(int id);
}