import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/repositories/employee_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../enum/enum_bloc.dart';
import '../state/init_state.dart';

class StaffManagerBloc extends Cubit<CubitState> {
  StaffManagerBloc() : super(CubitState());
  final delay = DelayCallBack(delay: 500.milliseconds);
  final _repo = getIt<EmployeeRepository>();
  final List<EmployeeModel> list = [];
  final List<int> counts = List.generate(
    AccountStatusEnum.values.length,
    (index) => 0,
  );

  init() {
    _search = null;
    _role = null;
    _active = AccountStatusEnum.all;
  }

  String? _search = '';
  search(String value) {
    _search = value;
    delay.debounce(getList);
  }
  int? company = getCompany;

  AccountStatusEnum _active = AccountStatusEnum.all;
  AccountStatusEnum get active => _active;

  setActive(AccountStatusEnum value, {bool isReload = true}) {
    _active = value;
    if (isReload) getList();
  }

  int? _role;
  int? get role => _role;
  setRole(int? value) {
    _role = value;
    getList();
  }

  int _page = 0;
  getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 0;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(
      company: company,
      page: _page,
      limit: 20,
      search: _search,
      role: _role,
      active: _active.value,
    );
    list.addAll(res.data ?? []);
    final int countActive = res.extra is Map
        ? int.tryParse(res.extra['active'].toString()) ?? 0
        : 0;
    final int countUnActive = res.extra is Map
        ? int.tryParse(res.extra['un_active'].toString()) ?? 0
        : 0;

    counts[0] = countUnActive + countActive;
    counts[1] = countActive;
    counts[2] = countUnActive;

    emit(state.copyWith(status: BlocStatus.success));
  }
}
