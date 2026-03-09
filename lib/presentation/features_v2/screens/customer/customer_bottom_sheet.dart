import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../base/empty_container.dart';
import '../../blocs/customer/customer_bloc.dart';
import '../../blocs/enum/enum_bloc.dart';
import '../../../features/address/cubit/location/latlng_by_address_bloc.dart';
import '../../blocs/state/init_state.dart';
import 'components/detail/tab_benh_an.dart';
import 'components/detail/tab_calendar.dart';
import 'components/detail/tab_infor.dart';
import 'components/detail/tab_order.dart';
import 'components/detail/tab_prd.dart';
import 'components/detail/tab_service.dart';
import 'components/detail/tab_sub_info.dart';

class CustomerBottomSheet extends StatefulWidget {
  final int customerId;
  const CustomerBottomSheet({super.key, required this.customerId});

  @override
  State<CustomerBottomSheet> createState() => _CustomerBottomSheetState();
}

class _CustomerBottomSheetState extends State<CustomerBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final addressBloc = LatlngByAddressBloc();
  final bloc = CustomerBloc();
  final _scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.detail(widget.customerId);
    _tabController = TabController(
      length: DetailTabEnum.values.length,
      vsync: this,
    );
  }

  void scrollTabBar(int index) {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        index.toDouble(),
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 16.radiusTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  color: ColorApp.greyE2,
                  borderRadius: 4.radius,
                ),
              ),
            ],
          ),
          Text(
            'Thông tin khách hàng',
            style: StyleApp.medium(
              fontSize: 16,
              color: ColorApp.grey79,
            ),
          ).padding(16.pading),
          BlocBuilder<CustomerBloc, CubitState>(
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: 16.padingHor,
                            controller: _scroll,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorApp.grey79.withOpacity(0.1),
                                borderRadius: 12.radius,
                                border: Border.all(
                                  color: ColorApp.black.withOpacity(0.1),
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelColor: ColorApp.black,
                                labelStyle: StyleApp.semibold(),
                                unselectedLabelColor: ColorApp.grey79,
                                unselectedLabelStyle: StyleApp.normal(),

                                indicator: BoxDecoration(
                                  borderRadius: 12.radius,
                                  color: ColorApp.white,
                                  border: Border.all(
                                    color: ColorApp.black.withOpacity(0.1),
                                  ),
                                ),
                                // onTap: scrollTabBar,
                                tabs: List.generate(
                                  DetailTabEnum.values.length,
                                  (index) => Tab(
                                    text: DetailTabEnum.values[index].name,
                                    height: 35,
                                  ),
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
          ).expanded(),
        ],
      ),
    );
  }
}
