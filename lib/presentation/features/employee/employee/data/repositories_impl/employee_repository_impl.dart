import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';

import '../../domain/repositories/employee_repository.dart';

@LazySingleton(as: EmployeeRepository)
class EmployeeRepositoryImpl extends EmployeeRepository {
  EmployeeRepositoryImpl(this._dio);

  final BaseDio _dio;

  

  @override
  Future<BaseResponseModel<List<EmployeeModel>>> getList({
    int? company,
    String? search,
    int? page,
    int? limit,
    int? role,
    bool? active,
  }) async {
    try {
      final query = {
        'page': (page ?? 0) + 1,
        'limit': limit ?? 10,
        'company': company,
        'search': search,
        'active': active,
        'role': role,
      };
      query.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.get(Api.accountList, data: query);
      final List<EmployeeModel> list = [];
      if (res.data['details'] is List) {
        final dataRes = res.data['details'] as List;
        list.addAll(dataRes.map((e) => EmployeeModel.fromJson(e)).toList());
      }
      return BaseResponseModel(
        code: 200,
        message: res.data['message'],
        data: list,
        extra: res.data['count'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<EmployeeModel>> getDetail(int id) async {
    try {
      final res = await _dio.get('${Api.staff}/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: EmployeeModel.fromJson(res.data['details']),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> create(Map<String, dynamic> data) async {
    try {
      data.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.post(Api.staff, data: data);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString(), );
    }
  }

  @override
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data) async {
    try {
      data.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.put('${Api.staff}/$id', data: data);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> delete(int id) async {
    try {
      final res = await _dio.delete('${Api.removeStaff}/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }


}
