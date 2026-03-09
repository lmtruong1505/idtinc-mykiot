import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/role/domain/repositories/role_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../models/role/role_model.dart';
import '../state/init_state.dart';

class ListRoleBloc extends Cubit<CubitState> {
  ListRoleBloc() : super(CubitState());
  final delay = DelayCallBack(delay: 500.milliseconds);
  final _repo = getIt<RoleRepository>();
   List<RoleListModel> list = [];
  int? _value;
  int? get value => _value;

  init({int? companyId}) {
    emit(CubitState());
    _search = '';
    _value = null;
    _page = 0;
    getList(
      company: companyId,
    );
  }

  String? _search = '';
  search(String value) {
    _search = value;
    delay.debounce(getList);
  }

  int _page = 0;

  getList({
    bool isMore = false,
    int? valueData,
    int? company,
    String? searchSp,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 0;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final res = await _repo.getList(
        company ?? (getCompany ?? 0),
        searchSp ?? (_search ?? ''),
        _page,
        limit: 100,
      );
      for (final json in res ?? []) {
        final model = RoleListModel.fromJson(json);
        if (model.id == valueData) {
          _value = valueData;
        }

        list.add(model);
      }
    } catch (e) {
      print(e);
    }

    emit(state.copyWith(status: BlocStatus.success));
  }

  void reload() {
    emit(state.copyWith(status: BlocStatus.success));
  }
}
