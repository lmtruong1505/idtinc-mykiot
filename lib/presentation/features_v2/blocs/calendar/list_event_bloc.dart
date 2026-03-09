import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/events/event_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../state/init_state.dart';

@injectable
class ListEventBloc extends Cubit<CubitState> {
  ListEventBloc() : super(CubitState());
  final _repo = EventRepository();
  final delay = DelayCallBack(delay: 500.milliseconds);
  final List<EventModel> list = [];
  int _page = 1;
  String? _search;

  changeSearch(String? value) {
    _search = value;
    delay.debounce(
      () {},
    );
  }

  getList({
    bool isMore = false,
    int? customer,
    int? doctor,
    String? timeStart,
    String? timeEnd,
    int? idBranch,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(
      company: idBranch ?? getCompany!,
      customer: customer,
      doctor: doctor,
      timeStart: timeStart,
      timeEnd: timeEnd,
      page: _page,
      search: _search,
    );
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }

}
