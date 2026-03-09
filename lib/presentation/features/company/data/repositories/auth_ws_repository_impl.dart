import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../../../../data/apis/end_point.dart';
import '../../domain/repositories/auth_ws_repository.dart';
import '../models/auth_ws_model.dart';

@LazySingleton(as: AuthWsRepository)
class AuthWsRepositoryImpl extends AuthWsRepository {
  AuthWsRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<AuthWsModel>> createAuthWs({
    required int id,
    required String password,
    DateTime? endDate,
  }) async {
    try {
      final payload = {
        'workspace': id,
        'password': password,
        'end_date': endDate?.toIso8601String() ?? '2222-12-31T23:59:59Z',
      };
      final res = await _dio.post('${Api.authWs}/create', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: AuthWsModel.fromJson(res.data['data']),
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<AuthWsModel>> getAuthWs(int id) async {
    try {
      final res = await _dio.get('${Api.authWs}/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: AuthWsModel.fromJson(res.data['data']),
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<AuthWsModel>> updateAuthWs({
    required int id,
    required String password,
  }) async {
    try {
      final payload = {
        'password': password,
      };
      final res = await _dio.put('${Api.authWs}/$id', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: AuthWsModel.fromJson(res.data['data']),
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<int>> verifyAuthWs({
    required int id,
    required String password,
  }) async {
    try {
      final payload = {
        'workspace': id,
        'password': password,
      };
      final res = await _dio.post(Api.authWsVerify, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }
}
