import 'package:pharmago/data/models/base/response.dart';

import '../entities/auth_ws_entity.dart';

abstract class AuthWsRepository {
  Future<BaseResponseModel<AuthWsEntity>> getAuthWs(int id);
  Future<BaseResponseModel<AuthWsEntity>> createAuthWs({
    required int id,
    required String password,
    DateTime? endDate,
  });
  Future<BaseResponseModel<AuthWsEntity>> updateAuthWs({
    required int id,
    required String password,
  });
  Future<BaseResponseModel<int>> verifyAuthWs({
    required int id,
    required String password,
  });
}
