import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/date_time/param_date.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../features/customer/data/models/customer_model.dart';
import '../../repositories/events/event_repository.dart';
import '../state/init_state.dart';

class CalendarManagerBloc extends Cubit<CubitState> {
  CalendarManagerBloc() : super(CubitState());
  final _repo = EventRepository();
  final List<EventModel> list = [];
  int _page = 1;
  String? _search;
  final delay = DelayCallBack(delay: 500.milliseconds);
  changeSearch(String? value) {
    _search = value;
    delay.debounce(
      () {
        getList();
      },
    );
  }

  bool _isFilter = false;
  bool get isFilter => _isFilter;
  set isFilter(bool value) {
    _isFilter = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  final Map<String, List<EventModel>> events = {};

  final kToday = DateTime.now();
  final kLastDay = DateTime.now().copyWith(
    month: DateTime.now().month + 12,
  );

  DateTime _selectDay = DateTime.now();
  DateTime get selectDay => _selectDay;

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;

  setFocusedDayPage(DateTime pageDay) {
    _focusedDay = pageDay;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<EventModel> getEvensByMonth() {
    final List<EventModel> eventsMonth = [];
    events.forEach(
      (key, value) {
        final keyDay = DateFormat('dd/MM/yyyy').parse(key);

        if (kToday.fomatCustom(fomat: 'MM/yyyy') ==
            keyDay.fomatCustom(fomat: 'MM/yyyy')) {
          eventsMonth.addAll(value);
        }
      },
    );

    return eventsMonth;
  }

  onDaySelected(DateTime selected, DateTime focused) {
    _selectDay = selected;
    _focusedDay = focused;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<EventModel> getEventsForDay(DateTime day) {
    return events[day.fomatDefaulft] ?? [];
  }

  ParamDate? _paramData;
  ParamDate? get paramData => _paramData;
  setParamDate(ParamDate? value, {int? limit}) {
    _paramData = value;
    getList(limit: limit);
  }

  CustomerModel? _customer;
  CustomerModel? get customer => _customer;
  setCustomer(CustomerModel? value) {
    _customer = value;
    getList();
  }

  EmployeeModel? _doctor;
  EmployeeModel? get doctor => _doctor;
  setDoctor(EmployeeModel? value) {
    _doctor = value;
    getList();
  }

  getList({
    bool isMore = false,
    int? limit,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    print('is reload: $isMore');
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(
      company: getCompany!,
      customer: _customer?.id,
      doctor: _doctor?.id,
      timeStart: _paramData?.startDate?.fomatCustom(fomat: 'yyyy-MM-dd'),
      timeEnd: _paramData?.endDate?.fomatCustom(fomat: 'yyyy-MM-dd'),
      page: _page,
      search: _search,
      limit: limit ?? 20,
    );
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
