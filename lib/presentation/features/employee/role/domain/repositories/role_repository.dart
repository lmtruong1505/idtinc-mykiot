import 'package:pharmago/data/models/base/response.dart';

abstract class RoleRepository {
  Future<dynamic> getMasterList();
  Future<dynamic> getList(int company, String search, int page, {int limit});
  Future<dynamic> getDetail(int id);
  Future<BaseResponseModel> create(Map<String, dynamic> data);
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data);
  Future<BaseResponseModel> delete(int id);
  Future<BaseResponseModel> addEmployeeRole({
    required int roleId,
    required List<int> employeeIds,
  });
}
