import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/detail/tab_service.dart';

import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../base/app_bar.dart';
import '../../../features/customer/data/models/customer_model.dart';
import '../../blocs/enum/enum_bloc.dart';
import '../../../features/address/cubit/location/latlng_by_address_bloc.dart';
import '../../blocs/state/init_state.dart';
import '../../../router/router.gr.dart';
import 'components/detail/tab_benh_an.dart';
import 'components/detail/tab_calendar.dart';
import 'components/detail/tab_infor.dart';
import 'components/detail/tab_order.dart';
import 'components/detail/tab_prd.dart';
import 'components/detail/tab_sub_info.dart';

enum MenuDetailCustomer {
  edit('Chỉnh sửa'),
  remove('Xoá');

  final String name;

  const MenuDetailCustomer(
    this.name,
  );
}

@RoutePage()
class ScreenCustomerDetail extends StatefulWidget {
  final CustomerModel customer;
  const ScreenCustomerDetail({super.key, required this.customer});

  @override
  State<ScreenCustomerDetail> createState() => _ScreenCustomerDetailState();
}

class _ScreenCustomerDetailState extends State<ScreenCustomerDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final addressBloc = LatlngByAddressBloc();
  final bloc = CustomerBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.detail(widget.customer.id ?? 0);
    _tabController = TabController(
      length: DetailTabEnum.values.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Chi tiết khách hàng',
        actions: [
          _buildMenu(),
        ],
      ),
      body: BlocBuilder<CustomerBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return LoadPage(
            state: state,
            height: null,
            child: bloc.customer == null
                ? const EmptyContainer(
                    msg: 'Không tìm thấy khách hàng',
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
                          tabs: List.generate(
                            DetailTabEnum.values.length,
                            (index) => Tab(
                              text: DetailTabEnum.values[index].name,
                              height: 35,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            TabInforCustomer(
                              customer: bloc.customer!,
                            ),
                            TabFile(
                              customer: bloc.customer!,
                              type: TypeFileCustomer.patient,
                            ),
                            TabFile(
                              customer: bloc.customer!,
                              type: TypeFileCustomer.test,
                            ),
                            TabCalendarCustomer(
                              customer: bloc.customer!,
                            ),
                            TabOrderCustomer(
                              customer: bloc.customer!,
                            ),
                            TabServiceCustomer(
                              customer: bloc.customer!,
                            ),
                            TabPrdCustomer(
                              customer: bloc.customer!,
                            ),
                            TabSubInfoCustomer(
                              customer: bloc.customer!,
                            ),
                          ],
                        ),
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
          MenuDetailCustomer.values.length,
          (index) => PopupMenuItem(
            onTap: () {
              if (MenuDetailCustomer.values[index] == MenuDetailCustomer.edit) {
                context.router
                    .push(
                  CustomerActionRoute(
                    customer: bloc.customer,
                  ),
                )
                    .then(
                  (value) {
                    if (value == true) {
                      bloc.detail(widget.customer.id ?? 0);
                    }
                  },
                );
              } else {
                DialogUtils.showErrorDialog(
                  context,
                  content: 'Bạn có muốn xoá khách hàng này không',
                  close: () => context.pop(),
                  accept: () {},
                  titleClose: 'Đóng',
                  titleConfirm: 'Xác nhận',
                );
              }
            },
            child: Text(
              MenuDetailCustomer.values[index].name,
              textAlign: TextAlign.center,
              style: StyleApp.normal(),
            ),
          ),
        );
      },
    );
  }
}
