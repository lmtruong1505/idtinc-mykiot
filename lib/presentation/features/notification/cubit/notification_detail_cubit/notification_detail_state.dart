import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/notification/domain/entities/notification_entity.dart';

part 'notification_detail_state.freezed.dart';

@freezed
class NotificationDetailState with _$NotificationDetailState {
  const factory NotificationDetailState({
    @Default(false) bool isLoading,
    NotificationEntity? notification,
  }) = _NotificationDetailState;
}
