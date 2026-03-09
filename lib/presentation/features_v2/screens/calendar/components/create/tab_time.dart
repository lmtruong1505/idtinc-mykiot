import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../constants/spacing.dart';
import '../../../../blocs/calendar/create_event_bloc.dart';
import '../../../../blocs/state/init_state.dart';

class TabDateTimeEvent extends StatefulWidget {
  final CreateEventBloc bloc;
  const TabDateTimeEvent({required this.bloc});

  @override
  State<TabDateTimeEvent> createState() => _TabDateTimeEventState();
}

class _TabDateTimeEventState extends State<TabDateTimeEvent> with AutomaticKeepAliveClientMixin {
  final now = DateTime.now();

  final timeText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CreateEventBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chọn thời gian cho cuộc hẹn',
                style: StyleApp.medium(),
              ),
              sp16.height,
              AppInputV2(
                controller: timeText,
                hintText: 'Chọn thời gian',
                borderColor: ColorApp.greyE2,
                backgroundColor: ColorApp.white,
                radius: Dimensions.sp8,
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ColorApp.black,
                ),
                readOnly: true,
                onTap: () {
                  
                  showTimePicker(
                    context: context,
                    initialTime: widget.bloc.time ?? TimeOfDay.now(),
                  ).then(
                    (value) {
                      if (value != null) {
                        timeText.text = value.format(context);
                        widget.bloc.time = value;
                      }else{
                        widget.bloc.time = null;
                      }
                    },
                  );
                },
              ),
              sp16.height,
              _buildDateTime(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateTime() {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      padding: 8.padingTop,
      child: CalendarDatePicker2(
        onValueChanged: (dates) {
          widget.bloc.date = dates.first;
        },
        value: [widget.bloc.date],
        config: CalendarDatePicker2Config(
          weekdayLabels: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
          weekdayLabelTextStyle: StyleApp.medium(
            color: ColorApp.grey79,
          ),
          calendarType: CalendarDatePicker2Type.single,
          //disableMonthPicker: true,
          dayBorderRadius: Dimensions.sp4.radius,
          lastDate: now.copyWith(month: now.month + 12),
          firstDate: now,
          dayTextStyle: StyleApp.medium(),
          selectedDayHighlightColor: ColorApp.main,
          selectedRangeHighlightColor: ColorApp.main.withOpacity(0.15),
          selectedRangeDayTextStyle: StyleApp.medium(color: ColorApp.main),
          modePickerTextHandler: ({isMonthPicker, required monthDate}) =>
              'Tháng ${monthDate.month} năm ${monthDate.year}',
          calendarViewMode: DatePickerMode.day,
          centerAlignModePicker: true,
          controlsTextStyle: StyleApp.normal(fontSize: 16),
          firstDayOfWeek: 1,
          nextMonthIcon: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: ColorApp.greyE2),
              borderRadius: Dimensions.sp4.radius,
            ),
            child: const Icon(
              Icons.east_rounded,
              size: 15,
              color: ColorApp.black,
            ),
          ),
          lastMonthIcon: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: ColorApp.greyE2),
              borderRadius: Dimensions.sp4.radius,
            ),
            child: const Icon(
              Icons.west_rounded,
              size: 15,
              color: ColorApp.black,
            ),
          ),
          allowSameValueSelection: true,
          customModePickerIcon: const SizedBox(),
          controlsHeight: 50,
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
