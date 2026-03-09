import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/role_item.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/app_input.dart';
import '../../../../../shared/utils/delay_callback.dart';
import '../../../../base/empty_container.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/role/list_role_bloc.dart';
import '../../../models/role/role_model.dart';

class BtsSelectRole extends StatefulWidget {
  const BtsSelectRole(
      {super.key,
      required this.id,
      required this.onSelected,
      required this.company});

  final List<int> id;
  final Function(List<RoleListModel>)? onSelected;
  final int company;

  @override
  State<BtsSelectRole> createState() => _BtsSelectRoleState();
}

class _BtsSelectRoleState extends State<BtsSelectRole> {
  late ListRoleBloc roleBloc;
  List<RoleListModel> roles = [];
  final delay = DelayCallBack(delay: 500.milliseconds);
  late Future<void> future;
  final textCtrl = TextEditingController();

  @override
  void initState() {
    roleBloc = context.read<ListRoleBloc>();
    future = load();
    super.initState();
  }

  Future<void> load() async {
    roleBloc.list.clear();
    await roleBloc.getList(company: widget.company);
    roles = roleBloc.list
        .where((element) => widget.id.contains(element.id))
        .toList();
  }

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, state) {
        return BgBts(
          label: 'Chọn vai trò',
          subChild: roles.isEmpty ? null : _buildCount(),
          cancelText: 'Hủy',
          confirmText: 'Xác nhận',
          onCancel: () {
            context.pop();
          },
          onConfirm: () {
            widget.onSelected?.call(roles);
            context.pop();
          },
          child: state.connectionState == ConnectionState.waiting
              ? const BaseLoading()
              : Column(
                  children: [
                    _buildSearch(),
                    16.height,
                    _buildList(),
                  ],
                ),
        );
      },
    );
  }

  _buildCount() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border_tertiary,
            width: 1,
          ),
        ),
      ),
      margin: 16.padingHor,
      padding: 12.padingTop + 8.padingBottom,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Đã chọn: ',
              style: AppStyle.bodyBsRegular
                  .copyWith(color: AppColors.text_tertiary),
            ),
            TextSpan(
              text: '(${roles.length})',
              style: AppStyle.headingMd,
            ),
          ],
        ),
      ),
    );
  }

  _buildSearch() {
    return AppInputV2(
      hintText: 'Tìm vai trò',
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      suffixIcon: InkWell(
        onTap: () {
          textCtrl.clear();
          roleBloc.getList(company: widget.company);
        },
        child: const Icon(
          Icons.clear_outlined,
          size: 16,
        ),
      ),
      controller: textCtrl,
      radius: 40,
      contentPadding: 12.padingHor,
      onChanged: (value) {
        delay.debounce(() {
          roleBloc.getList(searchSp: value, company: widget.company);
        });
      },
    ).size(height: 40);
  }

  _buildList() {
    return BlocBuilder<ListRoleBloc, CubitState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const Center(
            child: BaseLoading(),
          );
        }
        if (roleBloc.list.isEmpty) {
          return const EmptyContainer(
            msg: 'Không tìm thấy',
          );
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                final role = roleBloc.list[index];
                if (checkIfSelected(role.id ?? -1)) {
                  roles.removeWhere((element) => element.id == role.id);
                } else {
                  roles.add(role);
                }
                setState(() {});
              },
              child: RoleItem(
                role: roleBloc.list[index],
                isSelected: checkIfSelected(roleBloc.list[index].id ?? -1),
              ),
            );
          },
          separatorBuilder: (context, index) => 0.height,
          itemCount: roleBloc.list.length,
        );
      },
    );
  }

  bool checkIfSelected(int id) {
    return roles.indexWhere((element) => element.id == id) != -1;
  }
}
