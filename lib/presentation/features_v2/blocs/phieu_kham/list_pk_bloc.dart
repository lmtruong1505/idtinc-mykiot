import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/param/param_list_phieu_kham.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/phieu_kham/phieu_kham_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../state/init_state.dart';

class ListPhieuKhamBloc extends Cubit<CubitState> {
  ListPhieuKhamBloc() : super(CubitState());
  final _repo = PhieuKhamRepository();
  final List<EventModel> list = [];
  final _delay = DelayCallBack(delay: 500.milliseconds);

  String? _search;
  changeSearch(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  int _page = 1;

  getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final param = ParamListPhieuKhaman(
      company: getCompany,
      page: _page,
      search: _search,
      
    );
    final res = await _repo.getList(param.toMap());
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }


}
