import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/branch/page_v2/companents/items/item_staff_add_branch_v2.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/progess_stepper.dart';
import '../../../base/v2/expanded_section.dart';
import '../../../features_v2/blocs/employee/emp_management_bloc.dart';
import '../bloc/branch_staff_bloc/add_staff_branch_bloc.dart';
import '../bloc/branch_staff_bloc/staff_action_branch_bloc.dart';
import 'companents/items/item_staff_choose_role.dart';

@RoutePage()
class AddStaffBranchV2Page extends StatefulWidget {
  final int id;
  const AddStaffBranchV2Page({
    super.key,
    required this.id,
  });

  @override
  State<AddStaffBranchV2Page> createState() => _AddStaffBranchV2PageState();
}

class _AddStaffBranchV2PageState extends State<AddStaffBranchV2Page> {
  final search = TextEditingController();
  final bloc = AddStaffBranchBloc();

  final staffBloc = EmpManagementBloc();
  final staffActionBloc = StaffActionBranchBloc();

  final scrollStaff = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    staffBloc.getList();

    scrollStaff.onMore(
      () => staffBloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffActionBranchBloc, CubitState>(
      bloc: staffActionBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            context.pop(result: state.total);
          },
        );
      },
      child: Scaffold(
        appBar: AppBarTitleCenter(
          title: 'Thêm nhân viên',
          leadingText: 'Trở về',
        ),
        bottomNavigationBar: _buildBtnNav(),
        body: BlocBuilder<AddStaffBranchBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStep(),
                if (bloc.indexTab == 0)
                  AppInputV2(
                    hintText: 'Tìm kiếm tên, số điện thoại nhân viên',
                    radius: 40,
                    controller: search,
                    onChanged: staffBloc.changeSearch,
                    contentPadding: 12.padingHor,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.input_iconDefault,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        search.clear();
                        staffBloc.changeSearch('');
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.fg_quaternary,
                      ),
                    ),
                  ).size(height: 40).padding(16.pading),
                Text(
                  'Tất cả',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ).padding(28.padingHor + 8.padingBottom),
                const Divider(
                  height: 0,
                  color: AppColors.border_tertiary,
                ).padding(16.padingHor),
                (bloc.indexTab == 0 ? _buildList() : _buildItemChoose())
                    .expanded(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBtnNav() {
    return BlocBuilder<AddStaffBranchBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return ExpandedSection(
          isSelected: bloc.listStaff.isNotEmpty,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Đã chọn ',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                  Text(
                    '(${bloc.listStaff.length})',
                    style: AppStyle.headingMd,
                  ),
                ],
              ),
              10.height,
              DoubleButton(
                confirmText: bloc.indexTab == 0 ? 'Tiếp tục' : 'Xác nhận',
                cancelText: bloc.indexTab == 0 ? 'Huỷ bỏ' : 'Trở về',
                onCancel: () {
                  if (bloc.indexTab == 0) {
                    context.pop();
                    return;
                  }
                  bloc.indexTab = 0;
                },
                onConfirm: bloc.indexTab == 1 && bloc.checkRoleEmpty
                    ? null
                    : () {
                        if (bloc.indexTab == 1) {
                          staffActionBloc.addStaff(
                            id: widget.id,
                            list: bloc.listStaff,
                          );
                          return;
                        }
                        bloc.indexTab = 1;
                      },
              ),
            ],
          ).container(
            padding: 12.padingTop +
                16.padingHor +
                context.padding.bottom.padingBottom,
          ),
        );
      },
    ).container(
      padding: 0.pading,
      boxShadow: AppShadows.elevator3,
    );
  }

  Widget _buildItemChoose() {
    return ListView.separated(
      padding: 16.padingHor,
      itemBuilder: (context, index) => ItemStaffChooseRole(
        onTap: (roles) {
          bloc.updateRoles(index, roles);
        },
        remove: () {
          bloc.removeStaff(index);
        },
        item: bloc.listStaff[index],
      ),
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        color: AppColors.border_tertiary,
      ),
      itemCount: bloc.listStaff.length,
    );
  }

  Widget _buildList() {
    return BlocBuilder<EmpManagementBloc, CubitState>(
      bloc: staffBloc,
      builder: (context, state) {
        return LoadMoreListBloc(
          state: state,
          list: staffBloc.list,
          itemBuilder: (context, item, index) {
            return ItemStaffAddBranchV2(
              onTap: () {
                final ids = item.workingData.map((e) => e.workspaceId).toList();
                if (ids.contains(widget.id)) {
                  ToastCustom.show(
                    context,
                    title: 'Cảnh báo',
                    msg:
                        'Nhân viên đã được thêm vào cở sở. Vui lòng chọn nhân viên khác.',
                  );
                } else {
                  bloc.addStaff(item);
                }
              },
              isActive: bloc.staffIds.contains(item.id),
              staff: item,
            );
          },
          controller: scrollStaff,
          separatorBuilder: const Divider(
            height: 0,
            color: AppColors.border_tertiary,
          ),
        );
      },
    );
  }

  Widget _buildStep() {
    return ProgessStepper(
      steps: const [
        'Chọn nhân viên',
        'Chọn vai trò',
      ],
      current: bloc.indexTab,
    ).padding(16.padingVer + 32.padingHor);
  }
}
