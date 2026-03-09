import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/events/event_repository.dart';

import '../../models/calendar/event_model.dart';
import '../state/init_state.dart';

class DetailEventBloc extends Cubit<CubitState> {
  DetailEventBloc() : super(CubitState());
  EventModel? event;
  final _repo = EventRepository();

  getData({
    required int id,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final res = await _repo.detail(id);
    event = res.data;

    emit(
      state.copyWith(
        status: BlocStatus.success,
        msg: res.code == 200 ? 'Lấy thông tin thành công' : res.message,
      ),
    );
  }
}
