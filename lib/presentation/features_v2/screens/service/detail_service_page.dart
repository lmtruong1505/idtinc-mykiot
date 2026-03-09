import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/service/bloc_index.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../config/role/permission/index.dart';
import '../../../features/company/screen_v2/components/menu_action_dialog.dart';
import '../../../features/company/screen_v2/components/menu_popup.dart';
import '../../models/service/service.dart';
import 'components/detail/tab_info.dart';
import 'components/detail/tab_prd.dart';

@RoutePage()
class DetailServiceV2Page extends StatefulWidget {
  final int id;
  final List<ServiceTypeV2Model> types;
  const DetailServiceV2Page({
    super.key,
    required this.id,
    required this.types,
  });

  @override
  State<DetailServiceV2Page> createState() => _DetailServiceV2PageState();
}

class _DetailServiceV2PageState extends State<DetailServiceV2Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bloc = DetailServiceV2Bloc();
  final updateBloc = UpdateServiceV2Bloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    bloc.getDetail(
      widget.id,
      types: widget.types,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateServiceV2Bloc, CubitState>(
      bloc: updateBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            getIt<ListServiceBloc>().getList();
            if (state.data is bool) {
              bloc.updateStatus(state.data);
            } else if (state.data == 'remove') {
              context.pop();
            }
          },
        );
      },
      child: BlocBuilder<DetailServiceV2Bloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarCustom(
              title: 'Quản lý dịch vụ',
              subTitle: 'Chi tiết dịch vụ',
              actions: bloc.service.id == widget.id && isAdmin
                  ? [
                      _buildMenu(),
                      16.width,
                    ]
                  : null,
            ),
            body: LoadPage(
              state: state,
              height: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _tabBarCustom(),
                  TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      TabInfoDetailService(
                        model: bloc.service,
                        groupPrices: bloc.groupPrices,
                      ),
                      TabPrdDetailService(
                        products: bloc.service.products ?? [],
                      ),
                    ],
                  ).expanded(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenu() {
    return MenuPopupWorkSpace(
      onTap: (value) {
        if (value == StatusMenuWorkspace.edit) {
          context.pushRoute(CreateServiceV2Route(service: bloc.service));
          return;
        }
        menuActionDialog(
          context,
          value: value,
          title: 'Dịch vụ ${bloc.service.title ?? ''}',
          typeName: 'dịch vụ',
          contentText: 'Bạn có chắc chắn muốn ${value.title.toLowerCase()} ',
          confirm: () {
            context.pop();
            if (value == StatusMenuWorkspace.remove) {
              updateBloc.remove(widget.id);
              return;
            }
            if (value == StatusMenuWorkspace.active) {
              updateBloc.updateStatus(widget.id, true);
              return;
            }
            if (value == StatusMenuWorkspace.unActive) {
              updateBloc.updateStatus(widget.id, false);
              return;
            }
          },
        );
      },
      isActive: bloc.service.active == true,
      isDetail: true,
      isDelete: checkPermission(PerServiceEnum.DELETE.code),
      isEdit: checkPermission(PerServiceEnum.EDIT.code),
      isStatus: checkPermission(PerServiceEnum.ACTIVE.code),
      child: IconBtn(
        backgroundColor: AppColors.bg_primary,
        icon: const Icon(
          Icons.more_vert,
          size: 15,
        ),
      ),
    );
  }

  Widget _tabBarCustom() => Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.border_tertiary,
            ),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: AppColors.text_primary,
          unselectedLabelColor: AppColors.text_tertiary,
          labelStyle: AppStyle.bodyBsMedium,
          unselectedLabelStyle: AppStyle.bodyBsRegular,
          indicatorColor: AppColors.border_primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(
              text: 'Thông tin chi tiết',
            ),
            Tab(
              text: 'Sản phẩm liên quan',
            ),
          ],
        ),
      );
}
