import 'package:pharmago/data/models/base/response.dart';

abstract class AccountRepository {
  Future<dynamic> getDetail();
  Future<BaseResponseModel> update(Map<String, Object> data);
  Future<BaseResponseModel> inactive();
  Future<BaseResponseModel<DateTime>> checkToken(String token);
}
