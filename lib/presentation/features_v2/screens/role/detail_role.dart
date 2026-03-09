import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/role/components/detail/tab_infor.dart';
import 'package:pharmago/presentation/features_v2/screens/role/components/detail/tab_permission.dart';
import 'package:pharmago/presentation/features_v2/screens/role/components/detail/tab_staff.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../base/dialog.dart';
import '../../../base/empty_container.dart';
import '../../blocs/role/role_bloc.dart';
import '../../blocs/state/init_state.dart';

@RoutePage()
class DetailRolePage extends StatefulWidget {
  final int id;
  const DetailRolePage({
    super.key,
    required this.id,
  });

  @override
  State<DetailRolePage> createState() => _DetailRolePageState();
}

class _DetailRolePageState extends State<DetailRolePage>
    with SingleTickerProviderStateMixin {
  final bloc = RoleBloc();
  final removerBloc = RoleBloc();
  late TabController _tabController;
  bool isFirst = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.detail(widget.id);
    _tabController = TabController(
      length: DetailRoleTabEnum.values.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleBloc, CubitState>(
      bloc: removerBloc,
      listener: (context, state) {
        CheckStateBloc.checkNoLoad(
          context,
          state,
          success: () {
            context.read<ListRoleBloc>().getList();
            context.pop();
            context.pop();
          },
        );
      },
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: BaseAppBar(
          title: 'Chi tiết vai trò',
          actions: [
            _buildMenu(),
          ],
        ),
        body: BlocBuilder<RoleBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return LoadPage(
              state: state,
              height: null,
              child: state.data == null
                  ? const EmptyContainer(
                      msg: 'Không tìm thấy thông tin vai trò',
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: ColorApp.white,
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            indicatorColor: ColorApp.main,
                            labelColor: ColorApp.black,
                            labelStyle: StyleApp.semibold(),
                            unselectedLabelColor: ColorApp.grey79,
                            unselectedLabelStyle: StyleApp.normal(),
                            padding: Dimensions.sp16.padingHor,
                            labelPadding: Dimensions.sp12.padingHor,
                            tabAlignment: TabAlignment.start,
                            tabs: List.generate(
                              DetailRoleTabEnum.values.length,
                              (index) => Tab(
                                text: DetailRoleTabEnum.values[index].name,
                                height: 35,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              TabInforRole(
                                model: state.data,
                              ),
                              TabPermissionRole(
                                model: state.data,
                              ),
                              TabStaffRole(
                                model: state.data,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
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
          MenuDetailRole.values.length,
          (index) {
            return PopupMenuItem(
              textStyle: StyleApp.normal(),
              onTap: () {
                if (MenuDetailRole.values[index] == MenuDetailRole.edit) {
                  context
                      .pushRoute(
                    CreateRoleRoute(
                      model: bloc.state.data,
                    ),
                  )
                      .then(
                    (value) {
                      if (value == true) {
                        bloc.detail(widget.id);
                      }
                    },
                  );
                } else {
                  DialogUtils.showErrorDialog(
                    context,
                    content: 'Xác nhận xoá vai trò này?',
                    close: () => context.pop(),
                    accept: () {
                      removerBloc.remove(widget.id);
                      context.pop();
                    },
                  );
                }
              },
              child: Text(
                MenuDetailRole.values[index].name,
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

enum MenuDetailRole {
  edit('Chỉnh sửa'),
  remove('Xoá');

  final String name;
  const MenuDetailRole(this.name);
}

enum DetailRoleTabEnum {
  infor('Thông tin cơ bản'),
  permission('Phân quyền vai trò'),
  staff('Danh sách nhân viên');

  final String name;
  const DetailRoleTabEnum(this.name);
}
