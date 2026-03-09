import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../constants/asset_path.dart';
import '../../../models/calendar/event_model.dart';
import '../../../../router/router.gr.dart';

class ItemEvent extends StatelessWidget {
  final EventModel event;

  const ItemEvent({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    return InkWell(
      onTap: () {
        if (event.uuid != null) {
          context.pushRoute(DetailEventRoute(id: event.id ?? 0));
        }
      },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 8.radius,
          border: Border.all(
            color: ColorApp.greyE2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '#${event.code ?? ""}',
                  style: StyleApp.medium(
                    color: ColorApp.grey79,
                  ),
                ).expanded(),
                8.width,
                Text(
                  event.canceled == true
                      ? 'Đã huỷ'
                      : event.isDone == true
                          ? 'Đã diễn ra'
                          : 'Chưa diễn ra',
                  style: StyleApp.medium(
                    color: event.canceled == true
                        ? ColorApp.red
                        : event.isDone == true
                            ? ColorApp.main
                            : ColorApp.yellowD2,
                  ),
                ),
              ],
            ),
            sp16.height,
            Text(
              event.meetingAt.toDate.fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              style: StyleApp.semibold(),
            ),
            const Divider(
              height: 32,
              color: ColorApp.greyF2,
            ),
            TextRow2(
              title: 'Tên khách hàng',
              content: event.customer?.fullName ?? '',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Cơ sở',
              content: getCompanyName ?? '',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Bác sĩ',
              content: event.doctor?.fullName ?? '',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Dịch vụ',
              content: event.services
                      ?.map(
                        (e) => e.title ?? '',
                      )
                      .toList()
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '') ??
                  '',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemEvent2 extends StatelessWidget {
  final EventModel event;

  const ItemEvent2({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    StyleApp.normal(color: ColorApp.grey79);
    StyleApp.semibold();
    return InkWell(
      onTap: () {
        if (event.uuid != null) {
          context.pushRoute(DetailEventRoute(id: event.id ?? 0));
        }
      },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 8.radius,
          border: Border.all(
            color: ColorApp.greyE2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('${AssetsPath.image}/logo.png').size(
              height: 72,
              width: 72,
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.customer?.fullName ?? '',
                  style: StyleApp.semibold(),
                ),
                4.height,
                Text(
                  event.meetingAt.toDate.fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
                  style: StyleApp.normal(
                    fontSize: 12,
                    color: ColorApp.greyA7,
                  ),
                ),
                12.height,
                Text(
                  'Dịch vụ: ${event.services?.map(
                        (e) => e.title ?? '',
                      ).toList().toString().replaceAll('[', '').replaceAll(']', '') ?? ''}',
                  style: StyleApp.normal(
                    fontSize: 12,
                    color: ColorApp.greyA7,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
