import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';

import '../../../../shared/components/widgets/calendar_custom.dart';
import '../../repositories/events/event_v2_repository.dart';
import '../state/init_state.dart';

class EventCalendarV2Bloc extends Cubit<CubitState> {
  EventCalendarV2Bloc() : super(CubitState());

  final _repo = EventV2Repository();

  List<CalendarEventCount> list = [];


  Future<void> getList(DateTime date) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.calendar(
      month: date.month,
      year: date.year,
      companyId: getCompanyId,
    );
    list = res.data ?? [];

    emit(state.copyWith(status: BlocStatus.success));
  }
}
