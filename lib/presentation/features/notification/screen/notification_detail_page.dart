import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/typography.dart';

import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../cubit/notification_detail_cubit/notification_detail_cubit.dart';
import '../cubit/notification_detail_cubit/notification_detail_state.dart';
import '../domain/entities/notification_entity.dart';

@RoutePage()
class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({required this.id, super.key});

  final int id;

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final myBloc = getIt.get<NotificationDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: Scaffold(
        appBar: const BaseAppBar(
          title: 'Chi tiết thông báo',
        ),
        backgroundColor: bg_6,
        body: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
          builder: (BuildContext context, NotificationDetailState state) {
            if (state.isLoading) {
              return const Center(
                child: BaseLoading(),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: sp16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: sp16,
                horizontal: sp16,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text(
                        'Thông báo',
                        style: p9,
                      ),
                      subtitle: Text(
                        state.notification?.title ?? '',
                        style: h6.copyWith(color: blackColor),
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(sp12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor.withOpacity(0.1),
                        ),
                        child: Icon(
                          state.notification?.type?.icon.icon,
                          color: mainColor,
                          size: sp20,
                        ),
                      ),
                    ),
                    gapHeight(sp8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: sp16,
                        horizontal: sp16,
                      ),
                      decoration: BoxDecoration(
                        color: bg_8,
                        borderRadius: BorderRadius.circular(sp16),
                      ),
                      child: Text(
                        state.notification?.content ?? '',
                        style: h6,
                      ),
                    ),
                    gapHeight(sp8),
                    const Divider(
                      color: bg_6,
                    ),
                    gapHeight(sp8),
                    switch (state.notification?.type) {
                      TypeNoti.service => _buildService(context, state),
                      TypeNoti.appointment => _buildAppointment(context, state),
                      _ => Container(),
                    },
                    const SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Xem chi tiết đơn hàng',
                      ),
                    ),
                    gapHeight(sp16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildService(BuildContext context, NotificationDetailState state) {
    return Column(
      children: [
        const RowItem(title: 'Cơ sở', content: 'Vĩnh Phúc'),
        gapHeight(sp16),
        const RowItem(title: 'Mã đơn', content: '#DH0001'),
        gapHeight(sp16),
      ],
    );
  }

  Widget _buildAppointment(
    BuildContext context,
    NotificationDetailState state,
  ) {
    return Column(
      children: [
        const RowItem(title: 'Tên khách hàng', content: 'Trần Thế Anh'),
        gapHeight(sp16),
        const RowItem(title: 'Dịch vụ đã sử dụng', content: 'Dịch vụ A'),
        gapHeight(sp16),
        const RowItem(
          title: 'Ngày tạo đơn hàng có dịch vụ',
          content: '12/12/2021',
        ),
        gapHeight(sp16),
      ],
    );
  }
}
