import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/input/app_input.dart';
import '../../../../../../shared/components/widgets/load_more_bloc.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../features_v2/blocs/employee/emp_management_bloc.dart';
import '../../../../../features_v2/blocs/state/init_state.dart';
import '../../../../../features_v2/models/employee/pre_emp_model.dart';
import '../items/item_staff_add_branch_v2.dart';

class BtsListStaff extends StatefulWidget {
  final PreEmpModel? value;
  const BtsListStaff({
    super.key,
    this.value,
  });

  @override
  State<BtsListStaff> createState() => _BtsListStaffState();
}

class _BtsListStaffState extends State<BtsListStaff> {
  final staffBloc = EmpManagementBloc();
  final scrollStaff = ScrollController();
  PreEmpModel? value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    staffBloc.getList();
    value = widget.value;
    scrollStaff.onMore(
      () => staffBloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Chọn quản lý',
      controller: scrollStaff,
      padding: EdgeInsets.zero,
      onCancel: () {
        value = null;
        setState(() {});
      },
      onConfirm: () {
        context.pop(result: value);
      },
      child: BlocBuilder<EmpManagementBloc, CubitState>(
        bloc: staffBloc,
        builder: (context, state) {
          return LoadMoreListBloc(
            state: state,
            list: staffBloc.list,
            padding: 0.pading,
            headerView: _buildSearch(),
            itemBuilder: (context, item, index) {
              return ItemStaffAddBranchV2(
                onTap: () {
                  value = item;
                  setState(() {});
                },
                isActive: item.id == value?.id,
                staff: item,
                isRadio: true,
              );
            },
            separatorBuilder: const Divider(
              height: 0,
              color: AppColors.border_tertiary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInputV2(
          hintText: 'Tìm kiếm tên, số điện thoại nhân viên',
          onChanged: staffBloc.changeSearch,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.input_iconDefault,
          ),
          borderColor: AppColors.input_borderDefault,
          radius: 40,
          contentPadding: 12.padingHor,
        ).size(height: 40).padding(16.padingHor),
        24.height,
        Row(
          children: [
            Text(
              'Danh sách nhân viên',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            8.width,
            const Divider(
              height: 0,
              color: AppColors.border_tertiary,
            ).expanded(),
          ],
        ).padding(28.padingHor + 8.padingBottom),
      ],
    );
  }
}
