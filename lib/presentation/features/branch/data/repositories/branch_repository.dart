import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../data/models/base/response.dart';

class BranchRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<EmployeeModel>>> getStaff({
    int? companyId,
    String? search,
    int? role,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final payload = {
        'search': search,
        'role': role,
        'company': companyId,
        'status': status,
        'page': page,
        'limit': limit,
      };
      payload.removeWhere(
        (key, value) => value == null || value == '',
      );
      final res = await _dio.get(
        Api.employees,
        data: payload,
      );
      final List<EmployeeModel> list = [];
      if (res.data['data'] is List) {
        for (final json in res.data['data']) {
          final model = EmployeeModel.fromJson(json);
          final List<BasicModel> roles = [];

          for (final role in json['role_data']) {
            roles.add(
              BasicModel(
                id: role['role'].toString().toInt,
                name: role['role_name'],
              ),
            );
          }

          list.add(model.copyWith(roles: roles));
        }
      }

      return BaseResponseModel<List<EmployeeModel>>(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> removeStaff({
    required int id,
    required List<int> staffIds,
  }) async {
    try {
      final payload = {
        'company': id,
        'remove': staffIds,
      };

      payload.removeWhere(
        (key, value) => value == '',
      );
      final res = await _dio.post(
        '${Api.company}/assign_employee',
        data: payload,
      );
      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> addStaff({
    required int id,
    required List<Map<String, dynamic>> list,
  }) async {
    try {
      final payload = {
        'company': id,
        'assign': list,
      };

      payload.removeWhere(
        (key, value) => value == '',
      );
      final res = await _dio.post(
        '${Api.company}/assign_employee',
        data: payload,
      );
      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
