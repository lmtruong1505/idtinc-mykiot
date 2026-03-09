import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../data/config/dio.dart';
import '../../../../../data/models/base/response.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl extends ChatRepository {
  ChatRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<int>> countChatsNotSend({
    int? page,
    int? limit,
  }) async {
    try {
      final data = {
        'page': page,
        'per_page': limit,
      };
      final rp = await _dio.get(Api.chatList, data: data);
      final output = BaseResponseModel<int>(code: 200);
      if (rp.data == null || rp.data['items'] == null) {
        return output.copyWith(data: 0);
      }
      int count = 0;
      for (final item in rp.data['items'] as List) {
        count += (item['last_message']['send_by_me'] ?? false) ? 0 : 1;
      }
      return output.copyWith(data: count);
    } catch (e) {
      return BaseResponseModel<int>(code: 400, message: e.toString(), data: 0);
    }
  }

  @override
  Future<BaseResponseModel> deleteMessages(String uuid) async {
    return await _dio.delete(Api.chatMessages, data: {'uuid': uuid});
  }

  @override
  Future<BaseResponseModel<List<ConversationModel>>> getChats({
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final data = {
        'oaId': PrefKeys.oaId,
        'search': search,
        'page': page,
        'per_page': limit,
      };
      final rp = await _dio.get('${Api.conversationList}list', data: data);
      final dataModel = (rp.data['details'] as List)
          .map((e) => ConversationModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<ConversationModel>>(
        code: rp.data['code'],
        data: dataModel,
        message: rp.data['message'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel<List<ConversationModel>>(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<MessageModel>>> getMessages({
    required String uuid,
    int? page,
    int? limit,
  }) async {
    try {
      final data = {
        'oaId': PrefKeys.oaId,
        'userId': uuid,
        'page': page,
        'perPage': limit,
      };
      final rp = await _dio.get('${Api.messageList}list', data: data);
      final List<MessageModel> list = [];
      if (rp.data['details'] is List) {
        for (final json in rp.data['details']) {
          final model = MessageModel.fromJson(json);
          final data = json;
          data['send_by_me'] =
              model.sendBy is int ? model.sendBy == 1 : model.sendBy != 'USER';
          data['read'] = model.read ?? false;

          list.add(MessageModel.fromJson(data));
        }
      }

      return BaseResponseModel(
        code: 200,
        message: rp.data['message'],
        data: list,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<MessageModel>> sendMessage({
    required String content,
    String? uuid,
  }) async {
    final res = await Dio().post(
      Api.chatMessages,
      data: {
        'content': content,
        'uuid': uuid,
      },
    );
    final data = MessageModel.fromJson(res.data);
    return BaseResponseModel(
      code: res.statusCode,
      message: res.statusMessage,
      data: data.copyWith(
        isMe: true,
        read: true,
      ),
    );
  }

  @override
  Future<BaseResponseModel<int>> countNotSeen() async {
    try {
      final rp =
          await _dio.get(Api.chatList, data: {'page': 1, 'per_page': 200});
      int count = 0;
      for (final item in rp.data['items'] as List) {
        count += (item['last_message']['send_by_me'] ?? false) ? 0 : 1;
      }
      return BaseResponseModel(
        code: rp.data['code'],
        message: rp.data['message'],
        data: count,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
