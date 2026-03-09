import 'package:pharmago/data/models/base/response.dart';

abstract class RegisterCompanyRepository {
  Future<dynamic> getList(int company, String search, int page);
  Future<dynamic> getDetail(int id);
  Future<BaseResponseModel> create(Map<String, Object> data);
  Future<BaseResponseModel> update(int id, Map<String, Object> data);
  Future<BaseResponseModel> delete(int id);
}
