import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/v2/customer_action_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../features/company/screen_v2/components/menu_action_dialog.dart';
import '../../../features/company/screen_v2/components/menu_popup.dart';
import '../../../router/router.gr.dart';
import '../../blocs/customer/v2/list_customer_bloc.dart';
import '../../models/customer/v2/customer_model.dart';
import 'components/detail/tab_infor.dart';
import 'components/health_records_view.dart';
import 'components/list_exchange_point_view.dart';

@RoutePage()
class DetailCustomerV2Page extends StatefulWidget {
  final int id;
  const DetailCustomerV2Page({
    super.key,
    required this.id,
  });

  @override
  State<DetailCustomerV2Page> createState() => _DetailCustomerV2PageState();
}

class _DetailCustomerV2PageState extends State<DetailCustomerV2Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _bloc = CustomerActionV2Bloc();
  final _removeBloc = CustomerActionV2Bloc();
  //24000112

  final List<String> _tabTitles = [
    'Thông tin cơ bản',
    'Điểm tích lũy',
    'Khám chữa bệnh',
    'Hồ sơ sức khoẻ',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabTitles.length);
    _bloc.detail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerActionV2Bloc, CubitState>(
      bloc: _removeBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          success: () {
            getIt<ListCustomerV2Bloc>().getList();
            context.router.popUntil(
              (route) => route.settings.name == HomeRoute.name,
            );
          },
        );
      },
      child: BlocBuilder<CustomerActionV2Bloc, CubitState>(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarCustom(
              subTitle: 'Chi tiết khách hàng',
              title: 'Quản lý khách hàng',
              actions: state.data is CustomerV2Model
                  ? [
                      _buildMenu(),
                    ]
                  : null,
            ),
            body: LoadPage(
              state: state,
              height: null,
              errorView: EmptyContainer(
                msg: state.msg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTab(),
                  TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      TabInforCustomerV2(
                        customer: state.data is CustomerV2Model
                            ? state.data
                            : CustomerV2Model(),
                      ),
                      BlocBuilder<CustomerActionV2Bloc, CubitState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          return ListExchangePointView(
                            point:
                                (state.data as CustomerV2Model?)?.points ?? 0,
                            listPoints: _bloc.listPoints,
                          );
                        },
                      ),
                      Container(),
                      if (_bloc.state.data is CustomerV2Model)
                        HealthRecordsView(
                          customer: _bloc.state.data,
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

  Widget _buildTab() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border_tertiary,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.border_primary,
        labelColor: AppColors.text_primary,
        labelStyle: AppStyle.bodyBsMedium,
        unselectedLabelColor: AppColors.text_tertiary,
        unselectedLabelStyle: AppStyle.bodyBsRegular,
        tabs: List.generate(
          _tabTitles.length,
          (index) => Tab(
            text: _tabTitles[index],
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    if (_bloc.state.data is CustomerV2Model) {
      return MenuPopupWorkSpace(
        onTap: (value) {
          if (value == StatusMenuWorkspace.edit) {
            context
                .pushRoute(CreateCustomerV2Route(customer: _bloc.state.data));
            return;
          }
          menuActionDialog(
            context,
            value: value,
            title: 'Khách hàng ${_bloc.state.data.fullName ?? ''}',
            typeName: 'khách hàng',
            contentText: 'Bạn có chắc chắn muốn ${value.title.toLowerCase()} ',
            confirm: () {
              context.pop();
              _removeBloc.delete(widget.id);
            },
          );
        },
        isDetail: true,
        isStatus: false,
        child: IconBtn(
          backgroundColor: AppColors.bg_primary,
          icon: const Icon(
            Icons.more_vert,
            size: 15,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
