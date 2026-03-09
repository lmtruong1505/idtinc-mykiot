import 'package:injectable/injectable.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

@injectable
class ConversationEntityMapper
    extends BaseDataMapper<ConversationModel, ConversationEntity> {
  ConversationEntityMapper(
    this._messageEntityMapper,
  );
  final MessageEntityMapper _messageEntityMapper;

  @override
  ConversationEntity mapToEntity(ConversationModel? data) {
    return ConversationEntity(
      id: data?.id,
      uuid: data?.uuid,
      createdAt: data?.createdAt,
      updatedAt: data?.updatedAt,
      avatar: data?.image,
      name: data?.name,
      lastMessage: _messageEntityMapper.mapToEntity(data?.lastMessage),
    );
  }
}

@injectable
class MemberEntityMapper extends BaseDataMapper<MemberModel, MemberEntity> {
  @override
  MemberEntity mapToEntity(MemberModel? data) {
    return MemberEntity(
      id: data?.id,
      name: data?.name,
      phone: data?.phone,
      avatar: data?.avatar,
    );
  }
}

@injectable
class MessageEntityMapper extends BaseDataMapper<MessageModel, MessageEntity> {
  MessageEntityMapper();

  @override
  MessageEntity mapToEntity(MessageModel? data) {
    return MessageEntity(
      id: data?.id,
      content: data?.messageText ?? data?.message,
      isMe: data?.sendBy is int ? data?.sendBy == 1 : data?.sendBy != 'USER',
      isRead: data?.read ?? false,
      createdAt: data?.createdAt,
    );
  }
}
