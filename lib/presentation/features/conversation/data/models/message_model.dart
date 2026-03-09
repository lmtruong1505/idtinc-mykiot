import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    int? id,
    @JsonKey(name: 'message_text')
    String? messageText,
    String? message,
    @JsonKey(name: 'send_by_me')
    bool? isMe,
    @JsonKey(name: 'send_by')
    dynamic sendBy,
    bool? read,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
}
