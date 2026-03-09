import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/features_v2/blocs/role_v2/role_management_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/role_v2/components/role_list_item.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../shared/components/button/label_button.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/empty_view.dart';
import '../../../../shared/components/widgets/search_filter.dart';
import '../../../base/loading.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../router/router.gr.dart';
import '../../blocs/enum/bloc_status.dart';
import '../../blocs/state/cubit_state.dart';
import 'components/bts_filter_roles.dart';

@RoutePage()
class RoleManagerV2Page extends StatefulWidget {
  const RoleManagerV2Page({super.key});

  @override
  State<RoleManagerV2Page> createState() => _RoleManagerV2PageState();
}

class _RoleManagerV2PageState extends State<RoleManagerV2Page> {
  final myBloc = RoleManagementBloc();
  final scroll = ScrollController();
  final textCtrl = TextEditingController();
  bool canAdd = isOwnerWsCsMn && checkPermission(PerRoleEnum.CREATE.code);
  bool canViewDetail = isOwnerWsCsMn && checkPermission(PerRoleEnum.DETAIL.code);
  @override
  void initState() {
    scroll.onMore(
      () => myBloc.getList(isMore: true),
    );
    myBloc.getList();
    super.initState();
  }

  @override
  void dispose() {
    myBloc.close();
    scroll.dispose();
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_primary,
      appBar: AppBarTitleCenter(
        title: 'Quản lý vai trò',
        leadingText: 'Trở về',
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      padding: 16.padingHor + 16.padingTop,
      child: BlocBuilder<RoleManagementBloc, CubitState>(
        bloc: myBloc,
        builder: (context, state) {
          if (state.status == BlocStatus.loading && myBloc.count == 0) {
            return const BaseLoading();
          }
          if (myBloc.count == 0) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EmptyComfirm(
                  labelBtn: 'Thêm vai trò',
                  text: 'Chưa có vai trò',
                  onPressed: assign,
                  svgAsset: 'assets/icons/ic_group.svg',
                  suffixIcon: const Icon(
                    Icons.add,
                    color: AppColors.button_brand_solid_iconDefault,
                    size: 20,
                  ),
                ),
              ],
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              myBloc.getList();
            },
            child: SingleChildScrollView(
              controller: scroll,
              child: Column(
                children: [
                  _buildSearchAndFilter(),
                  24.height,
                  _buidHeaderList(),
                  8.height,
                  _buildList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildSearchAndFilter() {
    return SearchFilterCustom(
      hintText: 'Nhập tên vai trò',
      value: myBloc.search,
      onChange: myBloc.changeSearch,
      isActive: myBloc.isSort,
      controller: textCtrl,
      clear: () {
        myBloc.changeSearch(null);
        textCtrl.clear();
      },
      onTap: () {
        context.bottomSheet(
          BtsFilterRoles(
            position: myBloc.position,
            onChange: myBloc.changePosition,
          ),
        );
      },
    );
  }

  _buidHeaderList() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Tất cả',
              style: AppStyle.bodyBsMedium
                  .copyWith(color: AppColors.text_tertiary),
            ).expanded(),
            12.width,
            LabelButton(
              onPressed: assign,
              label: 'Thêm vai trò',
              backgroundColor: AppColors.button_neutral_alpha_backgroundDefault,
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.button_neutral_alpha_textDefault,
              ),
              spaceIcon: 4,
              suffixIcon: const Icon(
                Icons.add,
                color: AppColors.button_neutral_alpha_textDefault,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildList() {
    if (myBloc.state.status == BlocStatus.loading && myBloc.page == 1) {
      return const BaseLoading();
    }
    if (myBloc.list.isEmpty) {
      return EmptyComfirm(
        labelBtn: 'Thêm vai trò',
        text: 'Danh sách nhân viên trống',
        onPressed: assign,
        svgAsset: 'assets/icons/ic_group.svg',
        suffixIcon: const Icon(
          Icons.add,
          color: AppColors.button_brand_solid_iconDefault,
          size: 20,
        ),
      );
    }
    return Column(
      children: [
        ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => InkWell(
            onTap: canViewDetail ? () {
              context.router.push(
                DetailRoleV2Route(
                  id: myBloc.list[index].id ?? 0,
                  refresh: myBloc.getList,
                ),
              ).then((value) {
                if (value != null && value == true) {
                  myBloc.getList();
                }
              });
            } : context.permissionDenied(),
            child: RoleListItem(model: myBloc.list[index]),
          ),
          separatorBuilder: (context, index) => 0.height,
          itemCount: myBloc.list.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
        SizedBox(
          height: 50,
          child: myBloc.state.status == BlocStatus.loading
              ? const BaseLoading(
                  height: 50,
                )
              : null,
        ),
      ],
    );
  }

  void assign() {
    if(!canAdd) {
      context.permissionError()();
      return;
    }
    context
        .pushRoute(
      CreateRoleV2Route(),
    )
        .then((value) {
      if (value != null && value == true) {
        myBloc.getList();
      }
    });
  }
}
