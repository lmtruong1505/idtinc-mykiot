import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/phieu_kham_v2/phieu_kham_v2_repo.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../../features/product/data/models/basic_model.dart';
import '../enum/bloc_status.dart';

class ListBenhBloc extends Cubit<CubitState> {
  ListBenhBloc() : super(CubitState());
  final delay = DelayCallBack(delay: 500.milliseconds);
  List<BasicModel> _list = [];
  List<BasicModel> get list => _list;
  final _repo = PhieuKhamV2Repo();

  int _page = 1;

  String? _search = '';
  search(String value) {
    _search = value;
    delay.debounce(getList);
  }

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
    try {
      final res = await _repo.getBenh(
        page: _page,
        limit: 100,
        search: _search ?? '',
      );
      _list.addAll(res.data ?? []);
    } catch (e) {
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
}