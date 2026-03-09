import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/employee/emp_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../models/employee/pre_emp_model.dart';
import '../enum/bloc_status.dart';

class EmpManagementBloc extends Cubit<CubitState> {
  EmpManagementBloc() : super(CubitState());
  final repo = EmpRepository();
  final _delay = DelayCallBack(delay: 500.milliseconds);

  List<PreEmpModel> list = [];
  List<DropdownMenuItem<PreEmpModel>> listDropdown = [];
  int _page = 1;
  int get page => _page;

  String? _search;
  String get search => _search ?? '';
  EmployeeStatus status = EmployeeStatus.all;

  bool get isSort =>
      status != EmployeeStatus.all || _role != null || _branch != null;

  int? _role;
  int? get role => _role;
  int? _branch;
  int? get branch => _branch;

  int count = 0;

  changeSearch(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  changeFilter({
    EmployeeStatus? status,
    int? role,
    int? branch,
  }) {
    _role = role;
    _branch = branch;
    this.status = status ?? EmployeeStatus.all;

    getList();
  }

  getList({bool isMore = false}) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final company = getCompany ?? -1;
    final res = await repo.getEmps(
      company: company,
      page: _page,
      search: _search,
      status: status.code,
      role: _role,
    );
    count = res.extra ?? 0;
    list.addAll(res.data ?? []);
    listDropdown = list
        .map(
          (e) => DropdownMenuItem<PreEmpModel>(
            value: e,
            child: Text(e.userData?.fullName ?? ''),
          ),
        )
        .toList();
    emit(state.copyWith(status: BlocStatus.success, isFirst: false));
  }
}
