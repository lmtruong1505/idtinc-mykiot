import 'package:pharmago/presentation/features_v2/models/employee/emp_model.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/config/dio.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';
import '../../models/employee/user_data_model.dart';

class EmpRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<PreEmpModel>>> getEmpSerrvice({
    required int company,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.empService}?workspace=$company',
      );
      final List<PreEmpModel> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(PreEmpModel.fromJson(json));
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
        data: null,
      );
    }
  }

  Future<BaseResponseModel<List<PreEmpModel>>> getEmps({
    required int company,
    int limit = 10,
    required int page,
    String? search,
    int? role,
    String status = 'ALL',
  }) async {
    try {
      final payload = {
        'company': company,
        'limit': limit,
        'page': page,
        'search': search,
        'role': role,
        'status': status,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.emp,
        data: payload,
      );
      final List<PreEmpModel> list = [];
      for (final json in res.data['data'] ?? []) {
        list.add(PreEmpModel.fromJson(json));
      }
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
        extra: res.data['count'] ?? 0,
      );
    } catch (e) {
      print('getEmps: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<EmpModel>> getEmp({
    required int id,
    required int company,
  }) async {
    try {
      final payload = {
        'company': company,
      };
      final res = await _dio.get(
        '${Api.emp}/$id',
        data: payload,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: EmpModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      print('getEmp: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<BaseResponseModel<UserDataModel>> getEmpByCodePharma({
    required String code,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.empByCodePharma}/$code',
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: UserDataModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<BaseResponseModel> assignEmp({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.post(
        Api.emp,
        data: payload,
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

  Future<BaseResponseModel> changeStatus({
    required String status,
    required int workspaceId,
  }) async {
    try {
      final res = await _dio.delete(
        '${Api.emp}/$workspaceId',
        data: {
          'status': status,
        },
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

  Future<BaseResponseModel> terminate({
    required int company,
    required int id,
  }) async {
    try {
      final res = await _dio.post(
        '${Api.empTerminated}/$id',
        data: {
          'workspace': company,
        },
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

  Future<BaseResponseModel> updateWorkingData({
    required int idUser,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.put(
        '${Api.emp}/$idUser',
        data: payload,
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
}
