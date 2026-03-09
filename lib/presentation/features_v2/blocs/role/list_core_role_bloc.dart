import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/param/create_role_param.dart';
import 'package:pharmago/presentation/features_v2/models/role/role_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../features/employee/role/domain/repositories/role_repository.dart';
import '../state/init_state.dart';

class ListCoreRoleBloc extends Cubit<CubitState> {
  ListCoreRoleBloc() : super(CubitState());

  final _repo = getIt<RoleRepository>();
  final List<RoleListModel> list = [];
  bool isAll = false;

  checkAll(bool value) {
    isAll = value;
    for (final element in list) {
      element.value = value;
      for (final sub in element.subApp ?? []) {
        sub.value = value;
      }
    }
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  chooseCheckBox({
    required int index,
    required bool value,
    int? indexV2,
  }) {
    if (indexV2 != null) {
      list[index].subApp?[indexV2].value = value;
      bool val = true;

      list[index].subApp?.forEach(
        (element) {
          val = val == true && element.value == true;
        },
      );
      list[index].value = val;
    } else {
      list[index].value = value;
      for (int i = 0; i < list[index].subApp.validator.length; i++) {
        list[index].subApp.validator[i].value = value;
      }
    }
    bool valAll = true;
    list.forEach(
      (element) {
        valAll = valAll == true && element.value == true;
      },
    );
    isAll = valAll;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  setData(List<RoleItems> values) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].subApp.validator.length; j++) {
        final list2 =
            values.where((e) => e.appCode == list[i].subApp?[j].code).toList();
        if (list2.isNotEmpty) {
          list[i].subApp?[j].value = list2.first.checked ?? false;
        }
        list[i].value = list[i].subApp?.fold(
              false,
              (previousValue, element) =>
                  previousValue == true || element.value == true,
            );
      }
    }
  }

  List<RoleItems> mapItems(List<RoleListModel> values) {
    final List<RoleItems> items = [];
    for (final element in values) {
      items.add(
        RoleItems(
          appCode: element.code,
          checked: element.value ?? false,
        ),
      );
      for (final e in element.subApp.validator) {
        items.add(
          RoleItems(
            appCode: e.code,
            checked: e.value ?? false,
          ),
        );
      }
    }
    return items;
  }

  getList({List<RoleListModel>? values}) async {
    list.clear();
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getMasterList();

    if (res is List) {
      for (final json in res) {
        list.add(RoleListModel.fromJson(json));
      }
    }
    if (values != null) {
      final mapData = mapItems(values);
      setData(mapData);
    }

    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }
}
