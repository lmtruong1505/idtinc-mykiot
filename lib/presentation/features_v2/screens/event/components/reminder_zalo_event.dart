import 'package:flutter/material.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/icon_btn.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../shared/components/widgets/zalo_oa_resend.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../models/event/reminder_event_model.dart';
import 'bts/bts_reminder_event.dart';

Widget ReminderZalo(
  ReminderEventModel item, {
  Function()? resend,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.isError != true)
            ZaloIcon(
              Assets.svgZalo,
            ),
          if (item.isError == true) ...[
            IconBtn(
              onTap: resend,
              icon: FaIcon(
                iconCode: 'f363',
                type: FaIconType.solid,
                size: 12,
                color: AppColors.white,
              ),
              padding: 2.pading,
              size: const Size(24, 24),
              backgroundColor: AppColors.button_neutral_solid_backgroundDefault,
            ),
            12.width,
            const Spacer(),
            FaIcon(
              iconCode: 'f057',
              type: FaIconType.solid,
              size: 12,
              color: AppColors.ultility_negative_60,
            ),
          ],
          if (item.isSend == true) ...[
            const Spacer(),
            FaIcon(
              iconCode: 'f058',
              type: FaIconType.solid,
              size: 12,
              color: AppColors.brand,
            ),
          ],
        ],
      ),
      6.height,
      Text(
        'Trước',
        overflow: TextOverflow.ellipsis,
        style: AppStyle.bodyBsMedium.copyWith(
          color: AppColors.text_tertiary,
        ),
      ).padding(4.padingHor),
      4.height,
      Text(
        '${item.quantity} ${TimeReminderEnum.fromCode(item.unit ?? "").title}',
        overflow: TextOverflow.ellipsis,
        style: AppStyle.headingMd.copyWith(
          color: item.isSend == true || item.isError == true
              ? null
              : AppColors.text_tertiary,
        ),
      ).padding(4.padingHor),
    ],
  ).container(
    radius: 12,
    padding: 8.pading,
    border: Border.all(
      color: item.isError == true
          ? AppColors.ultility_negative_60
          : AppColors.border_tertiary,
    ),
  );
}
