import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/branch/view/basic_info_view.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../di/di.dart';
import '../bloc/branch_detail_bloc/branch_detail_bloc.dart';
import '../bloc/branch_detail_bloc/branch_detail_state.dart';
import '../view/appointment_info_view.dart';
import '../view/order_info_view.dart';
import '../view/staff_info_view.dart';

@RoutePage()
class BranchDetailPage extends StatefulWidget {
  const BranchDetailPage({super.key, required this.id});

  final int id;

  @override
  State<BranchDetailPage> createState() => _BranchDetailPageState();
}

class _BranchDetailPageState extends State<BranchDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final myBloc = getIt<BranchDetailBloc>();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..init(widget.id),
      lazy: false,
      child: BlocBuilder<BranchDetailBloc, BranchDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Chi tiết cơ sở',
                style: TextStyle(
                  color: ColorApp.black,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorApp.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                _buildMenu(),
              ],
              backgroundColor: ColorApp.greyF5,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Thông tin cơ bản'),
                  Tab(text: 'Thông tin nhân viên'),
                  Tab(text: 'Thông tin đơn hàng'),
                  Tab(text: 'Thông tin lịch hẹn'),
                ],
                indicatorColor: ColorApp.black,
                labelColor: ColorApp.black,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                BasicInfoView(
                  myBloc: myBloc,
                ),
                StaffInfoView(
                  id: widget.id,
                ),
                OrderInfoView(
                  id: widget.id,
                ),
                AppointmentInfoView(
                  idBranch: widget.id,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: Dimensions.sp8.radius,
      ),
      child: Padding(
        padding: Dimensions.sp16.pading,
        child: const Icon(
          Icons.more_vert_rounded,
          color: ColorApp.black,
        ),
      ),
      itemBuilder: (context) {
        return List.generate(
          MenuDetailBranch.values.length,
          (index) => PopupMenuItem(
            onTap: () {
              switch (MenuDetailBranch.values[index]) {
                case MenuDetailBranch.disable:
                  break;
                case MenuDetailBranch.active:  
                  break;
                case MenuDetailBranch.edit:
                  context.router
                      .push(BranchCreateRoute(company: myBloc.state.company));
                  break;
                case MenuDetailBranch.remove:
                  break;
              }
            },
            child: Text(
              MenuDetailBranch.values[index].name,
              textAlign: TextAlign.center,
              style: StyleApp.normal(),
            ),
          ),
        );
      },
    );
  }
}
