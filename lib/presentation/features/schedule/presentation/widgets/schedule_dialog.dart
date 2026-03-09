import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../generated/assets.dart';
import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/button/icon_btn.dart';
import '../../../../../shared/components/toast/toast_custom.dart';
import '../../../../../shared/components/widgets/app_switch.dart';
import '../../../../../shared/components/widgets/calendar_custom.dart';
import '../../../../../shared/components/widgets/divider_custom.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';

class ScheduleDialog extends StatefulWidget {
  const ScheduleDialog({
    super.key,
    this.selectedDateTime,
    this.isUseZaloOa,
    this.scheduleNote,
    this.onConfirm,
    this.onSettingRemind,
  });

  final DateTime? selectedDateTime;
  final bool? isUseZaloOa;
  final String? scheduleNote;
  final Function(DateTime, bool, String)? onConfirm;
  final Function()? onSettingRemind;

  static void show(
    BuildContext context, {
    DateTime? selectedDateTime,
    bool? isUseZaloOa,
    String? scheduleNote,
    Function(DateTime, bool, String)? onConfirm,
    Function()? onSettingRemind,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Card(
          margin: const EdgeInsets.all(sp16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(sp12),
          ),
          child: ScheduleDialog(
            isUseZaloOa: isUseZaloOa,
            scheduleNote: scheduleNote,
            selectedDateTime: selectedDateTime,
            onConfirm: onConfirm,
            onSettingRemind: onSettingRemind,
          ),
        );
      },
    );
  }

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  DateTime selectedDateTime = DateTime.now().copyWith(minute: 00);
  bool isUseZaloOa = false;
  String scheduleNote = '';

  @override
  void initState() {
    super.initState();

    selectedDateTime = widget.selectedDateTime ?? selectedDateTime;
    isUseZaloOa = widget.isUseZaloOa ?? isUseZaloOa;
    scheduleNote = widget.scheduleNote ?? scheduleNote;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Chọn lịch hẹn',
              overflow: TextOverflow.ellipsis,
              style: AppStyle.headingLg,
            ).expanded(),
            12.width,
            IconBtn(
              onTap: () => context.pop(),
              padding: 0.pading,
              size: const Size(24, 24),
              icon: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.button_neutral_alpha_iconDefault,
              ),
            ),
          ],
        ).padding(16.pading),
        DividerCustom(),
        16.height,
        Flexible(
          child: SingleChildScrollView(
            padding: 16.padingHor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ngày',
                  style: AppStyle.headingBs,
                ),
                8.height,
                CalendarCustom(
                  isAction: false,
                  isViewBottom: false,
                  isChoose: true,
                  nowOrFuture: true,
                  selectedDateTime: selectedDateTime,
                  onChanged: (date) {
                    selectedDateTime = selectedDateTime.copyWith(
                      year: date.year,
                      month: date.month,
                      day: date.day,
                    );
                  },
                ).container(
                  radius: 20,
                  padding: 12.pading,
                  border: Border.all(color: AppColors.border_tertiary),
                ),
                16.height,
                Text(
                  'Giờ',
                  style: AppStyle.headingBs,
                ),
                8.height,
                CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: AppStyle.bodyMdMedium,
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    itemExtent: 24,
                    minuteInterval: 15,
                    initialDateTime: selectedDateTime,
                    onDateTimeChanged: (DateTime newTime) {
                      selectedDateTime = selectedDateTime.copyWith(
                        hour: newTime.hour,
                        minute: newTime.minute,
                        second: newTime.second,
                      );
                    },
                  ).size(height: 100),
                ),
                sp12.height,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: sp12,
                    vertical: sp8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gửi tin ZNS cho khách hàng',
                        style: s14w500.copyWith(color: blackColor),
                      ),
                      AppSwitch(
                        value: isUseZaloOa,
                        onChanged: (value) {
                          setState(() {
                            isUseZaloOa = !isUseZaloOa;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                sp12.height,
                InputColumn(
                  padding: const EdgeInsets.all(sp0),
                  label: 'Ghi chú lịch khám',
                  minLines: 3,
                  hintText: 'Nhập ghi chú',
                  onChanged: (value) {
                    scheduleNote = value;
                  },
                ),
                sp12.height,
              ],
            ),
          ),
        ),
        DoubleButton(
          cancelText: 'Cài đặt nhắc hẹn',
          onCancel: () {
            context.pop();
            widget.onConfirm?.call(
                selectedDateTime,
                isUseZaloOa,
                scheduleNote,
              );
            widget.onSettingRemind?.call();
          },
          onConfirm: () {
            if (selectedDateTime.isBefore(DateTime.now())) {
              ToastCustom.show(
                context,
                title: 'Cảnh báo',
                msg: 'Thời gian lịch hẹn phải lớn hơn thời gian hiện tại',
                svgIcon: Assets.svgWarningOutline,
                color: AppColors.ultility_carrot_60,
              );
            } else {
              context.pop();
              widget.onConfirm?.call(
                selectedDateTime,
                isUseZaloOa,
                scheduleNote,
              );
            }
          },
        ).size(height: 32).padding(16.pading),
      ],
    );
  }
}
