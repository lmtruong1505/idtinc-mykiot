import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

@freezed
class NotificationEntity with _$NotificationEntity {
  const NotificationEntity._();

  const factory NotificationEntity({
    @Required() int? id,
    @Required() TypeNoti? type,
    @Required() String? topic,
    @Required() String? title,
    @Required() String? content,
    @Default(false) bool isRead,
    @Default(true) bool canAccess,
    @Required() Map<dynamic, dynamic>? data,
    @Required() int? company,
    @Required() DateTime? createdAt,
  }) = _NotificationEntity;
}

enum TypeNoti {
  order(Icon(Icons.notifications_rounded)),
  service(Icon(Icons.timer_sharp)),
  appointment(Icon(Icons.calendar_today_outlined)),
  system(Icon(Icons.calendar_today_outlined));

  final Icon icon;

  const TypeNoti(this.icon);
}