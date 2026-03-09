import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../models/role/role_model.dart';

@RoutePage()
class RoleManagerPage extends StatefulWidget {
  const RoleManagerPage({super.key});

  @override
  State<RoleManagerPage> createState() => _RoleManagerPageState();
}

class _RoleManagerPageState extends State<RoleManagerPage> {
  late ListRoleBloc bloc;

  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read<ListRoleBloc>();
    bloc.init();
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.greyF5,
      appBar: const BaseAppBar(title: 'Quản lý vai trò'),
      body: SingleChildScrollView(
        padding: 16.pading,
        controller: scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainButtonV2(
              onTap: () {
                context.pushRoute(CreateRoleRoute());
              },
              radius: 8,
              title: 'Thêm mới',
            ),
            16.height,
            AppInputV2(
              hintText: 'Tìm kiếm tên vai trò',
              backgroundColor: ColorApp.white,
              radius: 8,
              onChanged: bloc.search,
            ),
            16.height,
            BlocBuilder<ListRoleBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                return LoadListPage(
                  state: state,
                  height: 200,
                  listEmpty: bloc.list.isEmpty,
                  child: ListView.separated(
                    itemBuilder: (context, index) => _buildItem(
                      bloc.list[index],
                    ),
                    separatorBuilder: (context, index) => 16.height,
                    itemCount: bloc.list.length,
                    shrinkWrap: true,
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

  Widget _buildItem(RoleListModel role) {
    return InkWell(
      onTap: () {
        context.pushRoute(DetailRoleRoute(id: role.id ?? 0));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            role.title ?? '',
            style: StyleApp.medium(fontSize: 16),
          ),
          8.height,
          Row(
            children: [
              const Icon(
                Icons.check,
                size: 17,
                color: ColorApp.blue99,
              ),
              4.width,
              Text(
                '${role.totalEmployee ?? 0} nhân viên',
                style: StyleApp.normal(),
              ).expanded(),
            ],
          ),
        ],
      ).container(
        radius: 8,
        border: Border.all(
          color: ColorApp.greyE2,
          width: 1,
        ),
      ),
    );
  }
}
