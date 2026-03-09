import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/bts_filter_emp.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/item_employee.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/label_button.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/empty_view.dart';
import '../../../../shared/components/widgets/search_filter.dart';
import '../../../base/loading.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/employee/emp_management_bloc.dart';
import '../../blocs/state/init_state.dart';

@RoutePage()
class EmpManagementPage extends StatefulWidget {
  const EmpManagementPage({super.key});

  @override
  State<EmpManagementPage> createState() => _EmpManagementState();
}

class _EmpManagementState extends State<EmpManagementPage> {
  final myBloc = EmpManagementBloc();
  final scroll = ScrollController();
  final textCtrl = TextEditingController();

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
        title: 'Quản lý nhân viên',
        leadingText: 'Trở về',
      ),
      body: _buildBody(),
    );
  }

  Container _buildBody() {
    return Container(
      padding: 16.padingHor + 16.padingTop,
      child: BlocBuilder<EmpManagementBloc, CubitState>(
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
                  labelBtn: 'Thêm nhân viên',
                  text: 'Chưa có nhân viên',
                  onPressed: assign,
                  svgAsset: Assets.iconsIcEmpty2,
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

  Widget _buildSearchAndFilter() {
    return SearchFilterCustom(
      hintText: 'Tìm tên, số điện thoại, mã',
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
          BtsFilterEmp(
            status: myBloc.status,
            role: myBloc.role,
            branch: myBloc.branch,
            onChange: ({status, role, branch}) {
              myBloc.changeFilter(
                status: status,
                role: role,
                branch: branch,
              );
            },
          ),
        );
      },
    );
  }

  Column _buidHeaderList() {
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
              label: 'Thêm nhân viên',
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

  Widget _buildList() {
    if (myBloc.state.status == BlocStatus.loading && myBloc.page == 1) {
      return const BaseLoading();
    }
    if (myBloc.list.isEmpty) {
      return EmptyComfirm(
        labelBtn: 'Thêm nhân viên',
        text: 'Danh sách nhân viên trống',
        onPressed: assign,
        svgAsset: Assets.iconsIcEmpty2,
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
            onTap: () => context.router.push(
              EmpInformationRoute(
                id: myBloc.list[index].id ?? -1,
                onRefresh: () {
                  myBloc.getList();
                },
              ),
            ),
            child: ItemEmployee(
              model: myBloc.list[index],
            ),
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
    context.pushRoute(const AssignEmployeeRoute()).then((value) {
      if (value != null && value is bool && value) {
        myBloc.getList();
      }
    });
  }
}
