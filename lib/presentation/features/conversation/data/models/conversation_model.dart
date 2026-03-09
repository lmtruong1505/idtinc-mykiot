
import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  factory ConversationModel({
    int? id,
    @JsonKey(name: 'user_id')
    String? uuid,
    @JsonKey(name: 'zalo_name')
    String? name,
    @JsonKey(name: 'zalo_img')
    String? image,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
    @JsonKey(name: 'last_message')
    MessageModel? lastMessage,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) => _$ConversationModelFromJson(json);
}

@freezed
class MemberModel with _$MemberModel {
  const MemberModel._();

  factory MemberModel({
    int? id,
    String? name,
    String? phone,
    @JsonKey(name: 'user_avatar')
    String? avatar,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);
}