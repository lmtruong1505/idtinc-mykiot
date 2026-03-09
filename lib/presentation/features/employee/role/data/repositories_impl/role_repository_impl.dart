import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/employee/role/domain/repositories/role_repository.dart';

@LazySingleton(as: RoleRepository)
class RoleRepositoryImpl extends RoleRepository {
  RoleRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<dynamic> getMasterList() async {
    try {
      final res = await _dio.get(Api.roleMasterList);
      final dataRes = res.data['details'];
      if (dataRes != null) return dataRes;
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }
  }

  @override
  Future<dynamic> getList(
    int company,
    String search,
    int page, {
    int limit = 10,
  }) async {
    try {
      final query = {
        'page': page + 1,
        'company': company,
        'search': search,
        'limit': limit,
      };
 
      
      final res = await _dio.get(Api.roleList, data: query);
      final dataRes = res.data['details'];
      if (dataRes != null) return dataRes;
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }
  }

  @override
  Future<dynamic> getDetail(int id) async {
    try {
      final res = await _dio.get('${Api.roleDetail}$id');
      final dataRes = res.data['details'];
      if (dataRes != null) return dataRes;
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return null;
  }

  @override
  Future<BaseResponseModel> create(Map<String, dynamic> data) async {
    try {
      final res = await _dio.post(Api.roleCreate, data: data);
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
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data) async {
    try {
      final res = await _dio.put('${Api.roleDetail}$id', data: data);
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
      final res = await _dio.delete('${Api.roleDetail}$id');
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
  Future<BaseResponseModel> addEmployeeRole({
    required int roleId,
    required List<int> employeeIds,
  }) async {
    try {
      final res = await _dio.post(
        Api.employeeRole,
        data: {
          'role': roleId,
          'accounts': employeeIds,
        },
      );
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
