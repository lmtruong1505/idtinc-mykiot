import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/calendar_custom.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class DialogDateTime extends StatefulWidget {
  final DateTime? dateTime;
  const DialogDateTime({super.key, this.dateTime});

  @override
  State<DialogDateTime> createState() => _DialogDateTimeState();
}

class _DialogDateTimeState extends State<DialogDateTime> {
  DateTime selectedDateTime = DateTime.now().copyWith(minute: 00);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.dateTime != null) {
      selectedDateTime = widget.dateTime!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bg_primary,
      shape: RoundedRectangleBorder(
        borderRadius: 16.radius,
      ),
      insetPadding: 16.pading,
      child: Column(
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
                ],
              ),
            ),
          ),
          12.height,
          DoubleButton(
            onCancel: () => context.pop(),
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
                context.pop(result: selectedDateTime);
              }
            },
          ).size(height: 32).padding(16.pading),
        ],
      ),
    );
  }
}
