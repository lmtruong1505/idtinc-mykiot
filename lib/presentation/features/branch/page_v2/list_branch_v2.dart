import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/branch/bloc/branch_management_bloc/branch_management_bloc.dart';
import 'package:pharmago/presentation/features/branch/page_v2/companents/tab_branch.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/button/tab_btn.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../config/app_style/init_app_style.dart';

@RoutePage()
class ListBranchV2Page extends StatefulWidget {
  const ListBranchV2Page({super.key});

  @override
  State<ListBranchV2Page> createState() => _ListBranchV2PageState();
}

class _ListBranchV2PageState extends State<ListBranchV2Page>
    with SingleTickerProviderStateMixin {
  final bloc = getIt<BranchManagementBloc>();
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bg_primary,
        appBar: AppBarTitleCenter(
          title: 'Quản lý cơ sở',
          leadingText: 'Trở về',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isCAD) _buildTabBar(),
            const TabBranch().expanded(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return BlocConsumer<BranchManagementBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        _tabController.animateTo(
          bloc.branchTypes.indexOf(bloc.branchType!),
        );
      },
      builder: (context, state) {
        return Container(
          height: 45,
          width: 200,
          padding: 20.padingHor,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border_tertiary),
            ),
          ),
          child: TabBar(
            labelStyle: AppStyle.bodyBsMedium.copyWith(height: 1.2),
            labelColor: AppColors.brand,
            unselectedLabelStyle: AppStyle.bodyBsRegular.copyWith(height: 1.2),
            unselectedLabelColor: AppColors.text_tertiary,
            indicatorColor: AppColors.border_brandSolid,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            controller: _tabController,
            onTap: (value) {
              bloc.changeBranchType(
                bloc.branchTypes[value],
              );
            },
            tabs: [
              Tab(
                child: TabBtn(
                  label: bloc.branchTypes[0].title,
                  count: bloc.countDrugstore,
                  color: bloc.branchTypes[0] == bloc.branchType
                      ? AppColors.ultility_brand_60
                      : null,
                ),
              ),
              Tab(
                child: TabBtn(
                  label: bloc.branchTypes[1].title,
                  count: bloc.countClinic,
                  color: bloc.branchTypes[1] == bloc.branchType
                      ? AppColors.ultility_brand_60
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
