import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/features_v2/models/position/position_model.dart';
import 'package:pharmago/presentation/features_v2/models/role/role_model.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';
import '../../models/role/detail_role_model.dart';

class RoleV2Repository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel> getPerRoleWp({
    required int company,
  }) async {
    try {
      final res = await _dio.get("${Api.permissionWorkspace}$company");

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<List<RoleListModel>>> getRoles({
    required int company,
    int limit = 10,
    required int page,
    String? search,
    int? position,
  }) async {
    try {
      final payload = {
        'company': company,
        'limit': limit,
        'page': page,
        'search': search,
        'position': position,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.roleList,
        data: payload,
      );
      final List<RoleListModel> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(RoleListModel.fromJson(json));
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
        extra: res.data['count'] ?? 0,
      );
    } catch (e) {
      print('getRoles: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<List<PositionModel>>> getPositions({
    required int company,
  }) async {
    try {
      final payload = {
        'company': company,
      };
      final res = await _dio.get(
        Api.position,
        data: payload,
      );
      final List<PositionModel> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(PositionModel.fromJson(json));
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
        extra: res.data['count'] ?? 0,
      );
    } catch (e) {
      print('getPos: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<List<RoleListModel>>> getPermissions() async {
    try {
      final res = await _dio.get(
        Api.permission,
      );
      final List<RoleListModel> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(RoleListModel.fromJson(json));
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<int>> createRole(Map<String, dynamic> data) async {
    try {
      final res = await _dio.post(
        Api.roleCreate,
        data: data,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updateRole(
    Map<String, dynamic> data,
    int id,
  ) async {
    try {
      final res = await _dio.put(
        '${Api.roleCreate}/detail/$id',
        data: data,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<DetailRoleModel>> getDetail(int id) async {
    try {
      final res = await _dio.get('${Api.roleDetail}$id');
      final dataRes = res.data['details'];
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: DetailRoleModel.fromJson(dataRes),
      );
    } catch (e) {
      print('getDetail: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> assignEmp({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.post(Api.employeeRole, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> detachEmp({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.post(Api.detachEmp, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> delete({
    required int id,
  }) async {
    try {
      final res = await _dio.delete('${Api.roleList}/detail/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
