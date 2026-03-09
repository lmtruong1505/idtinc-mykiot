import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/enum/enum_calendar_time.dart';
import 'item_chip_event.dart';

Widget BaseEvent({
  required String status,
  required String code,
  required String patient,
  DateTime? date,
  bool isDone = false,
  bool isCancel = false,
  bool isDetail = false,
  int orderInDay = 0,
}) {
  final bool isDone = status == EnumCalendarTime.completed.code;
  final bool isCancel = status == EnumCalendarTime.canceled.code;
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ItemChipEvent(
                status: status,
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              text: '#',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_disable,
              ),
              children: [
                TextSpan(
                  text: code,
                  style: AppStyle.headingMd.copyWith(
                    color: isDone || isCancel
                        ? AppColors.text_disable
                        : AppColors.ultility_blue,
                    decoration: isCancel ? TextDecoration.lineThrough : null,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).expanded(),
      const VerticalDivider(
        width: 32,
        thickness: 1,
        color: AppColors.border_tertiary,
      ).size(
        height: 44,
      ),
      Column(
        children: [
          Row(
            children: [
              Text(
                date.fomatCustom(fomat: 'HH:mm'),
                style: s12w600.copyWith(
                  color: AppColors.text_quaternary,
                  height: 1.5,
                ),
              ),
              const VerticalDivider(
                width: sp12,
                thickness: 1,
                color: AppColors.border_tertiary,
              ).size(
                height: sp12,
              ),
              Text(
                date.fomatDefaulft,
                overflow: TextOverflow.ellipsis,
                style: s12w400.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              const Spacer(),
              FaIcon(
                iconCode: 'e09f',
                type: FaIconType.regular,
                color: AppColors.fg_quaternary,
                size: sp20,
              ),
            ],
          ),
          sp4.height,
          Row(
            children: [
              FaIcon(
                iconCode: 'f02b',
                type: FaIconType.solid,
                color: AppColors.fg_quaternary,
                size: sp20,
              ),
              sp8.width,
              Text(
                orderInDay.toString(),
                overflow: TextOverflow.ellipsis,
                style: s18w700.copyWith(
                  color: AppColors.text_warning,
                ),
              ),
            ],
          ),
          sp4.height,
          Row(
            children: [
              FaIcon(
                iconCode: 'f830',
                type: FaIconType.solid,
                color: AppColors.fg_quaternary,
              ),
              sp8.width,
              Text(
                patient,
                overflow: TextOverflow.ellipsis,
                style: s12w500.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
        ],
      ).expanded(),
    ],
  );
}
