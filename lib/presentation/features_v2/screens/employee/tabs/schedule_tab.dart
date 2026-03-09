import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/search_filter.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../event/components/bts/bts_filter_calendar.dart';
import '../../../../features/branch/page_v2/companents/items/item_calendar_time.dart';
class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  @override
  Widget build(BuildContext context) {
    // return EmptySearch(
    //   text: 'Chưa có lịch hẹn',
    //   svgAsset: Assets.svgCalendarTime,
    // );
    return SingleChildScrollView(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          16.height,
          ListView.separated(
            itemBuilder: (context, index) => const ItemCalendarTimeBranch(),
            separatorBuilder: (context, index) => 16.height,
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchFilterCustom(
          onChange: (p0) {},
          onTap: () {
            context.bottomSheet(const BtsFilterEvent());
          },
          hintText: 'Tìm tên, số điện thoại, mã',
        ),
        24.height,
        Text(
          'Tất cả',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        8.height,
        const Divider(
          height: 0,
          color: AppColors.border_tertiary,
        ),
      ],
    );
  }
}
