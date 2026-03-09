import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/data/local/get_data.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/config/dio.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';
import '../../models/profile/profile_model.dart';

class ProfileRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<ProfileModel>> getProfile() async {
    try {
      final response = await _dio.get(
        Api.profile,
      );
      final profile = ProfileModel.fromJson(response.data['details']);
      return BaseResponseModel(
        code: response.data['code'],
        message: response.data['message'],
        data: profile,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> changePass({
    required String oldPass,
    required String newPass,
  }) async {
    try {
      final res = await _dio.post(
        Api.changePass,
        data: {
          'old_password': oldPass,
          'new_password': newPass,
        },
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

  Future<BaseResponseModel> changeAvatar({
    required XFile file,
  }) async {
    try {
      final partFile =
          await MultipartFile.fromFile(file.path, filename: file.name);
      final payload = {
        'avatar': partFile,
      };
      final FormData formData = FormData.fromMap(payload);
      final res = await _dio.post(
        Api.changeAvatar,
        data: formData,
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

  Future<BaseResponseModel> updateProfile({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.put(
        Api.profile,
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

  Future<BaseResponseModel> inActiveAccount() async {
    try {
      final id = getAccountId;
      final res = await _dio.post(
        '${Api.profileAction}/$id',
        data: {
          'is_active': false,
        },
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
