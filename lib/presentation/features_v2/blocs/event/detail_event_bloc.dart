import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/event/detail_event_model.dart';

import '../../repositories/events/event_v2_repository.dart';
import '../state/init_state.dart';

class DetailEventV2Bloc extends Cubit<CubitState<DetailEventV2Model>> {
  DetailEventV2Bloc() : super(CubitState());

  final _repo = EventV2Repository();

  Future<void> getData(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detail(id);

    if (res.data != null && res.code == 200) {
      emit(state.copyWith(status: BlocStatus.success, data: res.data));
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Không tìm thấy thông tin lịch hẹn',
        ),
      );
    }
  }
}
