import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/staff_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/staff_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import 'components/detail/tab_event.dart';
import 'components/detail/tab_infor.dart';

@RoutePage()
class DetailStaffPage extends StatefulWidget {
  final int id;

  const DetailStaffPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailStaffPage> createState() => _DetailStaffPageState();
}

class _DetailStaffPageState extends State<DetailStaffPage>
    with SingleTickerProviderStateMixin {
  final bloc = StaffBloc();
  late TabController _tabController;
  bool isFirts = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.detail(widget.id);

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Chi tiết nhân viên',
        actions: [
          _buildMenu(),
        ],
      ),
      body: BlocConsumer<StaffBloc, CubitState>(
        bloc: bloc,
        listener: (context, state) {
          if (!isFirts) {
            CheckStateBloc.checkNoLoad(
              context,
              state,
              success: () {
                context.read<StaffManagerBloc>().getList();
                if (state.data == true) {
                  context.pop();
                }
              },
            );
          }
        },
        builder: (context, state) {
          return LoadPage(
            state: state,
            height: null,
            child: _buildBody(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (bloc.state.data is EmployeeModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: ColorApp.white,
            child: TabBar(
              controller: _tabController,
              labelColor: ColorApp.black,
              indicatorColor: ColorApp.main,
              labelStyle: StyleApp.medium(),
              unselectedLabelStyle: StyleApp.normal(),
              unselectedLabelColor: ColorApp.grey79,
              tabs: const [
                Tab(text: 'Thông tin nhân viên'),
                Tab(text: 'Lịch hẹn'),
              ],
            ),
          ),
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              TabInforStaff(
                model: bloc.state.data,
              ),
              TabEventDoctor(
                model: bloc.state.data,
              ),
            ],
          ).expanded(),
        ],
      );
    }
    return const EmptyContainer(
      msg: 'Không tìm thấy thông tin nhân viên',
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
          MenuDetailStaff.values.length,
          (index) {
            bool enabled = true;
            if (MenuDetailStaff.values[index] == MenuDetailStaff.active &&
                (bloc.state.data as EmployeeModel).active == true) {
              enabled = false;
            } else if (MenuDetailStaff.values[index] ==
                    MenuDetailStaff.unActive &&
                (bloc.state.data as EmployeeModel).active != true) {
              enabled = false;
            }

            return PopupMenuItem(
              enabled: enabled,
              textStyle: StyleApp.normal(),
              onTap: () {
                isFirts = false;
                if (MenuDetailStaff.values[index] == MenuDetailStaff.edit) {
                  context
                      .pushRoute(
                    CreateOrUpdateStaffRoute(
                      employee: bloc.state.data,
                    ),
                  )
                      .then(
                    (value) {
                      if (value == true) {
                        bloc.detail(widget.id);
                      }
                    },
                  );
                } else if (MenuDetailStaff.values[index] ==
                    MenuDetailStaff.remove) {
                  DialogUtils.showErrorDialog(
                    context,
                    content: 'Xác nhận xoá tài khoản?',
                    close: () => context.pop(),
                    accept: () {
                      context.pop();
                      bloc.remover(widget.id);
                    },
                  );
                } else {
                  DialogUtils.showErrorDialog(
                    context,
                    content:
                        MenuDetailStaff.values[index] == MenuDetailStaff.active
                            ? 'Xác nhận kích hoạt tài khoản?'
                            : 'Xác nhận vô hiệu hoá tài khoản?\n'
                                'Vô hiệu hoá tài khoản này nhân viên sẽ\n'
                                'không truy cập được vào hệ thống',
                    close: () => context.pop(),
                    accept: () {
                      context.pop();
                      bloc.active(
                        widget.id,
                        MenuDetailStaff.values[index] == MenuDetailStaff.active,
                      );
                    },
                  );
                }
              },
              child: Text(
                MenuDetailStaff.values[index].name,
                textAlign: TextAlign.right,
                // style: StyleApp.normal(),
              ),
            );
          },
        );
      },
    );
  }
}

enum MenuDetailStaff {
  edit('Chỉnh sửa'),
  unActive('Vô hiệu hóa'),
  active('Kích hoạt'),
  remove('Xoá');

  final String name;

  const MenuDetailStaff(
    this.name,
  );
}
