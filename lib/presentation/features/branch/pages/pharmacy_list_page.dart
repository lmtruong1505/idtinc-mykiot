import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/features/branch/bloc/branch_management_bloc/branch_management_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/bloc_to_page.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../constants/spacing.dart';
import '../../../router/router.gr.dart';
import '../view/branch_view.dart';

class PharmacyListPage extends StatefulWidget {
  const PharmacyListPage({
    super.key,
    required this.myBloc,
  });

  final BranchManagementBloc myBloc;

  @override
  State<PharmacyListPage> createState() => _PharmacyListPageState();
}

class _PharmacyListPageState extends State<PharmacyListPage> {
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.myBloc.getList();
    scroll.onMore(
      () => widget.myBloc.getList(isMore: true),
    );
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchManagementBloc, CubitState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return Container(
          color: ColorApp.greyF5,
          child: Column(
            children: [
              MainButton(
                title: 'Thêm mới',
                event: () async {
                  await context.router.push(BranchCreateRoute());
                  widget.myBloc.getList();
                },
              )
                  .size(
                    width: double.infinity,
                  )
                  .padding(16.padingHor + 16.padingTop),
              16.height,
              AppInputSupport(
                hintText: 'Tìm kiếm theo tên',
                prefixIcon: const Icon(Icons.search_outlined),
                backgroundColor: ColorApp.white,
                controller: widget.myBloc.searchController,
                onChanged: (value) {
                  widget.myBloc.searchList();
                },
              ).padding(16.padingHor),
              // 16.height,
              // BlocBuilder<BranchManagementBloc, BranchManagementState>(
              //   builder: (context, state) {
              //     return _buildStatus().size(height: 40);
              //   },
              // ),
              _buildListBranch(state).expanded(),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildStatus() {
  //   return ListView.separated(
  //     scrollDirection: Axis.horizontal,
  //     itemBuilder: (context, index) => BtnStatusCount(
  //       onPressed: () {
  //         if (mounted) {
  //           widget.myBloc
  //               .selectFilterButton(widget.myBloc.state.statusBranchList[index]);
  //         }
  //
  //       },
  //       title: widget.myBloc.state.statusBranchList[index].toName,
  //       isActive: widget.myBloc.state.statusBranchList[index] ==
  //           widget.myBloc.state.statusBranch,
  //       count: 0,
  //     ),
  //     separatorBuilder: (context, index) => sp16.width,
  //     itemCount: widget.myBloc.state.statusBranchList.length,
  //   );
  // }

  Widget _buildListBranch(CubitState state) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.myBloc.getList();
      },
      child: LoadListPage(
        state: state,
        listEmpty: widget.myBloc.list.isEmpty,
        child: ListView.separated(
          padding: sp16.pading,
          controller: scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) => BranchView(
            company: widget.myBloc.list[index],
            onReload: () {
              widget.myBloc.getList();
            },
          ),
          separatorBuilder: (context, index) => sp16.height,
          itemCount: widget.myBloc.list.length,
        ).expanded(),
      ),
    );
  }
}
