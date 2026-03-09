
import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_entity.dart';

part 'conversation_entity.freezed.dart';

@freezed
class ConversationEntity with _$ConversationEntity {
  const ConversationEntity._();

  factory ConversationEntity({
    int? id,
    String? uuid,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MemberEntity>? member,
    MessageEntity? lastMessage,
    String? name,
    String? avatar,
    String? phone,
  }) = _ConversationEntity;
}

@freezed
class MemberEntity with _$MemberEntity {
  const MemberEntity._();

  factory MemberEntity({
    int? id,
    String? name,
    String? phone,
    String? avatar,
  }) = _MemberEntity;
}