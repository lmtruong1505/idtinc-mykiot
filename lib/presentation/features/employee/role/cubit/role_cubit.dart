import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_state.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/item_entity.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/role_entity.dart';
import 'package:pharmago/presentation/features/employee/role/domain/usecase/role_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../employee/domain/usecase/employee_list_use_case.dart';

@injectable
class RoleCubit extends Cubit<RoleState> {
  RoleCubit(
    this._useCase,
    this._employeeListUseCase,
  ) : super(const RoleState());

  final RoleUseCase _useCase;
  final EmployeeListUseCase _employeeListUseCase;
  final entityILC = InfiniteListController<RoleEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<List<RoleEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];

    final list = await _useCase.getList(company, state.search, page);
    emit(state.copyWith(total: list.length));
    return list;
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) Navigator.of(context).pop();
    final role = await _useCase.getDetail(id);
    emit(state.copyWith(role: role.copyWith(company: company!.toString())));
    final input = EmployeeListInput(
        company: company, limit: 20, page: 0, search: state.search);
    final list = await _employeeListUseCase.execute(input);
    emit(state.copyWith(employees: list.response.data ?? []));
    final Map<ItemEntity, List<ItemEntity>> optionRoles = {};
    for (final item in role.items) {
      final cur = item.copyWith(checked: item.items.every((e) => e.checked));
      if (!optionRoles.containsKey(cur)) {
        optionRoles[cur] = [];
      }
      optionRoles[cur] = cur.items;
    }
    final sortedRoles = Map.fromEntries(
      optionRoles.entries.toList()
        ..sort((a, b) => a.key.title.compareTo(b.key.title)),
    );
    emit(state.copyWith(optionRoles: sortedRoles));
  }

  void changeSearch(String value) {
    emit(state.copyWith(search: value));
    entityILC.onRefresh();
  }

  void changeCode(String code) {
    emit(state.copyWith(role: state.role.copyWith(code: code)));
  }

  void changeTitle(String title) {
    emit(state.copyWith(role: state.role.copyWith(title: title)));
  }

  void changeNote(String note) {
    emit(state.copyWith(role: state.role.copyWith(note: note)));
  }

  void changeOption(bool checked, String code) {
    final optionSelected = List<String>.from(state.optionSelected);
    if (checked) {
      optionSelected.add(code);
    } else {
      optionSelected.remove(code);
    }
    emit(state.copyWith(optionSelected: optionSelected));
  }

  void create(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, 'Xác nhận tạo vai trò??', () async {
      DialogUtils.showLoadingDialog(context, 'Đang tạo vui lòng đợi!');
      final res = await _useCase.create(state.role, state.optionSelected);
     
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Tạo vai trò thành công', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Tạo vai trò thất bại');
      }
    });
  }

  void update(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, 'Xác nhận chỉnh sủa vai trò??', () async {
      DialogUtils.showLoadingDialog(context, 'Đang lưu vui lòng đợi!');
      final res = await _useCase.update(state.role, state.optionSelected);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Cập nhật vai trò thành công', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Cập nhật vai trò thất bại');
      }
    });
  }

  void delete(BuildContext context, int id) {
    DialogUtils.showDialogWithTitleAndOptionButton(context,
        'Bạn có chắc chắn muốn xóa vai trò này?\nThao tác không thể hoàn lại',
        () async {
      DialogUtils.showLoadingDialog(context, 'Đang xoá vai trò vui lòng đợi!');
      final res = await _useCase.delete(id);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Xoá vai trò thành công', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Xoá vai trò thất bại');
      }
    });
  }

  void changeChildCheckbox(ItemEntity item, ItemEntity subItem) {
    final optionRoles =
        Map<ItemEntity, List<ItemEntity>>.from(state.optionRoles);
    late ItemEntity itemChange;
    if (optionRoles.containsKey(item)) {
      final list = List<ItemEntity>.from(optionRoles[item]!);
      optionRoles.remove(item);
      if (list.contains(subItem)) {
        list[list.indexOf(subItem)] =
            subItem.copyWith(checked: !subItem.checked);
        itemChange =
            list[list.indexOf(subItem.copyWith(checked: !subItem.checked))];
      }
      item = item.copyWith(checked: list.every((e) => e.checked));
      optionRoles[item] = list;
    }
    final sortedRoles = Map.fromEntries(
      optionRoles.entries.toList()
        ..sort((a, b) => a.key.title.compareTo(b.key.title)),
    );
    emit(
      state.copyWith(
        optionRoles: sortedRoles,
        role: state.role.copyWith(
          items: optionRoles.keys.map((e) {
            final items = optionRoles[e]!;
            return e.copyWith(items: items);
          }).toList(),
        ),
      ),
    );
    updateRoleEntity(state.role, [
      {itemChange.code: itemChange.checked},
    ]);
  }

  void changeRootCheckbox(ItemEntity item) {
    final optionRoles =
        Map<ItemEntity, List<ItemEntity>>.from(state.optionRoles);
    late List<Map<String, bool>> itemsChange;
    if (optionRoles.containsKey(item)) {
      final list = List<ItemEntity>.from(optionRoles[item]!);
      optionRoles.remove(item);
      for (final it in list) {
        list[list.indexOf(it)] = it.copyWith(checked: !item.checked);
      }
      item = item.copyWith(checked: !item.checked);
      optionRoles[item] = list;
      itemsChange = list.map((e) => {e.code: e.checked}).toList();
    }
    itemsChange = [
      ...itemsChange,
      {item.code: item.checked}
    ];

    final sortedRoles = Map.fromEntries(
      optionRoles.entries.toList()
        ..sort((a, b) => a.key.title.compareTo(b.key.title)),
    );

    emit(
      state.copyWith(
        optionRoles: sortedRoles,
        role: state.role.copyWith(
          items: optionRoles.keys.map((e) {
            final items = optionRoles[e]!;
            return e.copyWith(items: items);
          }).toList(),
        ),
      ),
    );
    updateRoleEntity(state.role, itemsChange);
  }

  void updateRoleEntity(RoleEntity role, List<Map<String, bool>> itemsChange) {
    _useCase.updateCheckBox(role, itemsChange);
  }
}
