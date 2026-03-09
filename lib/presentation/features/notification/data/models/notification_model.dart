import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    int? id,
    String? type,
    String? topic,
    String? title,
    String? content,
    @JsonKey(name: 'is_read')
    bool? isRead,
    @JsonKey(name: 'can_access')
    bool? canAccess,
    Map<dynamic, dynamic>? data,
    @JsonKey(name: 'workspace_id')
    int? company,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}