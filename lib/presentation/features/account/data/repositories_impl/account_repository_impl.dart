import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/account/domain/repositories/account_repository.dart';
import 'package:pharmago/presentation/features/authentication/data/models/account_model.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl extends AccountRepository {
  AccountRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<AccountModel?> getDetail() async {
    try {
      final res = await _dio.get(Api.accountDetail);
      final dataRes = res.data['details']['account'];
      if (dataRes != null) return AccountModel.fromJson(dataRes);
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return null;
  }

  @override
  Future<BaseResponseModel> update(Map<String, Object> data) async {
    try {
      final res = await _dio.put(Api.accountDetail, data: data);
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
  Future<BaseResponseModel> inactive() async {
    try {
      final res =
          await _dio.patch(Api.accountInactive, data: {'status': false});
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
  Future<BaseResponseModel<DateTime>> checkToken(String token) async {
    try {
      final res = await _dio.post(Api.checktoken, data: {'token': token});
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: DateTime.parse(res.data['details']),
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
