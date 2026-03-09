import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';

import '../../../../features_v2/blocs/state/init_state.dart';
import '../../../../features_v2/models/role/role_model.dart';

class AddStaffBranchBloc extends Cubit<CubitState> {
  AddStaffBranchBloc() : super(CubitState());

  final List<AddStaffModel> listStaff = [];

  List<int> get staffIds => listStaff.map((e) => e.staff.id!).toList();

  int _indexTab = 0;
  int get indexTab => _indexTab;
  bool get checkRoleEmpty {
    return listStaff.any((e) => e.roles.isEmpty);
  }

  set indexTab(int index) {
    _indexTab = index;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void updateRoles(int index, List<RoleListModel> roles) {
    listStaff[index].roles = roles;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void removeStaff(int index) {
    listStaff.removeAt(index);
    if (listStaff.isEmpty) {
      _indexTab = 0;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void addStaff(PreEmpModel staff) {
    if (staffIds.contains(staff.id)) {
      listStaff.removeWhere(
        (element) => element.staff.id == staff.id,
      );
    } else {
      listStaff.add(AddStaffModel(staff: staff, roles: []));
    }

    emit(state.copyWith(status: BlocStatus.success));
  }
}

class AddStaffModel {
  PreEmpModel staff;
  List<RoleListModel> roles;
  AddStaffModel({
    required this.staff,
    required this.roles,
  });
}
