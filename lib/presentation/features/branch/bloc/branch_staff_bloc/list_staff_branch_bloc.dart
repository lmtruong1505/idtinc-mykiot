import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/branch/data/entities/branch_emp_entity.dart';
import 'package:pharmago/presentation/features/branch/domain/use_case/assign_staff_use_case.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../shared/utils/delay_callback.dart';
import '../../../../features_v2/blocs/enum/bloc_status.dart';
import '../../../employee/employee/data/mapper/employee_entity_mapper.dart';
import '../../data/repositories/branch_repository.dart';

@injectable
class ListStaffBranchBloc extends Cubit<CubitState> {
  ListStaffBranchBloc(
    this._assignStaffUseCase,
  ) : super(CubitState());

  final _employeeMapper = getIt<EmployeeMapper>();
  final AssignStaffUseCase _assignStaffUseCase;
  final _repo = BranchRepository();
  final delay = DelayCallBack(delay: 500.milliseconds);
  bool isFirst = true;

  List<int> get staffIds => list
      .where(
        (element) => element.isSelect == true,
      )
      .map(
        (e) => e.employee?.id ?? -1,
      )
      .toList();

  int? _role;
  int? get role => _role;
  set role(int? value) {
    _role = value;
    getList();
  }

  int? _company;
  int? get company => _company;
  set company(int? value) {
    _company = value;
    getList();
  }

  final List<BranchEmpEntity> list = [];
  int _page = 1;
  String? _search;

  final selections = SelectionType.values;
  var selection = SelectionType.list;

  void changeSelection(SelectionType value) {
    selection = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  changeSearch(String? value) {
    _search = value;
    delay.debounce(
      () {
        getList();
      },
    );
  }

  Future getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getStaff(
      companyId: _company,
      limit: 20,
      page: _page,
      search: _search,
      role: role,
    );
    final mapData = _employeeMapper.mapToListEntity(res.data ?? []);
    list.addAll(
      mapData.map(
        (e) => BranchEmpEntity(isSelect: false, employee: e),
      ),
    );


    if (res.data.validator.isNotEmpty) {
      isFirst = false;
    }

    emit(state.copyWith(status: BlocStatus.success, isFirst: false));
  }

  void selectStaff(int index) {
    list[index] = list[index].copyWith(isSelect: !list[index].isSelect);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> addStaff(int company) async {
    final assign = list
        .where((element) => element.isSelect)
        .map((e) => e.employee?.id ?? -1)
        .toList();
    final input =
        AssignStaffInput(company: company, assign: assign, remove: []);
    final res = await _assignStaffUseCase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel> removeStaff(int company) async {
    final remove = list
        .where((element) => element.isSelect)
        .map((e) => e.employee?.id ?? -1)
        .toList();
    final input =
        AssignStaffInput(company: company, assign: [], remove: remove);
    final res = await _assignStaffUseCase.execute(input);
    return res.response;
  }
}

enum SelectionType {
  list,
  selected,
}

extension ExtSelectionType on SelectionType {
  String get toName {
    switch (this) {
      case SelectionType.list:
        return 'Danh sách';
      case SelectionType.selected:
        return 'Đã chọn';
    }
  }
}
