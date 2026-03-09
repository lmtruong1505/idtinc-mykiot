import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/events/event_repository.dart';

import '../state/init_state.dart';

class DeleteEventBloc extends Cubit<CubitState> {
  DeleteEventBloc() : super(CubitState());
  final _repo = EventRepository();

  delete({
    required int id,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final res = await _repo.delete(id);
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
          status: BlocStatus.success,
          msg: res.message ?? 'Huỷ lịch hẹn không thành công',
        ),
      );
    }
  }
}
