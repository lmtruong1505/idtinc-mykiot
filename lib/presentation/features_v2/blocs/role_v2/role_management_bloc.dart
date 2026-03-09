import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/role_v2/role_v2_repository.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../../shared/utils/get.dart';
import '../../models/role/role_model.dart';
import '../enum/bloc_status.dart';

class RoleManagementBloc extends Cubit<CubitState> {
  RoleManagementBloc() : super(CubitState());

  final repo = RoleV2Repository();
  final _delay = DelayCallBack(delay: 500.milliseconds);

  List<RoleListModel> list = [];

  int _page = 1;
  int get page => _page;

  int? _position;
  int? get position => _position;
  changePosition(int? value) {
    _position = value;
    getList();
  }

  String? _search;
  String get search => _search ?? '';
  changeSearch(String? value) {
    _search = value;
    _delay.debounce(
          () => getList(),
    );
  }

  bool get isSort =>
      _position != null;

  int count = 0;

  getList({bool isMore = false}) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final company = getCompany ?? -1;
    final res = await repo.getRoles(
      company: company,
      page: _page,
      search: _search,
      limit: 10,
      position: position,
    );
    count = res.extra ?? 0;
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }

}