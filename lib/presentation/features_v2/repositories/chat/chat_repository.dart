import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';

import '../../models/customer/message_zalo_model.dart';

class ChatRepositoryV2 {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<MessageZaloModel>>> getMessage({
    String? userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _dio.get(
        Api.chat,
        data: {
          'user_id': userId,
          'page': page,
          'limit': limit,
        },
      );
      final List<MessageZaloModel> messages = [];
      if (res.data['details']['messages'] is List) {
        res.data['details']['messages'].forEach((item) {
          messages.add(MessageZaloModel.fromJson(item));
        });
      }
      return BaseResponseModel(
        code: 200,
        data: messages,
        extra: int.tryParse(res.data['details']['count'].toString()),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> sendMessage({
    required String userId,
    required String message,
    List<Attachments>? attachments,
  }) async {
    try {
      final payload = {
        'user_id': userId,
        'message': message,
        'attachments': attachments
            ?.map(
              (e) => e.toJson(),
            )
            .toList(),
      };
      payload.removeWhere(
        (key, value) => value == null,
      );
      return BaseResponseModel(
        code: 200,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<Attachments>>> uploadImage({
    required XFile image,
  }) async {
    try {
      final partFile =
          await MultipartFile.fromFile(image.path, filename: image.name);
      final payload = {
        'image': partFile,
      };
      final FormData formData = FormData.fromMap(payload);

      final res = await _dio.post(
        Api.uploadImageChat,
        data: formData,
      );
      final List<Attachments> images = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          images.add(Attachments.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: 200,
        data: images,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
