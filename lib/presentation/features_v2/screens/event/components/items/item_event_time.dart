import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../constants/spacing.dart';
import '../../../../blocs/enum/enum_calendar_time.dart';
import '../../../../models/event/event_v2_mode.dart';
import 'item_chip_event.dart';
import 'item_service_event.dart';

class ItemEventTime extends StatelessWidget {
  final EventV2Model item;
  const ItemEventTime({super.key, required this.item});
  bool get isDone => item.status == EnumCalendarTime.completed.code;
  bool get isCancel => item.status == EnumCalendarTime.canceled.code;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushRoute(MedicalScheduleDetailRoute(id: item.id!)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ItemChipEvent(
                status: item.status ?? '',
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
                    item.orderInDay.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: s18w700.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
                ],
              ),
              // Text(
              //   item.meetingAt.fomatCustom(fomat: 'HH:mm'),
              //   style: AppStyle.bodyBsSemiBold.copyWith(
              //     color: AppColors.text_tertiary,
              //     decoration:
              //         isDone || isCancel ? TextDecoration.lineThrough : null,
              //   ),
              // ),
            ],
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  FaIcon(
                    iconCode: 'f830',
                    type: FaIconType.solid,
                    color: AppColors.fg_quaternary,
                    size: sp16,
                  ),
                  Text(
                    item.customer?.fullName ?? '',
                    style: AppStyle.bodyBsSemiBold.copyWith(
                      color: isDone || isCancel
                          ? AppColors.text_disable
                          : AppColors.text_secondary,
                      height: 1.5,
                    ),
                  ).padding(12.padingHor).expanded(),
                  FaIcon(
                    iconCode: 'e09f',
                    type: FaIconType.regular,
                    color: isDone || isCancel
                        ? AppColors.fg_disable
                        : AppColors.fg_quaternary,
                  ),
                ],
              ),
              4.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: List.generate(
                      item.services.validator.length,
                      (index) => ItemServiceEvent(
                        title: item.services![index].title ?? '',
                        color:
                            isDone || isCancel ? AppColors.text_disable : null,
                      ),
                    ),
                  ).expanded(),
                ],
              ),
            ],
          )
              .container(
                radius: 0,
                padding: 12.padingVer + 6.padingHor,
                border: const Border(
                  bottom: BorderSide(color: AppColors.border_tertiary),
                ),
              )
              .expanded(),
        ],
      ),
    );
  }
}
