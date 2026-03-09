import 'package:freezed_annotation/freezed_annotation.dart';

import '../../widget/bts_filter_noti.dart';

part 'notification_manager_state.freezed.dart';

@freezed
class NotificationManagerState with _$NotificationManagerState {
  const factory NotificationManagerState({
    @Default('') String search,
    @Default(10) int limit,
    @Default(FilterType.all) FilterType? type,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? specificDay,
    @Default(0) unReadNotificationCount,
  }) = _NotificationManagerState;

}
