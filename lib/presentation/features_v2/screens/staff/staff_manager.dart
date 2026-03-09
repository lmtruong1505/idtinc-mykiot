import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/staff_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/staff/components/item_staff.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../blocs/enum/enum_bloc.dart';

@RoutePage()
class StaffManagerPage extends StatefulWidget {
  const StaffManagerPage({super.key});

  @override
  State<StaffManagerPage> createState() => _StaffManagerPageState();
}

class _StaffManagerPageState extends State<StaffManagerPage> {
  late StaffManagerBloc bloc;
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read<StaffManagerBloc>();
    bloc.init();
    bloc.getList();
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.greyF5,
      appBar: const BaseAppBar(title: 'Quản lý nhân viên'),
      body: RefreshIndicator(
        onRefresh: () async {
          await bloc.getList();
        },
        child: SingleChildScrollView(
          padding: 16.pading,
          controller: scroll,
          child: BlocBuilder<StaffManagerBloc, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainButtonV2(
                    onTap: () {
                      context.pushRoute(CreateOrUpdateStaffRoute());
                      //context.pushRoute(EmployeeUpdateRoute());
                    },
                    radius: 8,
                    title: 'Thêm mới',
                  ),
                  16.height,
                  AppInputV2(
                    hintText: 'Tìm kiếm theo tên, sđt nhân viên',
                    radius: 8,
                    backgroundColor: ColorApp.white,
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    onChanged: (p0) => bloc.search(p0),
                  ),
                  16.height,
                  _buildStatus(),
                  LoadListPage(
                    state: state,
                    height: 200,
                    listEmpty: bloc.list.isEmpty,
                    child: ListView.separated(
                      padding: 16.padingVer,
                      itemBuilder: (context, index) => ItemStaff(
                        staff: bloc.list[index],
                      ),
                      separatorBuilder: (context, index) => 16.height,
                      itemCount: bloc.list.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                  context.padding.bottom.height,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return ListView.separated(
      itemBuilder: (context, index) => BtnStatusCount(
        isActive: AccountStatusEnum.values[index] == bloc.active,
        title: AccountStatusEnum.values[index].name,
        count: bloc.counts[index],
        onPressed: () {
          bloc.setActive(AccountStatusEnum.values[index]);
        },
      ),
      separatorBuilder: (context, index) => 8.width,
      itemCount: AccountStatusEnum.values.length,
      scrollDirection: Axis.horizontal,
    ).size(height: 35);
  }
}
