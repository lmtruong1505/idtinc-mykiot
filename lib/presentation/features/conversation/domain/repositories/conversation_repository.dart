
import '../../../../../data/models/base/response.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';

abstract class ChatRepository {
  Future<BaseResponseModel<List<ConversationModel>>> getChats({
    String? search,
    int? page,
    int? limit,
  });

  Future<BaseResponseModel<MessageModel>> sendMessage({
    required String content,
    String? uuid,
  });

  Future<BaseResponseModel<int>> countChatsNotSend({int? page, int? limit});

  Future<BaseResponseModel<List<MessageModel>>> getMessages({
    required String uuid,
    int? page,
    int? limit,
  });

  // Future<BaseResponseModel<ContactModel>> getContact(int id);

  Future<BaseResponseModel> deleteMessages(String uuid);

  Future<BaseResponseModel<int>> countNotSeen();
}
