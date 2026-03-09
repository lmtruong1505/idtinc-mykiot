import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_calendar_time.dart';
import 'package:pharmago/presentation/features_v2/screens/event/components/items/base_event.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../config/role/check_role_per.dart';
import '../../../../../config/role/permission/index.dart';
import '../../../../../di/di.dart';
import '../../../../blocs/event/list_event_bloc.dart';
import '../../../../models/event/event_v2_mode.dart';
import 'item_service_event.dart';

class ItemEventCalendar extends StatelessWidget {
  final EventV2Model item;
  final bool isEmployee;
  const ItemEventCalendar({
    super.key,
    required this.item,
    this.isEmployee = false,
  });

  bool get isDone => item.status == EnumCalendarTime.completed.code;
  bool get isCancel => item.status == EnumCalendarTime.canceled.code;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: checkPermission(PerAppointmentEnum.DETAIL.code)
          ? () {
              context
                  .pushRoute(MedicalScheduleDetailRoute(id: item.id!))
                  .then((value) {
                    getIt<ListEventV2Bloc>().getList();
                  });
            }
          : null,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfo(),
              8.height,
              DividerCustom().padding(12.padingHor),
              8.height,
              ...List.generate(
                item.services.validator.length,
                (index) => ItemServiceEvent(
                  title: item.services![index].title ?? '',
                  color: isDone || isCancel ? AppColors.text_disable : null,
                ),
              ),
              8.height,
              Row(
                children: [
                  _buildUser().expanded(),
                  if (isEmployee)
                    Text(
                      item.company?.name ?? '',
                      textAlign: TextAlign.right,
                      style: AppStyle.bodySmRegular.copyWith(
                        color: AppColors.text_quaternary,
                      ),
                    ).padding(12.padingHor).expanded(),
                ],
              ),
            ],
          ).container(
            padding: 12.padingVer,
            radius: 12,
            border: Border.all(color: AppColors.border_tertiary),
          ),
          if (isDone || isCancel)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: 12.radius,
                  color: AppColors.ultility_gray_60.withOpacity(0.1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUser() {
    return Row(
      children: [
        FaIcon(
          iconCode: 'f0c0',
          size: 10,
          color: AppColors.fg_quaternary,
        ),
        5.width,
        Text(
          item.userCreated?.fullName ?? '',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodySmRegular.copyWith(
            color: AppColors.text_quaternary,
          ),
        ).expanded(),
      ],
    ).padding(12.padingHor);
  }

  Widget _buildInfo() {
    return BaseEvent(
      code: item.code ?? '',
      status: item.status ?? '',
      date: item.meetingAt ?? item.createdAt,
      patient: item.customer?.fullName ?? '',
      orderInDay: item.orderInDay ?? 1,
    ).padding(12.padingHor);
  }
}
