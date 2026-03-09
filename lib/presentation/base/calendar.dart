import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../features_v2/screens/order/components/bts/bts_filter_order.dart';

class _Const {
  static const days = <String>['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
}

class CalendarPicker extends StatefulWidget {
  final List<DateTime?> selectedDate;
  final Function(List<DateTime?>)? onConfirm;
  final DateRangePickerSelectionMode selectionMode;

  const CalendarPicker({
    super.key,
    this.selectedDate = const [],
    this.onConfirm,
    this.selectionMode = DateRangePickerSelectionMode.range,
  });

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  final DateRangePickerController _controller = DateRangePickerController();
  String headerString = '';
  String _range = '';
  List<DateTime?> selectedDate = [null, null];

  @override
  void initState() {
    initializeDateFormatting('vi_VN', null);
    super.initState();
  }

  void _onViewChanged(DateRangePickerViewChangedArgs args) {
    final DateTime visibleStartDate = args.visibleDateRange.startDate!;
    final DateTime visibleEndDate = args.visibleDateRange.endDate!;
    final int totalVisibleDays =
        (visibleStartDate.difference(visibleEndDate).inDays);
    final DateTime midDate =
        visibleEndDate.add(Duration(days: totalVisibleDays ~/ 2));
    headerString = _controller.view == DateRangePickerView.month
        ? DateFormat.yMMMM('vi_VN').format(midDate).toString()
        : "Năm ${DateFormat.y('vi_VN').format(midDate).toString()}";
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double cellWidth = width / 9;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(top: sp4),
          color: whiteColor,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _controller.view = DateRangePickerView.year;
                      setState(() {});
                    },
                    child: Text(
                      headerString,
                      textAlign: TextAlign.center,
                      style: h3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _controller.backward!();
                    },
                    child: ArrowFaIcon.left,
                  ),
                  16.width,
                  GestureDetector(
                    onTap: () {
                      _controller.forward!();
                    },
                    child: ArrowFaIcon.right,
                  ),
                ],
              ).padding(const EdgeInsets.symmetric(horizontal: sp8)),
              12.height,
              _controller.view == DateRangePickerView.month
                  ? SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          _Const.days.length,
                          (index) => SizedBox(
                            width: cellWidth,
                            child: Center(
                              child: Text(
                                _Const.days[index],
                                style: h5.copyWith(
                                  color: bg_1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        SfDateRangePicker(
          controller: _controller,
          monthFormat: 'MM',
          navigationMode: DateRangePickerNavigationMode.snap,
          navigationDirection: DateRangePickerNavigationDirection.horizontal,
          headerHeight: 0,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            viewHeaderHeight: 0,
            showTrailingAndLeadingDates: true,
          ),
          onSelectionChanged: _onSelectionChanged,
          onViewChanged: _onViewChanged,
          onSubmit: (value) {},
          rangeTextStyle: p5.copyWith(color: greyTextColor),
          selectionMode: widget.selectionMode,
          backgroundColor: whiteColor,
          todayHighlightColor: mainColor,
          startRangeSelectionColor: mainColor,
          endRangeSelectionColor: mainColor,
          selectionColor: mainColor,
          rangeSelectionColor: blue_1.withOpacity(0.2),
          yearCellStyle: DateRangePickerYearCellStyle(
            textStyle: p5.copyWith(color: blackColor),
            todayTextStyle: p5.copyWith(color: mainColor),
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: p5.copyWith(color: blackColor),
            todayTextStyle: p5.copyWith(color: mainColor),
            trailingDatesTextStyle: p5.copyWith(color: greyColor),
            leadingDatesTextStyle: p5.copyWith(color: greyColor),
          ),
          selectionTextStyle: p5.copyWith(color: whiteColor),
          initialSelectedRange: _initialDate(),
          cellBuilder: (context, cellDetails) {
            if (_controller.view == DateRangePickerView.month) {
              return Container(
                width: cellDetails.bounds.width,
                height: cellDetails.bounds.height,
                alignment: Alignment.center,
                child: Text(
                  cellDetails.date.day.toString(),
                  style: p5,
                ),
              );
            } else if (_controller.view == DateRangePickerView.year) {
              return Container(
                width: cellDetails.bounds.width,
                height: cellDetails.bounds.height,
                alignment: Alignment.center,
                child: Text(cellDetails.date.month.toString()),
              );
            } else if (_controller.view == DateRangePickerView.decade) {
              return Container(
                width: cellDetails.bounds.width,
                height: cellDetails.bounds.height,
                alignment: Alignment.center,
                child: Text(cellDetails.date.year.toString()),
              );
            } else {
              final int yearValue = (cellDetails.date.year ~/ 10) * 10;
              return Container(
                width: cellDetails.bounds.width,
                height: cellDetails.bounds.height,
                alignment: Alignment.center,
                child: Text(
                  '$yearValue - ${yearValue + 9}',
                ),
              );
            }
          },
          selectionShape: DateRangePickerSelectionShape.circle,
        ),
        const Divider(),
        ...TimeCreated.values
            .where((e) => e != TimeCreated.all && e != TimeCreated.option)
            .map((e) {
          return InkWell(
            onTap: () {
              widget.onConfirm?.call(e.rangeDateTime ?? []);
              Navigator.of(context).pop(_range);
            },
            child: Row(
              children: [
                e.icon ?? 0.height,
                8.width,
                Text(
                  e.title,
                  style: p5.copyWith(color: blackColor),
                ),
                const Spacer(),
                Text(
                  '${e.rangeDateTime?[0].fomatDefaulft} - ${e.rangeDateTime?[1].fomatDefaulft}',
                  style: p7.copyWith(color: greyTextColor),
                ),
              ],
            ).padding(const EdgeInsets.all(sp8)),
          );
        }),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          color: whiteColor,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // if (widget.selectedDate[0] != null &&
                //     widget.selectedDate[1] == null) {
                //   _range =
                //       "${widget.selectedDate[0]}${_range != "" ? " - $_range" : ""}";
                // }
                // if (_range == '') {
                //   _range = DateFormat('dd-MM-yyyy').format(DateTime.now());
                // }
                Navigator.of(context).pop(_range);
                widget.onConfirm?.call(selectedDate);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(sp16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: sp8,
                  horizontal: sp12,
                ),
                child: Text(
                  'Xác nhận',
                  style: p5.copyWith(color: whiteColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        if (args.value.endDate == null) {
          selectedDate[0] = args.value.startDate;
          // _range = DateFormat('dd-MM-yyyy').format(args.value.startDate);
          return;
        }
        selectedDate[0] = args.value.startDate;
        selectedDate[1] = args.value.endDate ?? args.value.startDate;
        // _range = '${DateFormat('dd-MM-yyyy').format(args.value.startDate)} -'
        //     ' ${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else {
        selectedDate[0] = args.value;
        // _range = DateFormat('dd-MM-yyyy').format(args.value);
      }
    });
  }

  PickerDateRange _initialDate() {
    final startDate = widget.selectedDate[0] != null
        ? widget.selectedDate[0]!
        : DateTime.now();
    final endDate =
        widget.selectedDate[1] != null ? widget.selectedDate[1]! : startDate;
    return PickerDateRange(startDate, endDate);
  }
}
