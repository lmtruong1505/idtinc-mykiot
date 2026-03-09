import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/param_event_model.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';

import '../../repositories/events/event_repository.dart';
import '../../repositories/phieu_kham/phieu_kham_repository.dart';
import '../state/init_state.dart';

class CreateEventBloc extends Cubit<CubitState> {
  CreateEventBloc() : super(CubitState());
  final _repo = EventRepository();
  final _repoPhieuKham = PhieuKhamRepository();
  bool _isEvent = false;
  bool get isEvent => _isEvent;
  set isEvent(bool value) {
    _isEvent = value;
  }

  int? _customer;
  int? get customer => _customer;
  set customer(int? value) {
    _customer = value;
    emit(state.copyWith(status: BlocStatus.initial));
  }

  int? _company;
  int? get company => _company;
  set company(int? value) {
    _company = value;
    _doctor = null;
    emit(state.copyWith(status: BlocStatus.initial));
  }

  int? _doctor;
  int? get doctor => _doctor;
  set doctor(int? value) {
    _doctor = value;
    emit(state.copyWith(status: BlocStatus.initial));
  }

  int? _service;
  int? get service => _service;
  set service(int? value) {
    _service = value;
    emit(state.copyWith(status: BlocStatus.initial));
  }

  TimeOfDay? _time;
  TimeOfDay? get time => _time;
  set time(TimeOfDay? value) {
    _time = value;
    emit(state.copyWith(status: BlocStatus.initial));
  }

  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? value) {
    _date = value;
    emit(state.copyWith(status: BlocStatus.initial));
  }

  bool get isCreate {
    if (!_isEvent) {
      return customer != null &&
          service != null &&
          company != null &&
          doctor != null;
    }
    print(
        '$customer != null && $service != null && $time != null && $date != null && $company != null && $doctor != null');

    return customer != null &&
        service != null &&
        time != null &&
        date != null &&
        company != null &&
        doctor != null;
  }

  createEvent() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final param = ParamEventModel(
      company: company,
      customerId: customer,
      doctorId: doctor,
      services: [service!],
      meetingAt: _date
          ?.copyWith(
            hour: _time?.hour ?? 0,
            minute: _time?.minute ?? 0,
          )
          .fomatCustom(fomat: 'yyyy-MM-dd HH:mm'),
    );
    final res = await _repo.create(param.toJson());

    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Tạo lịch hẹn thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Tạo lịch hẹn không thành công',
        ),
      );
    }
  }

  createPhieuKham({
    int? appointment,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final param = ParamEventModel(
      company: company,
      customerId: customer,
      doctorId: doctor,
      services: [
        service!,
      ],
      appointment: appointment,
    );
    final res = await _repoPhieuKham.create(param.toJson());

    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Tạo phiếu khám thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Tạo phiếu khám không thành công',
        ),
      );
    }
  }
}
