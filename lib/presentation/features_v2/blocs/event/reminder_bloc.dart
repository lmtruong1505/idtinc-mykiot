import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/event/components/bts/bts_reminder_event.dart';
import '../state/init_state.dart';

class ReminderBloc extends Cubit<CubitState> {
  ReminderBloc() : super(CubitState());
  final List<ReminderModel> list = [
    ReminderModel(count: 0, type: TimeReminderEnum.DAYS),
  ];

  String _description = '';
  String get description => _description;

  void setDescription(String value) {
    _description = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void addReminder(ReminderModel value, {int? i}) {
    if (i != null) {
      list.insert(i, value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void updateReminder(int index, ReminderModel value) {
    list[index] = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  int? _index;
  int? get index => _index;

  set index(int? value) {
    _index = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void setChoose(int value) {
    defaultData[value].isChoose = !defaultData[value].isChoose;
    emit(state.copyWith(status: BlocStatus.success));
  }

  filterData(DateTime time) {
    defaultData.removeWhere(
      (element) {
        final now = DateTime.now();
        if (element.type == TimeReminderEnum.DAYS) {
          final day = time.copyWith(day: time.day - element.count);
          return day.isBefore(now);
        }
        if (element.type == TimeReminderEnum.HOURS) {
          final day = time.copyWith(hour: time.hour - element.count);
          return day.isBefore(now);
        }
        if (element.type == TimeReminderEnum.MINUTES) {
          final day = time.copyWith(minute: time.minute - element.count);
          return day.isBefore(now);
        }
        return false;
      },
    );
  }

  resetData() {
    for (var i = 0; i < defaultData.length; i++) {
      defaultData[i].isChoose = false;
    }
    _description = '';
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<ReminderModel> defaultData = [
    ReminderModel(count: 15, type: TimeReminderEnum.MINUTES),
    ReminderModel(count: 30, type: TimeReminderEnum.MINUTES),
    ReminderModel(count: 1, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 2, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 3, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 4, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 5, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 6, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 12, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 1, type: TimeReminderEnum.DAYS),
    ReminderModel(count: 2, type: TimeReminderEnum.DAYS),
  ];

  bool get isActive => defaultData.map((e) => e.isChoose).contains(true);
  // _index != null || list.map((e) => e.count > 0).toList().contains(true);
}

class ReminderModel {
  TimeReminderEnum type;
  int count;
  bool isChoose;
  ReminderModel({
    this.isChoose = false,
    required this.count,
    required this.type,
  });
}
