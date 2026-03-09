import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/role_v2/role_v2_repository.dart';

import '../../models/role/role_model.dart';
import '../enum/bloc_status.dart';

class RoleTreeBloc extends Cubit<CubitState> {
  RoleTreeBloc() : super(CubitState());

  final repo = RoleV2Repository();

  List<RoleListModel> list = [];

  bool? get all {
    bool val = true;
    bool flag = false;
    for (final element in list) {
      val = val && (element.value ?? false);
      flag = flag || (element.value ?? false);
      for (final sub in element.subApp ?? []) {
        val = val && (sub.value ?? false);
        flag = flag || (sub.value ?? false);
      }
    }
    print('all: $val');
    print('flag: $flag');
    if (val) {
      return true;
    }
    if (flag) {
      return null;
    }
    return false;
  }

  void setAll(bool value) {
    for (final element in list) {
      element.value = value;
      for (final sub in element.subApp ?? []) {
        sub.value = value;
      }
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void reload() {
    emit(state.copyWith(status: BlocStatus.success));
  }

  void getList() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await repo.getPermissions();
    list.clear();
    list.addAll(res.data ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }

  void countValue() {
    // ignore: unused_local_variable
    int count = 0;
    for (final element in list) {
      if (element.value ?? false) {
        count++;
      }
      for (final sub in element.subApp ?? []) {
        if (sub.value ?? false) {
          count++;
        }
      }
    }
  }

  void changeAll(bool value) {
    for (final element in list) {
      element.value = value;
      for (final sub in element.subApp ?? []) {
        sub.value = value;
      }
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void setList(List<RoleListModel>? items) {
    for (int i = 0; i < list.length; i++) {
      final index = items?.indexWhere((element) => element.id == list[i].id);
      if (index != -1) {
        list[i].value = items?[index!].value;
        for (int j = 0; j < (list[i].subApp ?? []).length; j++) {
          final subIndex = items?[index!]
              .subApp
              ?.indexWhere((element) => element.id == list[i].subApp?[j].id);
          if (subIndex != -1) {
            list[i].subApp?[j].value = items?[index!].subApp?[subIndex!].value;
          }
        }
      }
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
}
