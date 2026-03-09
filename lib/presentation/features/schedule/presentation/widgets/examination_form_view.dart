import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_calendar_time.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../gen/assets.dart';
import '../../../../../shared/components/button/label_button.dart';
import '../../../../../shared/components/button/main_button.dart';
import '../../../../../shared/components/widgets/zalo_oa_resend.dart';
import '../../../../base/button.dart';
import '../../data/models/appointment_schedule_model.dart';

class ExaminationFormView extends StatelessWidget {
  const ExaminationFormView({
    super.key,
    required this.data,
    this.cancelCallback,
    this.confirmCallback,
    this.oaCallback,
  });

  final AppointmentScheduleModel data;
  final Function()? cancelCallback;
  final Function()? confirmCallback;
  final Function()? oaCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(sp16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _statusView,
                  sp16.height,
                  _timeView,
                  sp16.height,
                  _infoBasicView(context),
                  sp16.height,
                  _zaloOaView,
                  sp16.height,
                  _noteView,
                ],
              ),
            ),
          ),
        ),
        _navBar,
      ],
    );
  }

  Widget get _statusView {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: sp8,
        horizontal: sp12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(color: AppColors.border_primary),
        color: AppColors.bg_disable_subtle,
        boxShadow: const [
          BoxShadow(
            color: black5o,
            offset: Offset(0, 1),
            blurRadius: sp4,
            spreadRadius: sp4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.bg_disable,
            radius: 14,
            child: FaIcon(
              iconCode: 'f02f',
              color: AppColors.icon_iconSecondary,
              size: sp16,
            ),
          ),
          sp8.width,
          Text(
            '#',
            style: s14w400.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          Text(
            data.code ?? '',
            style: s16w700.copyWith(
              color: AppColors.blue60,
            ),
          ),
          const Spacer(),
          const SizedBox(
            height: sp20,
            child: VerticalDivider(
              width: sp4,
              color: AppColors.text_tertiary,
            ),
          ),
          const Spacer(),
          data.statusView,
        ],
      ),
    );
  }

  Widget get _timeView {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hẹn lúc',
                style: s10w400.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              sp4.height,
              Text(
                data.meetingAt.fomatCustom(fomat: 'HH:mm'),
                style: s16w700.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp16),
            color: AppColors.bg_brandPrimary_variant2,
          ),
          child: Column(
            children: [
              Text(
                'Lượt khám số',
                style: s12w500.copyWith(
                  color: AppColors.text_brand_primary_variant2,
                ),
              ),
              sp4.height,
              Text(
                data.orderInDay.toString(),
                style: s30w700.copyWith(
                  color: AppColors.text_brand_primary_variant2,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Trong ngày',
                style: s10w400.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              sp4.height,
              Text(
                data.meetingAt.fomatCustom(fomat: 'dd/MM/yyyy'),
                style: s12w500.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBasicView(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              iconCode: 'f0c0',
              size: sp12,
              type: FaIconType.solid,
            ),
            sp4.width,
            Text(
              'Khách hàng',
              style: s12w400.copyWith(color: AppColors.text_tertiary),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (data.customer?.id == null) return;
                    context.router.push(DetailCustomerV2Route(id: data.customer!.id!));
                  },
                  child: Text(
                    data.customer?.fullName ?? '',
                    style: s14w500.copyWith(
                      color: AppColors.blue50,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  '${data.customer?.gender ?? '-'}/${data.customer?.birthday ?? '-'}',
                  style: s14w400.copyWith(color: AppColors.text_tertiary),
                ),
                Text(
                  data.customer?.phone ?? '-',
                  style: s14w400.copyWith(color: AppColors.text_tertiary),
                ),
              ],
            ),
          ],
        ),
        sp4.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              iconCode: 'f0c0',
              size: sp12,
              type: FaIconType.solid,
            ),
            sp4.width,
            Text(
              'Bệnh nhân',
              style: s12w400.copyWith(color: AppColors.text_tertiary),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (data.patient?.id == null) return;
                    context.router.push(DetailCustomerV2Route(id: data.patient!.id!));
                  },
                  child: Text(
                    data.patient?.fullName ?? '',
                    style: s14w500.copyWith(
                      color: AppColors.blue50,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  '${data.patient?.gender ?? '-'}/${data.patient?.birthday ?? '-'}',
                  style: s14w400.copyWith(color: AppColors.text_tertiary),
                ),
                Text(
                  data.patient?.phone ?? '-',
                  style: s14w400.copyWith(color: AppColors.text_tertiary),
                ),
              ],
            ),
          ],
        ),
        sp8.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              iconCode: 'f54f',
              size: sp12,
              type: FaIconType.solid,
            ),
            sp4.width,
            Text(
              'Cơ sở',
              style: s12w400.copyWith(color: AppColors.text_tertiary),
            ),
            const Spacer(),
            Text(
              data.workspace?.workspaceName ?? '',
              style: s14w600.copyWith(color: AppColors.text_secondary),
            ),
          ],
        ),
        sp8.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              iconCode: 'f017',
              size: sp12,
              type: FaIconType.solid,
            ),
            sp4.width,
            Text(
              'Tạo lúc',
              style: s12w400.copyWith(color: AppColors.text_tertiary),
            ),
            const Spacer(),
            Text(
              data.createdAt.fomatCustom(fomat: 'hh:mm dd/MM/yyyy'),
              style: s12w500.copyWith(color: AppColors.text_tertiary),
            ),
          ],
        ),
        sp8.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              iconCode: 'f017',
              size: sp12,
              type: FaIconType.solid,
            ),
            sp4.width,
            Text(
              'Cập nhật lúc',
              style: s12w400.copyWith(color: AppColors.text_tertiary),
            ),
            const Spacer(),
            Text(
              data.updatedAt.fomatCustom(fomat: 'hh:mm dd/MM/yyyy'),
              style: s12w500.copyWith(color: AppColors.text_tertiary),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _zaloOaView {
    return Row(
      children: [
        ZaloIcon(
          Assets.svgZalo,
        ),
        4.width,
        Text(
          'Gửi lịch hẹn đến khách hàng',
          style: AppStyle.bodyMdSemiBold.copyWith(
            color: AppColors.text_tertiary,
            fontSize: 12,
          ),
        ).expanded(),
        12.width,
        FaIcon(
          iconCode: 'f058',
          color: AppColors.fg_positive,
          type: FaIconType.solid,
        ),
        12.width,
        LabelButton(
          label: 'Gửi lại',
          backgroundColor: AppColors.button_neutral_alpha_backgroundDefault,
          labelStyle: AppStyle.bodyBsMedium,
          onPressed: () => oaCallback?.call(),
        ).size(height: 32),
      ],
    ).container(
      bgColor: AppColors.bg_primary,
      padding: 8.pading,
      radius: 8,
      border: Border.all(color: AppColors.border_tertiary),
    );
  }

  Widget get _noteView {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ghi chú',
          style: s14w400.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        sp8.height,
        Text(
          data.note ?? '---',
          style: s14w500.copyWith(
            color: AppColors.text_primary,
          ),
        ),
      ],
    );
  }

  Widget get _navBar {
    final titleButton = switch (data.enumStatus) {
      EnumCalendarTime.all => '',
      EnumCalendarTime.booked => 'Xác nhận',
      EnumCalendarTime.comfirmed => 'Bệnh nhân đã đến',
      EnumCalendarTime.arrived => 'Thực hiện',
      EnumCalendarTime.consulting => 'Hoàn thành',
      EnumCalendarTime.completed => '',
      EnumCalendarTime.canceled => 'Xác nhận lại',
    };
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(
        bottom: sp32,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: black5o,
            offset: Offset(0, -1),
            spreadRadius: sp4,
            blurRadius: sp4,
          ),
        ],
      ),
      child: Row(
        children: [
          if (data.enumStatus != EnumCalendarTime.canceled &&
              data.enumStatus != EnumCalendarTime.consulting &&
              data.enumStatus != EnumCalendarTime.completed)
            Expanded(
              child: SupportButton(
                largeButton: true,
                radius: sp32,
                backgroundColor: AppColors.red20,
                color: AppColors.red60,
                title: 'Hủy',
                event: () => cancelCallback?.call(),
              ),
            ),
          if (data.enumStatus != EnumCalendarTime.canceled &&
              data.enumStatus != EnumCalendarTime.completed)
            sp12.width,
          if (data.enumStatus != EnumCalendarTime.completed)
            Expanded(
              child: MainButton(
                title: titleButton,
                radius: sp32,
                event: () => confirmCallback?.call(),
              ),
            ),
        ],
      ),
    );
  }
}
