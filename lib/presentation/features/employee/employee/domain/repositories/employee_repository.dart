import 'package:pharmago/data/models/base/response.dart';

import '../../data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<BaseResponseModel<List<EmployeeModel>>> getList({
    int? company,
    String? search,
    int? page,
    int? limit,
    int? role,
    bool? active,
  });
  Future<BaseResponseModel<EmployeeModel>> getDetail(int id);
  Future<BaseResponseModel<int>> create(Map<String, dynamic> data);
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data);
  Future<BaseResponseModel> delete(int id);

}
