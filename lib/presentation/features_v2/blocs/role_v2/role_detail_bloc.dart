import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/presentation/features_v2/models/role/detail_role_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/role_v2/role_v2_repository.dart';

import '../../../../data/models/base/response.dart';
import '../../../features/branch/data/entities/branch_emp_entity.dart';
import '../../models/role/role_model.dart';
import '../state/init_state.dart';

class RoleDetailBloc extends Cubit<CubitState> {
  RoleDetailBloc() : super(CubitState());

  final _repo = RoleV2Repository();

  DetailRoleModel? _model;

  DetailRoleModel? get model => _model;

  List<PreEmpModel> get employees => (_model?.employees ?? [])
      .where(
        (element) =>
            (element.userData?.fullName?.contains(search) ?? false) ||
            (element.userData?.code?.contains(search) ?? false) ||
            (element.userData?.phoneNumber?.contains(search) ?? false),
      )
      .toList();

  String? _search;

  String get search => _search ?? '';

  set search(String value) {
    emit(state.copyWith(status: BlocStatus.loading));
    _search = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<void> getDetail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getDetail(id);
    _model = res.data;
    for (final item in _model?.items ?? []) {
      // item.value = item.subApp?.fold(
      //       true,
      //       (previousValue, element) =>
      //           previousValue && (element.value ?? false),
      //     ) ??
      //     false;
      // ;
      bool all = true;
      bool flag = false;
      for (final sub in item.subApp ?? []) {
        all = all && (sub.value ?? false);
        flag = flag || (sub.value ?? false);
      }
      item.value = all ? true : flag ? null : false;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<RoleListModel> filter() {
    final list = _model?.items?.fold(
      <RoleListModel>[],
      (previousValue, element) {
        final subList =
            element.subApp?.fold(<RoleListModel>[], (previousValue2, element2) {
                  if (element2.value ?? false) {
                    previousValue2.add(element2);
                  }
                  return previousValue2;
                }) ??
                [];
        if (subList.isNotEmpty) {
          previousValue.add(element.copyWith(subApp: subList));
        }
        return previousValue;
      },
    );
    return list ?? [];
  }

  Future<BaseResponseModel> assign(List<BranchEmpEntity> list) async {
    final payload = {
      'role': _model?.role?.id,
      'accounts': list.map((e) => e.employee?.wpId).toList(),
    };
    final res = await _repo.assignEmp(payload: payload);
    return res;
  }

  List<int> _selectToRemoves = [];

  List<int> get selectToRemoves => _selectToRemoves;

  bool checkIfCanRemove(int id) {
    return _selectToRemoves.any((element) => element == id);
  }

  void toggleRemove(int id) {
    if (checkIfCanRemove(id)) {
      _selectToRemoves.removeWhere((element) => element == id);
    } else {
      _selectToRemoves.add(id);
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> detachEmp() async {
    final payload = {
      'role': _model?.role?.id,
      'accounts': _selectToRemoves,
    };
    return _repo.detachEmp(payload: payload);
  }

  Future<BaseResponseModel> delete(int id) async {
    return _repo.delete(id: id);
  }
}
