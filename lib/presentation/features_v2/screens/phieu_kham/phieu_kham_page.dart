import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/list_pk_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../constants/spacing.dart';
import 'components/item_phieu_kham.dart';

@RoutePage()
class PhieuKhamPage extends StatefulWidget {
  const PhieuKhamPage({super.key});

  @override
  State<PhieuKhamPage> createState() => _PhieuKhamPageState();
}

class _PhieuKhamPageState extends State<PhieuKhamPage> {
  late ListPhieuKhamBloc bloc;
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read<ListPhieuKhamBloc>();
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
    bloc.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Danh sách phiếu khám',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bloc.getList();
        },
        child: SingleChildScrollView(
          padding: sp16.pading,
          controller: scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainButtonV2(
                title: 'Thêm mới',
                radius: 8,
                onTap: () {
                  context.pushRoute(
                    CreateEventRoute(
                      isEvent: false,
                    ),
                  );
                },
              ),
              sp16.height,
              AppInputV2(
                hintText: 'Tìm kiếm mã phiếu',
                radius: 8,
                onChanged: bloc.changeSearch,
                prefixIcon: const Icon(
                  Icons.search,
                ),
              ),
              BlocBuilder<ListPhieuKhamBloc, CubitState>(
                bloc: bloc,
                builder: (context, state) {
                  return LoadListPage(
                    state: state,
                    height: 200,
                    listEmpty: bloc.list.isEmpty,
                    child: ListView.separated(
                      padding: sp16.padingVer,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ItemPhieuKham(
                        phieuKham: bloc.list[index],
                      ),
                      separatorBuilder: (context, index) => sp16.height,
                      itemCount: bloc.list.length,
                    ),
                  );
                },
              ),
              context.padding.bottom.height,
            ],
          ),
        ),
      ),
    );
  }
}
