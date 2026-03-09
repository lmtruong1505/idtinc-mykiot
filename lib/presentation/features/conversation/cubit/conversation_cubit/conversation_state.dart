import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';


part 'conversation_state.freezed.dart';

@freezed
class ConversationState with _$ConversationState {
  factory ConversationState({
    ConversationEntity? conversation,
    @Default('') String content,
    String? uuid,
    @Default('') String search,
    List<MessageEntity>? messages,
    List<ConversationEntity>? conversations,
    File? image,
    @Default(20) int limit,
    @Default(true) bool canLoadMore,
    @Default(1) int page,
  }) = _ConversationState;
}
