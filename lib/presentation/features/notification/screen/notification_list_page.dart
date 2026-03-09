import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../../base/empty_container.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/notification_manager_cubit/notification_manager_cubit.dart';
import '../cubit/notification_manager_cubit/notification_manager_state.dart';
import '../domain/entities/notification_entity.dart';
import '../widget/bts_filter_noti.dart';

@RoutePage()
class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final myBloc = getIt.get<NotificationManagerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: const BaseAppBar(
          title: 'Danh sách thông báo',
        ),
        body: Container(
          height: heightDevice(context),
          width: heightDevice(context),
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp24,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              myBloc.notificationsILC.onRefresh();
            },
            child: SingleChildScrollView(
              controller: myBloc.scrollController,
              child: Column(
                children: [
                  Row(
                    children: [
                      BlocBuilder<NotificationManagerCubit,
                          NotificationManagerState>(
                        builder: (
                          BuildContext context,
                          NotificationManagerState state,
                        ) {
                          return Text(
                            '${state.unReadNotificationCount} thông báo mới',
                            style: p5.copyWith(color: mainColor),
                          );
                        },
                      ),
                      const Spacer(),
                      Text('Bộ lọc', style: h6.copyWith(color: blackColor)),
                      gapWidth(sp8),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sp12),
                              ),
                            ),
                            context: context,
                            builder: (context) =>
                                BtsFilterNotification(myBloc: myBloc),
                          );
                        },
                        child: SizedBox(
                          child: IcSvg.asset('/noti/filter.svg'),
                        ),
                      ),
                    ],
                  ),
                  gapHeight(sp16),
                  InfiniteList(
                    shrinkWrap: true,
                    getData: (page) async {
                      return myBloc.getNotifications(page, type: 'system');
                    },
                    itemBuilder: (context, item, index) {
                      return InkWell(
                        onTap: () {
                          context.router.push(
                            NotificationDetailRoute(id: item.id!),
                          );
                        },
                        child: _buildRowItem(item),
                      );
                    },
                    scrollController: myBloc.scrollController,
                    infiniteListController: myBloc.notificationsILC,
                    circularProgressIndicator: const BaseLoading(),
                    noItemFoundWidget: const EmptyContainer(),
                    heightGap: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem(NotificationEntity item) {
    return InkWell(
      onTap: () {
        if (item.type == TypeNoti.system) {
          return;
        }
        // if (item.canAccess) {
        context.router.push(
          OrderHubActionV2Route(notiId: item.id ?? 0, dataHub: item.data ?? {}),
        );
        // }
      },
      child: Container(
        // padding: const EdgeInsets.all(sp16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor_2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Icon(
                item.type?.icon.icon,
                color: item.isRead ? greyColor : mainColor,
                size: sp20,
              ),
            ),
            gapWidth(sp16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: h6.copyWith(
                      color: item.isRead ? greyColor : blackColor,
                    ),
                  ),
                  gapHeight(sp8),
                  Text(
                    item.content ?? '',
                    style: p6.copyWith(
                        color: item.isRead ? greyColor : blackColor),
                    maxLines: 3,
                  ),
                  Visibility(
                    visible: !item.canAccess,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: yellow_1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Đơn thuốc đã được nhận',
                        style: p9.copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                  Text(
                    '${timeBetween(startTime: item.createdAt!, endTime: DateTime.now())} trước',
                    style: p9.copyWith(
                      color: item.isRead ? greyColor : blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
