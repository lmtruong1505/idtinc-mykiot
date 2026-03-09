import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/branch/bloc/branch_management_bloc/branch_management_bloc.dart';
import 'package:pharmago/presentation/features/branch/page_v2/companents/tab_detail/tab_info.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../config/role/check_role_per.dart';
import '../../../config/role/permission/index.dart';
import '../../../config/role/role_enum.dart';
import '../../../features_v2/blocs/menu/menu_company_bloc.dart';
import '../../../features_v2/blocs/state/init_state.dart';
import '../../../features_v2/screens/event/components/tab_list.dart';
import '../../company/cubit/action_company_bloc.dart';
import '../../company/screen_v2/components/menu_action_dialog.dart';
import '../../company/screen_v2/components/menu_popup.dart';
import '../bloc/branch_detail_bloc/branch_detail_bloc.dart';
import '../bloc/branch_detail_bloc/branch_detail_state.dart';
import 'companents/tab_detail/tab_order.dart';
import 'companents/tab_detail/tab_staff.dart';

@RoutePage()
class DetailBranchV2Page extends StatefulWidget {
  final int? id;
  const DetailBranchV2Page({
    super.key,
    required this.id,
  });

  @override
  State<DetailBranchV2Page> createState() => _DetailBranchV2PageState();
}

class _DetailBranchV2PageState extends State<DetailBranchV2Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bloc = getIt<BranchDetailBloc>();
  final actionBloc = ActionCompanyBloc();
  int get id => widget.id ?? getCompanyId!;
  bool get isAdminBranch =>
      isAdmin ||
      checkRole(RoleBaseEnum.ADMINBR) ||
      checkRole(RoleBaseEnum.MANAEBR);

  bool get isEdit => isAdmin && checkPermission(PerBranchEnum.EDIT.code);

  bool get isDelete => isAdmin && checkPermission(PerBranchEnum.DELETE.code);

  bool get isBlock => isAdmin && checkPermission(PerBranchEnum.ACTIVE.code);

  bool get LIST_ORDER =>
      isAdminBranch && checkPermission(PerBranchEnum.LIST_ORDER.code);

  bool get LIST_APPOINTMENT =>
      isAdminBranch && checkPermission(PerBranchEnum.LIST_APPOINTMENT.code);

  bool get LIST_EMPLOYEE =>
      isAdminBranch && checkPermission(PerBranchEnum.LIST_EMPLOYEE.code);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    bloc.init(id);
    context.read<ListRoleBloc>().init(companyId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionCompanyBloc, CubitState>(
      bloc: actionBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            getIt<BranchManagementBloc>().getList();
            context.read<MenuCompanyBloc>().getCompanyMenu();
            if (state.data == 'remove') {
              context.router.popUntil(
                (route) => route.settings.name == ListBranchV2Route.name,
              );
            } else {
              bloc.init(id);
            }
          },
        );
      },
      child: BlocBuilder<BranchDetailBloc, BranchDetailState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bg_primary,
            appBar: AppBarCustom(
              title: 'Quản lý cơ sở',
              subTitle: state.company?.name,
              actions: bloc.state.company?.id != null
                  ? [
                      _buildMenu(),
                      16.width,
                    ]
                  : null,
            ),
            body: _buildBody(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (bloc.state.isLoading) {
      return const BaseLoading();
    }
    if (bloc.state.company?.id == null) {
      return Center(
        child: EmptyContainer(
          msg: bloc.state.message,
        ),
      );
    }
    if (_tabTitles.length == 1) {
      return TabInfoDetailBranch(
        company: bloc.state.company!,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTab(),
        TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TabInfoDetailBranch(
              company: bloc.state.company!,
            ),
            if (LIST_EMPLOYEE)
              TabStaff(
                id: id,
                detailBloc: bloc,
                isActive: bloc.state.company?.status ?? false,
              ),
            if (LIST_ORDER)
              TabOrderBranch(
                id: id,
              ),
            if (LIST_APPOINTMENT)
              TabListEvent(
                companyId: id,
                isAdd: false,
              ),
          ],
        ).expanded(),
      ],
    );
  }

  MenuPopupWorkSpace _buildMenu() {
    return MenuPopupWorkSpace(
      onTap: (value) {
        if (value == StatusMenuWorkspace.edit) {
          context.pushRoute(
            CreateWorkspaceRoute(
              company: bloc.state.company!,
              type: TypeCreateCompany.branch,
            ),
          );
          return;
        }
        menuActionDialog(
          context,
          value: value,
          title: bloc.state.company?.name ?? '',
          type: TypeCreateCompany.branch,
          confirm: () {
            context.pop();
            if (value == StatusMenuWorkspace.remove) {
              actionBloc.remove(id);
              return;
            }
            if (value == StatusMenuWorkspace.active) {
              actionBloc.setActive(id, true);
              return;
            }
            if (value == StatusMenuWorkspace.unActive) {
              actionBloc.setActive(id, false);
              return;
            }
          },
        );
      },
      isActive: bloc.state.company?.status == true,
      isEdit: isEdit,
      isDelete: isDelete,
      isStatus: isBlock,
      isDetail: true,
      child: IconBtn(
        backgroundColor: AppColors.bg_primary,
        icon: const Icon(
          Icons.more_vert,
          size: 15,
        ),
      ),
    );
  }

  Container _buildTab() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border_tertiary)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.border_brandSolid,
        labelColor: AppColors.text_brand_primary_variant1,
        labelStyle: AppStyle.bodyBsMedium,
        unselectedLabelColor: AppColors.text_tertiary,
        unselectedLabelStyle: AppStyle.bodyBsRegular,
        labelPadding: 16.padingHor,
        tabs: List.generate(
          _tabTitles.length,
          (index) => Tab(
            text: _tabTitles[index],
          ),
        ),
      ),
    );
  }

  List<String> get _tabTitles => [
        'Thông tin cơ bản',
        if (LIST_EMPLOYEE) 'Nhân viên',
        if (LIST_ORDER) 'Đơn hàng',
        if (LIST_APPOINTMENT) 'Lịch hẹn',
      ];
}
