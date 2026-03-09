import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/authentication/data/models/response_register_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../data/config/dio.dart';
import '../../../../../data/models/base/response.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/response_authen_model.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final BaseDio _dio;

  AuthenticationRepositoryImpl(this._dio);

  @override
  Future<BaseResponseModel<ResponseAuthModel>> userLogin({
    required String username,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        Api.login,
        data: {
          'username': username,
          'password': password,
          'system_code': 'ADMIN',
        },
      );
      if (res.data['details'] == null) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
      final data = ResponseAuthModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: 'Tài khoản hoặc mật khẩu không chính xác',
      );
    }
  }

  @override
  Future<BaseResponseModel<ResponseRegisterModel>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String accountType,
    required String? code,
  }) async {
    try {
      final payload = {
        'username': phone,
        'phone': phone,
        'password': password,
        'fullName': fullName,
        'email': email,
        'referral_code': code,
        'accountType': accountType,
      };
      payload.removeWhere(
        (key, value) => value == null || value == '',
      );
      final res = await _dio.post(Api.register, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'] != null
            ? ResponseRegisterModel.fromJson(res.data['details'])
            : null,
        extra: res.data['verify_id'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<bool>> verify({
    required String secretCode,
    required int idVerify,
  }) async {
    try {
      final payload = {
        'idVerify': idVerify,
        'secretCode': secretCode,
      };
      final res = await _dio.post(Api.verify, data: payload);
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

  @override
  Future<BaseResponseModel> checkEmail({required String email}) async {
    try {
      final payload = {
        'email': email,
      };
      final res = await _dio.post('${Api.auth}/email', data: payload);
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

  @override
  Future<BaseResponseModel> resetPassword({
    required int idVerify,
    required String codeVerify,
    required String password,
  }) async {
    try {
      final payload = {
        'password': password,
        'code_verify': codeVerify,
        'id_verify': idVerify,
      };
      final res = await _dio.post('${Api.auth}/reset-password', data: payload);
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

  @override
  Future<BaseResponseModel<int>> sendCode({required String phone}) async {
    try {
      final payload = {
        'phone': phone,
      };
      final res = await _dio.post(Api.sendCode, data: payload);
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

  @override
  Future<BaseResponseModel> verifyCode({
    required int id,
    required String code,
  }) async {
    try {
      final payload = {'id': id, 'code': code};
      final res = await _dio.post('${Api.auth}/verify-code', data: payload);
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

  @override
  Future<BaseResponseModel> checkPhone({required String phone}) async {
    try {
      final payload = {
        'phone': phone,
      };
      final res = await _dio.post('${Api.auth}/phone', data: payload);
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
}
