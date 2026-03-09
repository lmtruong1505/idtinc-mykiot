import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../shared/style_app/init_style.dart';
import '../../features_v2/blocs/date_time/date_time_bloc.dart';
import '../../features_v2/blocs/date_time/param_date.dart';
import '../../features_v2/blocs/state/init_state.dart';
import 'grid_view_custom.dart';

enum TypeDate {
  year,
  month,
  day,
}

// ignore: must_be_immutable
class DateTimeWidget extends StatefulWidget {
  ParamDate? param;
  TypeDate type;
  DateTime? lastDate;
  DateTimeWidget({
    this.param,
    this.lastDate,
    this.type = TypeDate.day,
  });
  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  final bloc = DateTimeBloc();

  List<DateTime?> dialogCalendarPickerValue = [null, null];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.param != null) {
      final option =
          widget.type == TypeDate.year ? bloc.optionYear : bloc.optionDateTime;
      final data = option
          .where((element) => element == widget.param!.dateRange)
          .toList();
      if (data.isNotEmpty) {
        bloc.chooseBtn(
          data.first,
          dateStart: widget.param!.startDate,
          dateEnd: widget.param!.endDate,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: Dimensions.sp16.pading,
      shape: RoundedRectangleBorder(
        borderRadius: Dimensions.sp8.radius,
      ),
      child: BlocConsumer<DateTimeBloc, CubitState<ParamDate>>(
        bloc: bloc,
        listener: (context, state) {
          if (state.status == BlocStatus.success &&
              state.data?.dateRange != DateRangeEnum.option) {
            context.pop(
              result: state.data,
            );
          }
        },
        builder: (context, state) {
          final bool isOption = state.status == BlocStatus.success &&
              state.data?.dateRange == DateRangeEnum.option;

          return Container(
            padding: !isOption ? Dimensions.sp16.pading : null,
            width: context.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isOption) ...[
                  Text(
                    'Lọc thời gian',
                    style: StyleApp.medium(),
                  ),
                  Dimensions.sp16.height,
                  _optionDateTime(),
                ],
                if (isOption) ...[
                  _toolBar(state),
                  if (widget.type == TypeDate.day) _datetimeChoose(state),
                  if (widget.type == TypeDate.year) _yearChoose(state),
                  if (widget.type == TypeDate.day)
                    Padding(
                      padding: Dimensions.sp16.padingHor,
                      child: Row(
                        children: [
                          Expanded(
                            child: ExtraButton(
                              title: 'Huỷ bỏ',
                              event: () {
                                bloc.back();
                              },
                              largeButton: true,
                              borderColor: ColorApp.greyE2,
                              icon: null,
                            ),
                          ),
                          Dimensions.sp16.width,
                          Expanded(
                            child: MainButton(
                              title: 'Áp dụng',
                              event: () {
                                state.data?.startDate =
                                    dialogCalendarPickerValue.first;
                                state.data?.endDate =
                                    dialogCalendarPickerValue.last;
                                print(state.data?.toJson());
                                if (state.data?.startDate ==
                                    state.data?.endDate) {
                                  state.data?.endDate =
                                      state.data?.endDate?.add(
                                    const Duration(
                                      hours: 23,
                                      minutes: 59,
                                      seconds: 59,
                                    ),
                                  );
                                }
                                context.pop(
                                  result: state.data,
                                );
                              },
                              largeButton: true,
                              icon: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Dimensions.sp16.height,
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _yearChoose(CubitState<ParamDate> state) {
    final DateTime now = DateTime.now();
    const int length = 100;

    return Container(
      height: context.height * 0.3,
      padding: Dimensions.sp16.pading,
      child: GridViewCustom(
        padding: EdgeInsets.zero,
        showFull: true,
        shrinkWrap: true,
        mainAxisExtent: 37,
        maxWight: 60,
        crossAxisSpacing: Dimensions.sp8,
        mainAxisSpacing: Dimensions.sp8,
        itemBuilder: (context, index) {
          final bool isCheck =
              (now.year - index) == bloc.state.data?.startDate?.year;
          return GestureDetector(
            onTap: () {
              state.data?.startDate = now.copyWith(year: now.year - index);
              state.data?.endDate = now.copyWith(year: now.year - index);
              print(state.data?.toJson());

              context.pop(
                result: state.data,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: isCheck ? ColorApp.main : ColorApp.white,
                borderRadius: Dimensions.sp8.radius,
                border: Border.all(
                  color: isCheck ? ColorApp.main : ColorApp.greyF2,
                  width: 0.5,
                ),
              ),
              alignment: Alignment.center,
              padding: Dimensions.sp16.padingHor,
              child: Text(
                '${now.year - index}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: StyleApp.medium(
                  color: isCheck ? ColorApp.white : ColorApp.black,
                ),
              ),
            ),
          );
        },
        itemCount: length,
      ),
    );
  }

  Widget _datetimeChoose(CubitState<ParamDate> state) {
    dialogCalendarPickerValue = [
      state.data?.startDate,
      state.data?.endDate,
    ];

    return CalendarDatePicker2(
      onValueChanged: (dates) {
        dialogCalendarPickerValue = dates;
      },
      value: dialogCalendarPickerValue,
      config: CalendarDatePicker2Config(
        weekdayLabels: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
        weekdayLabelTextStyle: StyleApp.medium(
          color: ColorApp.grey79,
        ),
        calendarType: CalendarDatePicker2Type.range,
        //disableMonthPicker: true,
        dayBorderRadius: Dimensions.sp4.radius,
        lastDate: widget.lastDate ?? DateTime.now(),
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
    );
  }

  GridViewCustom _optionDateTime() {
    final option =
        widget.type == TypeDate.year ? bloc.optionYear : bloc.optionDateTime;
    return GridViewCustom(
      padding: EdgeInsets.zero,
      showFull: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisExtent: 37,
      crossAxisSpacing: Dimensions.sp8,
      crossAxisCount: 2,
      mainAxisSpacing: Dimensions.sp8,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          bloc.chooseBtn(option[index]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorApp.greyF2,
            borderRadius: Dimensions.sp8.radius,
            border: option[index] == bloc.state.data?.dateRange
                ? Border.all(color: ColorApp.main)
                : null,
          ),
          alignment: Alignment.centerLeft,
          padding: Dimensions.sp16.padingHor,
          child: Text(
            option[index].toName,
            textAlign: TextAlign.left,
            style: StyleApp.medium(
              color: option[index] == bloc.state.data?.dateRange
                  ? ColorApp.main
                  : ColorApp.grey79,
            ),
          ),
        ),
      ),
      itemCount: option.length,
    );
  }

  Container _toolBar(CubitState<ParamDate> state) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: Dimensions.sp8.radiusTop,
        color: ColorApp.main,
      ),
      child: NavigationToolbar(
        leading: Padding(
          padding: Dimensions.sp16.padingLeft,
          child: BackButton(
            color: Colors.white,
            onPressed: bloc.back,
          ),
        ),
        centerMiddle: false,
        middleSpacing: 0,
        middle: Text(
          state.msg,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: StyleApp.normal(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: Dimensions.sp16.width,
      ),
    );
  }
}
