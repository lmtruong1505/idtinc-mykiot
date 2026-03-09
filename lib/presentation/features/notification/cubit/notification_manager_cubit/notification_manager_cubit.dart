import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/notification/domain/usecase/notification_list_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../order/domain/usecase/order_hub_action_use_case.dart';
import '../../domain/entities/notification_entity.dart';
import '../../widget/bts_filter_noti.dart';
import 'notification_manager_state.dart';

@injectable
class NotificationManagerCubit extends Cubit<NotificationManagerState> {
  NotificationManagerCubit(this._notificationListUseCase, this._orderHubAction)
      : super(const NotificationManagerState());

  final NotificationListUseCase _notificationListUseCase;
  final OrderHubActionUseCase _orderHubAction;
  final ScrollController scrollController = ScrollController();
  final InfiniteListController<NotificationEntity> notificationsILC =
      InfiniteListController<NotificationEntity>.init();

  Future<List<NotificationEntity>> getNotifications(int page, {String? type}) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = NotificationListInput(
      company: company ?? 0,
      type: type,
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );

    final res = await _notificationListUseCase.execute(input);
    emit(state.copyWith(unReadNotificationCount: res.response.extra ?? 0));
    return res.response.data ?? [];
  }

  void setFilter(FilterType type) {
    emit(state.copyWith(type: type));
  }

  void setStartDate(DateTime? date) {
    emit(state.copyWith(startDate: date));
  }

  void setEndDate(DateTime? date) {
    emit(state.copyWith(endDate: date));
  }

  void setSpecificDay(DateTime? date) {
    emit(state.copyWith(specificDay: date));
  }

  void orderHubActionHandler({
    required bool accept,
    required int workspace,
    required int notiId,
  }) async {
    final input = OrderHubActionInput(
      accept: accept,
      workspace: workspace,
      notiId: notiId,
    );
    final res = await _orderHubAction.execute(input);
    if (kDebugMode) {
      print('==========$res');
    }
  }
}
