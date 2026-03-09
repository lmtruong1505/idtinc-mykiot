import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/components/widgets/empty_view.dart';
import '../../../../config/role/check_role_per.dart';
import '../../../../config/role/permission/index.dart';
import '../../bloc/branch_management_bloc/branch_management_bloc.dart';
import 'items/item_branch_v2.dart';
import '../../../../../shared/components/widgets/title_add.dart';

class TabBranch extends StatefulWidget {
  const TabBranch({super.key});

  @override
  State<TabBranch> createState() => _TabBranchState();
}

class _TabBranchState extends State<TabBranch> {
  final bloc = getIt<BranchManagementBloc>();
  final sroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.init();
    sroll.onMore(
      () {
        bloc.getList(isMore: true);
      },
    );
  }

  bool get isCreateList =>
      isAdmin && checkPermission(PerBranchEnum.CREATE.code);

  void createBranch() {
    context.pushRoute(
      CreateWorkspaceRoute(
        type: TypeCreateCompany.branch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchManagementBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return LoadMoreListBloc(
          state: state,
          padding: 16.pading,
          controller: sroll,
          separatorBuilder: const Divider(
            height: 0,
            color: AppColors.border_tertiary,
          ),
          itemBuilder: (context, item, index) => ItemBranchV2(
            company: bloc.list[index],
          ),
          list: bloc.list,
          height: 200,
          emptyViewAll: _emptyView(),
          isEmptyAll: state.isFirst,
          headerView: _buildFillter(),
        );
      },
    );
  }

  bool get isEmptyList => bloc.list.isEmpty && bloc.state.isFirst;

  bool get drugstoreEmpty =>
      bloc.branchType == bloc.branchTypes[0] &&
      bloc.countDrugstore == 0 &&
      bloc.state.isFirst;

  bool get clinicEmpty =>
      bloc.branchType == bloc.branchTypes[1] &&
      bloc.countClinic == 0 &&
      bloc.state.isFirst;

  Function()? get funCreate => isCreateList ? createBranch : null;

  Widget _emptyView() {
    return EmptyComfirm(
      text: 'Chưa có cơ sở',
      labelBtn: 'Thêm cơ sở',
      suffixIcon: const Icon(
        Icons.add,
        size: 17,
        color: AppColors.bg_primary,
      ),
      svgAsset: Assets.iconsBranch,
      onPressed: funCreate,
    );
  }

  Widget _buildFillter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputV2(
          hintText: 'Nhập tên cơ sở',
          radius: 40,
          controller: bloc.searchController,
          onConfirm: (p0) => bloc.searchList(),
          contentPadding: 12.padingHor,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.input_iconDefault,
          ),
          suffixIcon: InkWell(
            onTap: () {
              bloc.searchController.clear();
              bloc.searchList();
            },
            child: const Icon(
              Icons.close,
              color: AppColors.fg_quaternary,
            ),
          ),
        ).size(height: 40),
        Row(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: 16.padingVer,
              child: Row(
                children: List.generate(
                  bloc.listStatus.length,
                  (index) {
                    return ChipCustom(
                      onTap: () {
                        bloc.status = bloc.listStatus[index];
                      },
                      isActive: bloc.status == bloc.listStatus[index],
                      color: bloc.status == bloc.listStatus[index]
                          ? AppColors.ultility_brand_60
                          : AppColors.ultility_gray_60,
                      title: '${bloc.listStatus[index].title} '
                          '${bloc.statusCount[index] > 0 ? '(${bloc.statusCount[index]})' : ''}',
                    ).padding(12.padingRight);
                  },
                ),
              ),
            ).expanded(),
            16.width,
            if (bloc.status != null)
              InkWell(
                onTap: () {
                  bloc.status = null;
                },
                child: Container(
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    'Bỏ lọc',
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_brand_ghost_textDefault,
                    ),
                  ),
                ),
              ),
          ],
        ),
        TitleAdd(
          labelButton: 'Thêm cơ sở',
          onPressed: funCreate,
        ),
        const Divider(
          height: 0,
          color: AppColors.border_tertiary,
        ),
      ],
    );
  }
}
