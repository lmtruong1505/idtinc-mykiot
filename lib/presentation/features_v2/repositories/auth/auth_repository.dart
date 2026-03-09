import 'package:dio/dio.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';

class AuthRepositoryV2 {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel> otpResetPass(String phone) async {
    try {
      final response = await _dio.post(
        Api.resetPass,
        data: {
          'phone': phone,
        },
      );
      return BaseResponseModel(
        code: response.data['code'],
        message: response.data['message'],
        data: response.data['details'],
      );
    } on DioException catch (error) {
      return BaseResponseModel(
        code: 400,
        message: error.message,
      );
    }
  }

  Future<BaseResponseModel> verifyResetPass({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        Api.verifyOtpResetPass,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      return BaseResponseModel(
        code: response.data['code'],
        message: response.data['message'],
        data: response.data['details'],
      );
    } on DioException catch (error) {
      return BaseResponseModel(
        code: 400,
        message: error.message,
      );
    }
  }

  Future<BaseResponseModel> newPass({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        Api.newPass,
        data: {
          'phone': phone,
          'password': password,
        },
      );
      return BaseResponseModel(
        code: response.data['code'],
        message: response.data['message'],
        data: response.data['details'],
      );
    } on DioException catch (error) {
      return BaseResponseModel(
        code: 400,
        message: error.message,
      );
    }
  }

  Future<BaseResponseModel> deleteAccount(int? id) async {
    try {
      final response = await _dio.delete('${Api.deleteAccount}/$id');

      return BaseResponseModel(
        code: response.data['code'],
        message: response.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
