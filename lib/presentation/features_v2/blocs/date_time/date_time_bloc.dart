import 'package:flutter_bloc/flutter_bloc.dart';

import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';
import 'param_date.dart';

class DateTimeBloc extends Cubit<CubitState<ParamDate>> {
  DateTimeBloc() : super(CubitState<ParamDate>());

  DateTime? _start;
  DateTime? _end;

  DateTime? get start => _start;
  DateTime? get end => _end;

  set start(DateTime? value) {
    _start = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  set end(DateTime? value) {
    _end = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  final DateTime _now = DateTime.now();

  final List<DateRangeEnum> optionYear = [
    DateRangeEnum.thisYear,
    DateRangeEnum.lastYear,
    DateRangeEnum.option,
  ];

  final List<DateRangeEnum> optionDateTime = [
    DateRangeEnum.today,
    DateRangeEnum.yesterday,
    DateRangeEnum.thisWeek,
    DateRangeEnum.thisMonth,
    DateRangeEnum.lastWeek,
    DateRangeEnum.lastMonth,
    DateRangeEnum.all,
    DateRangeEnum.option,
  ];

  back() {
    emit(
      state.copyWith(status: BlocStatus.initial),
    );
  }

  ParamDate chooseBtn(
    DateRangeEnum item, {
    DateTime? dateStart,
    DateTime? dateEnd,
  }) {
    if (item == DateRangeEnum.today) {
      _start = DateTime(_now.year, _now.month, _now.day);
      _end = _now;
    } else if (item == DateRangeEnum.yesterday) {
      _start = DateTime(_now.year, _now.month, _now.day - 1);
      _end = _start!.copyWith(
        hour: 23,
        minute: 59,
        second: 59,
      );
    } else if (item == DateRangeEnum.thisWeek) {
      _getWeek(false);
    } else if (item == DateRangeEnum.thisMonth) {
      _getMonth(false);
    } else if (item == DateRangeEnum.lastWeek) {
      _getWeek(true);
    } else if (item == DateRangeEnum.lastMonth) {
      _getMonth(true);
    } else {
      _start = null;
      _end = null;
    }
    if (dateStart != null && dateEnd != null) {
      _start = dateStart;
      _end = dateEnd;
    }
    final param = ParamDate(
      dateRange: item,
      startDate: _start,
      endDate: _end,
    );

    emit(
      state.copyWith(
        status: BlocStatus.success,
        msg: item.toName,
        data: param,
      ),
    );
    print('${item} - Start: $_start <==> End: $_end');

    return param;
  }

  _getWeek(bool isLast) {
    final int currentWeekday = _now.weekday;
    DateTime mondayWeek;
    DateTime sundayWeek;
    if (isLast) {
      mondayWeek = _now
          .subtract(Duration(days: currentWeekday + 6))
          .copyWith(hour: 0, minute: 0, second: 0);
      sundayWeek = _now
          .subtract(Duration(days: currentWeekday))
          .copyWith(hour: 23, minute: 59, second: 59);
    } else {
      mondayWeek = _now
          .subtract(
            Duration(days: currentWeekday - 1),
          )
          .copyWith(hour: 0, minute: 0, second: 0);
      sundayWeek = _now;
    }

    _start = mondayWeek;
    _end = sundayWeek;

    print('now: $_now');
    print('Monday of last week: $mondayWeek');
    print('Sunday of last week: $sundayWeek');
  }

  _getMonth(bool isLast) {
    DateTime firstDayMonth;
    DateTime lastDayMonth;

    if (isLast) {
      firstDayMonth = DateTime(_now.year, _now.month - 1, 1);
      lastDayMonth = DateTime(_now.year, _now.month, 0, 23, 59, 59);
    } else {
      firstDayMonth = DateTime(_now.year, _now.month, 1);
      lastDayMonth = _now;
    }

    _start = firstDayMonth;
    _end = lastDayMonth;

    print('now: $_now');
    print('First day month: $firstDayMonth');
    print('Last day month: $lastDayMonth');
  }
}
