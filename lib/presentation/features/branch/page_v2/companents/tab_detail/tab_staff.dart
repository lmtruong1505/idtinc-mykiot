import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/branch/bloc/branch_staff_bloc/staff_action_branch_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../gen/flutter_assets.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../config/role/check_role_per.dart';
import '../../../../../config/role/permission/index.dart';
import '../../../../../features_v2/blocs/state/init_state.dart';
import '../../../bloc/branch_detail_bloc/branch_detail_bloc.dart';
import '../../../bloc/branch_management_bloc/branch_management_bloc.dart';
import '../../../bloc/branch_staff_bloc/list_staff_branch_bloc.dart';
import '../bottom_sheets/bts_filter_staff.dart';
import '../items/item_staff.dart';
import '../../../../../../shared/components/widgets/title_add.dart';

class TabStaff extends StatefulWidget {
  final int id;
  final bool isActive;
  final BranchDetailBloc detailBloc;

  const TabStaff({
    super.key,
    required this.id,
    required this.detailBloc,
    this.isActive = false,
  });

  @override
  State<TabStaff> createState() => _TabStaffState();
}

class _TabStaffState extends State<TabStaff> {
  final bloc = getIt<ListStaffBranchBloc>();
  final staffActionBloc = StaffActionBranchBloc();

  bool get isAdd => isAdmin && checkPermission(PerBranchEnum.ADD_EMPLOYEE.code);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.company = widget.id;
  }

  Function()? get funAdd => widget.isActive && isAdd ? addStaff : null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StaffActionBranchBloc, CubitState>(
          bloc: staffActionBloc,
          listener: (context, state) {
            CheckStateBloc.check(
              context,
              state,
              isShowMsg: true,
              success: () {
                getIt<BranchManagementBloc>().getList();
                bloc.getList();
                int count =
                    widget.detailBloc.state.company?.totalEmployeesAll ?? 0;
                if (state.data == 'remove') {
                  count -= state.total;
                  widget.detailBloc.updateCountStaff(count);
                }
              },
            );
          },
        ),
      ],
      child: BlocBuilder<ListStaffBranchBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          if (bloc.list.isEmpty &&
              bloc.isFirst &&
              state.status == BlocStatus.loading) {
            return const Center(
              child: BaseLoading(),
            );
          }
          if (bloc.list.isEmpty &&
              bloc.isFirst &&
              state.status == BlocStatus.success) {
            return EmptyComfirm(
              labelBtn: 'Thêm nhân viên',
              text: 'Chưa có nhân viên',
              onPressed: funAdd,
              svgAsset: Assets.svgPerson,
            );
          }
          return Scaffold(
            bottomNavigationBar: isAdmin ? _buildRemove() : null,
            body: LoadMoreListBloc(
              list: bloc.list,
              state: state,
              height: 200,
              headerView: _buildFillter(),
              separatorBuilder: const Divider(
                height: 0,
                color: AppColors.border_tertiary,
              ),
              itemBuilder: (context, item, index) => ItemStaffBranch(
                item: item,
                onTap: () => bloc.selectStaff(index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRemove() {
    return ExpandedSection(
      isSelected: bloc.staffIds.isNotEmpty && widget.isActive,
      child: Row(
        children: [ 
          Text(
            'Đã chọn ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          Text(
            '(${bloc.staffIds.length})',
            style: AppStyle.headingMd,
          ),
          const Spacer(),
          LabelButton(
            onPressed: () {
              staffActionBloc.removeStaff(
                id: widget.id,
                staffIds: bloc.staffIds,
              );
            },
            label: 'Xóa khỏi cơ sở',
            backgroundColor: AppColors.button_negative_alpha_backgroundDefault,
            labelStyle: AppStyle.bodyMdMedium.copyWith(
              color: AppColors.button_negative_alpha_textDefault,
            ),
          ),
        ],
      ).container(
        padding:
            12.padingTop + 16.padingHor + context.padding.bottom.padingBottom,
      ),
    ).container(
      padding: 0.pading,
      boxShadow: AppShadows.elevator3,
    );
  }

  Widget _buildFillter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchFilterCustom(
          onChange: (p0) => bloc.changeSearch(p0),
          isActive: bloc.role != null,
          onTap: () async {
            final roles = context.read<ListRoleBloc>().list;
            final int index = roles.indexWhere(
              (element) => element.id == bloc.role,
            );
            final res = await context.bottomSheet(
              BtsFilterStaffBranch(
                value: index < 0 ? 0 : index,
              ),
            );
            if (res is int) {
              bloc.role = res == 0 ? null : roles[res - 1].id;
            }
          },
          hintText: 'Tìm tên, số điện thoại, mã',
        ),
        24.height,
        TitleAdd(
          labelButton: 'Thêm nhân viên',
          onPressed: funAdd,
        ),
        const Divider(
          height: 0,
          color: AppColors.border_tertiary,
        ),
      ],
    );
  }

  void addStaff() {
    context.pushRoute(AddStaffBranchV2Route(id: widget.id)).then(
      (value) {
        if (value is int && value > 0) {
          getIt<BranchManagementBloc>().getList();
          int count = widget.detailBloc.state.company?.totalEmployeesAll ?? 0;
          count += value;
          widget.detailBloc.updateCountStaff(count);
          bloc.getList();
        }
      },
    );
  }
}
