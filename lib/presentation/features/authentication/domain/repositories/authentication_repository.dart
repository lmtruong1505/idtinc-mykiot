import '../../../../../data/models/base/response.dart';
import '../../data/models/response_authen_model.dart';
import '../../data/models/response_register_model.dart';

abstract class AuthenticationRepository {
  Future<BaseResponseModel<ResponseAuthModel>> userLogin({
    required String username,
    required String password,
  });

  Future<BaseResponseModel<ResponseRegisterModel>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String accountType,
    required String? code,
  });

  Future<BaseResponseModel<bool>> verify({
    required String secretCode,
    required int idVerify,
  });

  Future<BaseResponseModel> checkEmail({
    required String email,
  });

  Future<BaseResponseModel> checkPhone({
    required String phone,
  });

  Future<BaseResponseModel<int>> sendCode({
    required String phone,
  });

  Future<BaseResponseModel> verifyCode({
    required int id,
    required String code,
  });

  Future<BaseResponseModel> resetPassword({
    required int idVerify,
    required String codeVerify,
    required String password,
  });
}
