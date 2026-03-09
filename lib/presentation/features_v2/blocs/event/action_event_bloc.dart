import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/events/event_v2_repository.dart';

import '../state/init_state.dart';

class ActionEventV2Bloc extends Cubit<CubitState> {
  ActionEventV2Bloc() : super(CubitState());

  final _repo = EventV2Repository();

  reminderZalo(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.reminderZalo(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Gửi lại nhắc hẹn thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Gửi lại nhắc hẹn thất bại',
        ),
      );
    }
  }

  reSendEventZalo(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.reSendEventZalo(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: 'resend-event-zalo',
          msg: 'Gửi lại lịch hẹn đến khách hàng thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Gửi lại lịch hẹn đến khách hàng thất bại',
        ),
      );
    }
  }

  remove(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.remove(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: 'remove',
          msg: 'Xoá lịch hẹn thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Xoá lịch hẹn thất bại',
        ),
      );
    }
  }

  updateStatus(int id, String status) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.updateStatus(id, status);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Cập nhật trạng thái lịch hẹn thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Cập nhật trạng thái lịch hẹn thất bại',
        ),
      );
    }
  }

  cancel(int id, String reason) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.cancel(id, reason);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Huỷ lịch hẹn thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Huỷ lịch hẹn thất bại',
        ),
      );
    }
  }
}
