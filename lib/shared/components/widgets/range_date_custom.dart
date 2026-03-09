import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class RangeDateCustom extends StatefulWidget {
  final DateTime? lastDate;
  final DateTime? startDate;
  final DateTime? endDate;
  const RangeDateCustom({
    this.lastDate,
    this.endDate,
    this.startDate,
  });

  @override
  State<RangeDateCustom> createState() => _RangeDateCustomState();
}

class _RangeDateCustomState extends State<RangeDateCustom> {
  List<DateTime?> dialogCalendarPickerValue = [null, null];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dialogCalendarPickerValue = [widget.startDate, widget.endDate];
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Chọn khoảng thời gian',
      cancelText: 'Huỷ bỏ',
      confirmText: 'Xác nhận',
      onCancel: () {
        context.pop();
      },
      onConfirm: dialogCalendarPickerValue.first == null ||
              dialogCalendarPickerValue.last == null
          ? null
          : () {
              context.pop(result: dialogCalendarPickerValue);
            },
      child: _datetimeChoose(),
    );
  }

  Widget _datetimeChoose() {
    return CalendarDatePicker2(
      onValueChanged: (dates) {
        dialogCalendarPickerValue = dates;
        setState(() {});
      },
      value: dialogCalendarPickerValue,
      config: CalendarDatePicker2Config(
        weekdayLabels: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
        weekdayLabelTextStyle: AppStyle.bodyMdMedium.copyWith(
          color: AppColors.text_tertiary,
        ),
        calendarType: CalendarDatePicker2Type.range,
        //disableMonthPicker: true,
        dayBorderRadius: 50.radius,
        lastDate: widget.lastDate,
        dayTextStyle: AppStyle.bodyMdRegular,
        selectedDayHighlightColor: AppColors.brand,
        selectedRangeHighlightColor: AppColors.greenAlpha15,
        selectedRangeDayTextStyle:
            AppStyle.bodyMdMedium.copyWith(color: AppColors.brand),
        modePickerTextHandler: ({isMonthPicker, required monthDate}) =>
            'Tháng ${monthDate.month} năm ${monthDate.year}',
        calendarViewMode: DatePickerMode.day,
        centerAlignModePicker: true,
        controlsTextStyle: AppStyle.bodyMdMedium,
        firstDayOfWeek: 1,
        nextMonthIcon: _buildIcon(Icons.east_rounded),
        lastMonthIcon: _buildIcon(Icons.west_rounded),
        allowSameValueSelection: true,
        customModePickerIcon: const SizedBox(),
        controlsHeight: 50,
      ),
    );
  }

  Container _buildIcon(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border_tertiary),
        borderRadius: 4.radius,
      ),
      child: Icon(
        icon,
        size: 15,
        color: AppColors.icon_iconPrimary,
      ),
    );
  }
}
