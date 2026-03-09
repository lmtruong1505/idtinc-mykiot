import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/staff_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/components/bottom_sheet/bottom_sheet_user.dart';
import 'package:pharmago/presentation/features_v2/screens/staff/components/item_staff.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../blocs/role/list_role_bloc.dart';
import '../../../../blocs/role/role_bloc.dart';
import '../../../../models/role/detail_role_model.dart';

class TabStaffRole extends StatefulWidget {
  final DetailRoleModel model;
  const TabStaffRole({
    super.key,
    required this.model,
  });

  @override
  State<TabStaffRole> createState() => _TabStaffRoleState();
}

class _TabStaffRoleState extends State<TabStaffRole>
    with AutomaticKeepAliveClientMixin {
  final bloc = StaffManagerBloc();
  final addEmployeeRoleBloc = RoleBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc.setRole(widget.model.role?.id);
    scroll.onMore(
      () => bloc.getList(
        isMore: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<RoleBloc, CubitState>(
      bloc: addEmployeeRoleBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          success: () {
            bloc.getList();
            context.read<ListRoleBloc>().getList();
            context.pop();
          },
        );
      },
      child: SingleChildScrollView(
        padding: 16.pading,
        controller: scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppInputV2(
              hintText: 'Tìm kiếm tên, sđt nhân viên',
              backgroundColor: ColorApp.white,
              radius: 8,
              prefixIcon: const Icon(
                Icons.search,
              ),
              onChanged: bloc.search,
            ),
            16.height,
            MainButtonV2(
              onTap: () {
                context
                    .bottomSheet(
                  const BtsUser(
                    isCustomerOrDoctor: false,
                    multi: true,
                    title: 'Chọn nhân viên',
                  ),
                )
                    .then(
                  (value) {
                    if (value is List) {
                      addEmployeeRoleBloc.addEmployeeRole(
                        widget.model.role?.id ?? 0,
                        value as List<int>,
                      );
                    }
                  },
                );
              },
              radius: 8,
              title: 'Gắn nhân viên',
            ),
            16.height,
            BlocBuilder<StaffManagerBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                return LoadListPage(
                  state: state,
                  height: 200,
                  listEmpty: bloc.list.isEmpty,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) => ItemStaff(
                      staff: bloc.list[index],
                    ),
                    separatorBuilder: (context, index) => 16.height,
                    itemCount: bloc.list.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                );
              },
            ),
            context.padding.bottom.height,
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
