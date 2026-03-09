import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class CalendarEventCount {
  DateTime date;
  int count;
  CalendarEventCount({
    required this.date,
    required this.count,
  });
}

class CalendarCustom extends StatefulWidget {
  final List<CalendarEventCount> events;
  final bool isChoose;
  final bool isViewBottom;
  final bool isAction;
  final bool nowOrFuture;
  final Function(DateTime date)? onChanged;
  final Function(DateTime date)? onMonthChanged;
  final DateTime? selectedDateTime;
  const CalendarCustom({
    this.events = const [],
    this.isChoose = false,
    this.nowOrFuture = false,
    this.isAction = true,
    this.isViewBottom = true,
    this.onChanged,
    this.selectedDateTime,
    this.onMonthChanged,
  });

  @override
  State<CalendarCustom> createState() => _CalendarCustomState();
}

class _CalendarCustomState extends State<CalendarCustom> {
  late List<DateTime> datesGrid;
  final _stream = StreamController.broadcast();
  final weekName = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  bool isMonth = true;

  bool isViewDate = true;

  final now = DateTime.now();
  DateTime monthSelect = DateTime.now();
  DateTime? selectDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datesGrid = _generateDatesGrid(now);
    if (widget.selectedDateTime != null) {
      selectDate = widget.selectedDateTime;
      _stream.sink.add(datesGrid);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stream.close();
  }

  nextDate(bool isBack) {
    if (isMonth) {
      monthSelect = monthSelect.copyWith(
        month: isBack ? monthSelect.month - 1 : monthSelect.month + 1,
      );
    } else {
      monthSelect = isBack
          ? datesGrid.first.subtract(const Duration(days: 1))
          : datesGrid.last.add(const Duration(days: 1));
    }
    widget.onMonthChanged?.call(monthSelect);
    datesGrid = _generateDatesGrid(monthSelect);
    _stream.sink.add(datesGrid);
  }

  nextYear(bool isBack) {
    monthSelect = monthSelect.copyWith(
      year: isBack ? monthSelect.year - 1 : monthSelect.year + 1,
    );
    _stream.sink.add(datesGrid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream.stream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isViewDate) _buildDate(),
            if (!isViewDate) _buildMonth(),
            if (widget.isViewBottom) ...[
              DividerCustom(space: 12),
              Text(
                !isViewDate ? 'Tháng này' : 'Hôm nay',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.brand,
                ),
              ).padding(12.pading),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildYearAction(),
        10.height,
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 80,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                isViewDate = true;
                monthSelect = monthSelect.copyWith(day: 1, month: index + 1);
                datesGrid = _generateDatesGrid(monthSelect);
                widget.onMonthChanged?.call(monthSelect);
                _stream.sink.add(isViewDate);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: 12.radius,
                  border: Border.all(
                    color: monthSelect.month == index + 1
                        ? AppColors.brand
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Tháng ${index + 1}',
                  style: AppStyle.bodyBsSemiBold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildYearAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconBtn(
          onTap: () {
            nextYear(true);
          },
          size: const Size(26, 26),
          padding: 0.pading,
          backgroundColor: AppColors.bg_primary,
          boxShadow: AppShadows.elevator0,
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 12,
          ),
        ),
        16.width,
        Text(
          '${monthSelect.year}',
          style: AppStyle.headingMd,
          textAlign: TextAlign.center,
        ),
        16.width,
        IconBtn(
          onTap: () {
            nextYear(false);
          },
          size: const Size(26, 26),
          padding: 0.pading,
          backgroundColor: AppColors.bg_primary,
          boxShadow: AppShadows.elevator0,
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMonthAction(),
        5.height,
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 35,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: weekName.length,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                weekName[index],
                style: AppStyle.bodyBsSemiBold.copyWith(
                  color: AppColors.text_quaternary,
                ),
              ),
            );
          },
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 40,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: datesGrid.length,
          itemBuilder: (context, index) {
            final DateTime date = datesGrid[index];
            return _buildItem(date);
          },
        ),
      ],
    );
  }

  Widget _buildMonthAction() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            isViewDate = false;
            _stream.sink.add(isViewDate);
          },
          child: Center(
            child: Text(
              'Tháng ${isMonth ? monthSelect.month : datesGrid.last.month}',
              textAlign: TextAlign.left,
              style: AppStyle.headingMd,
            ),
          ).size(height: 26),
        ),
        16.width,
        IconBtn(
          onTap: () {
            nextDate(true);
          },
          size: const Size(26, 26),
          padding: 0.pading,
          backgroundColor: AppColors.bg_primary,
          boxShadow: AppShadows.elevator0,
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 12,
          ),
        ),
        16.width,
        IconBtn(
          onTap: () {
            nextDate(false);
          },
          size: const Size(26, 26),
          padding: 0.pading,
          backgroundColor: AppColors.bg_primary,
          boxShadow: AppShadows.elevator0,
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
          ),
        ),
        const Spacer(),
        if (widget.isAction) _buildAction(),
      ],
    );
  }

  Widget _buildAction() {
    return Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border_tertiary,
            ),
            borderRadius: 35.radius,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  isMonth = true;
                  datesGrid = _generateDatesGrid(monthSelect);
                  _stream.sink.add(isMonth);
                },
                child: Container(
                  width: 60,
                  height: 26,
                  color: isMonth
                      ? AppColors.bg_primary_active
                      : Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'Tháng',
                    textAlign: TextAlign.center,
                    style: AppStyle.bodySmSemiBold.copyWith(height: 1.5),
                  ),
                ),
              ),
              DividerCustom(isVertival: true),
              GestureDetector(
                onTap: () {
                  isMonth = false;
                  datesGrid = _generateDatesGrid(monthSelect);
                  _stream.sink.add(isMonth);
                },
                child: Container(
                  width: 60,
                  height: 26,
                  alignment: Alignment.center,
                  color: !isMonth
                      ? AppColors.bg_primary_active
                      : Colors.transparent,
                  child: Text(
                    'Tuần',
                    textAlign: TextAlign.center,
                    style: AppStyle.bodySmSemiBold.copyWith(height: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool checkNowOrFuture(DateTime date) {
    if (date.year > now.year) return true;
    if (date.month > now.month && date.year >= now.year) return true;
    if (date.day >= now.day && date.month >= now.month) return true;

    return false;
  }

  Widget _buildItem(DateTime date) {
    final bool nowOrFuture = checkNowOrFuture(date);

    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final bool isActive =
        widget.nowOrFuture ? nowOrFuture : monthSelect.month == date.month;

    // final bool isActive = (date.year == now.year && date.month >= now.month) ||
    //     date.year > now.year;

    final bool isChoose = (date.year == selectDate?.year &&
            date.month == selectDate?.month &&
            date.day == selectDate?.day) &&
        widget.isChoose;

    final events = widget.events.where(
      (element) =>
          date.year == element.date.year &&
          date.month == element.date.month &&
          date.day == element.date.day,
    );

    return GestureDetector(
      onTap: () {
        if (!nowOrFuture && widget.nowOrFuture) {
          return;
        }
        if (widget.isChoose) {
          selectDate = date;
          _stream.sink.add(selectDate);
          widget.onChanged?.call(date);
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChoose ? AppColors.bg_black : Colors.transparent,
              border: Border.all(
                color:
                    isToday && !isChoose ? AppColors.brand : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: isToday || isChoose
                    ? AppStyle.bodyBsSemiBold.copyWith(
                        color: isChoose ? AppColors.text_white : null,
                      )
                    : AppStyle.bodyBsRegular.copyWith(
                        color: !isActive ? AppColors.text_disable : null,
                      ),
              ),
            ),
          ),
          if (events.isNotEmpty)
            Positioned(
              bottom: 7,
              child: Container(
                padding: 2.pading,
                decoration: BoxDecoration(
                  color:
                      isChoose ? AppColors.bg_primary : AppColors.ultility_blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                // child: events.first.count > 0
                //     ? Text(
                //         events.first.count.toString(),
                //         style: AppStyle.bodySmRegular.copyWith(
                //           color: AppColors.text_white,
                //           fontSize: 7,
                //         ),
                //       )
                //     : null,
              ),
            ),
        ],
      ),
    );
  }

  List<DateTime> _generateDatesGrid(DateTime month) {
    final List<DateTime> dates = [];
    if (!isMonth) {
      final mondayWeek = month.subtract(Duration(days: month.weekday - 1));

      for (int i = 0; i < 7; i++) {
        dates.add(
          mondayWeek.copyWith(
            day: mondayWeek.day + i,
          ),
        );
      }
      print(month);
      print(mondayWeek);

      return dates;
    }

    final int numDays = DateTime(month.year, month.month + 1, 0).day;
    final int lastWeekday = DateTime(month.year, month.month, 0).weekday % 7;

    // Fill previous month's dates
    final DateTime previousMonth = DateTime(month.year, month.month - 1);
    final int previousMonthLastDay =
        DateTime(previousMonth.year, previousMonth.month + 1, 0).day;

    for (int i = lastWeekday; i > 0; i--) {
      dates.add(
        DateTime(
          previousMonth.year,
          previousMonth.month,
          previousMonthLastDay - i + 1,
        ),
      );
    }

    // Fill current month's dates
    for (int day = 1; day <= numDays; day++) {
      dates.add(DateTime(month.year, month.month, day));
    }

    final int countRow = (dates.length / 7).ceil();

    // Fill next month's dates
    final int remainingBoxes = countRow > 5
        ? 42 - dates.length
        : 35 - dates.length; // 6 weeks * 7 days
    for (int day = 1; day <= remainingBoxes; day++) {
      dates.add(DateTime(month.year, month.month + 1, day));
    }

    return dates;
  }
}
