import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/model_event_calendar.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:pharmago/shared/style_app/style_text.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import '../../../constants/spacing.dart';

@RoutePage()
class BookCalendarDetailPage extends StatelessWidget {
  final ModelEventCalendar event;
  const BookCalendarDetailPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: ColorApp.greyF5,
      appBar: const BaseAppBar(title: 'Chi tiết hẹn'),
      body: SingleChildScrollView(
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildItem(
              title: 'Khách hàng',
              content: event.name ?? '',
              subTitle: Text(
                'Xem chi tiết',
                textAlign: TextAlign.right,
                style: StyleApp.medium(color: ColorApp.blue20),
              ),
            ),
            sp16.height,
            _buildItem(
              title: 'Dịch vụ',
              content: 'Bác sĩ Hoàng Tiến Thành',
              subTitle: Text(
                'Khám răng định kì',
                textAlign: TextAlign.right,
                style: StyleApp.medium(),
              ),
            ),
            sp16.height,
            Container(
              padding: 16.pading,
              decoration: BoxDecoration(
                color: ColorApp.white,
                borderRadius: 8.radius,
              ),
              child: textRow(
                title: 'Thời gian',
                content: '${event.day?.hour ?? ""}h ${event.day?.fomatDefaulft ?? ""}',
                titleStyle: StyleApp.normal(color: ColorApp.grey79),
                contentStyle: StyleApp.semibold(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String content,
    required Widget subTitle,
  }) {
    return Container(
      padding: sp16.pading,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 8.radius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: StyleApp.normal(color: ColorApp.grey79),
                ),
              ),
              sp16.width,
              subTitle.expanded(),
            ],
          ),
          8.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                content,
                style: StyleApp.medium(fontSize: 16),
              ).expanded(),
              16.width,
              GestureDetector(
                onTap: () {
                  LaunchUrl.phone('0123456789');
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorApp.greenE6,
                    border: Border.all(color: ColorApp.main),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.phone_fill,
                    color: ColorApp.main,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
