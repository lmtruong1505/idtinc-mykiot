import 'package:freezed_annotation/freezed_annotation.dart';

import 'conversation_entity.dart';

part 'message_entity.freezed.dart';

@freezed
class MessageEntity with _$MessageEntity {
  const MessageEntity._();

  const factory MessageEntity({
    int? id,
    String? content,
    bool? isMe,
    MemberEntity? sendBy,
    List<int>? read,
    DateTime? createdAt,
    @Default(false) bool isRead,
    @Default(MessageStatus.sended) MessageStatus status,
  }) = _MessageEntity;
}

enum MessageStatus {
  sending,
  pending,
  sended,
}
