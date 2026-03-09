import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/order_create_v2_cubit.dart';
import 'package:pharmago/presentation/features/order/v2/widget/select_customer_v2.dart';
import 'package:pharmago/presentation/features/order/v2/widget/select_service_v2.dart';
import 'package:pharmago/presentation/features/order/v2/widget/select_variant_v2.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../router/router.gr.dart';
import '../../../../shared/utils/event.dart';
import '../../../customer/cubit/customer_cubit.dart';
import '../cubit/order_create_v2_state.dart';

@RoutePage()
class
OrderCreateV2Page extends StatefulWidget {
  const OrderCreateV2Page({
    super.key,
    required this.typeCreate,
    this.mbUuid, this.idBranch,
  });
  final String? mbUuid;
  final OrderType typeCreate;
  final int? idBranch;

  @override
  State<OrderCreateV2Page> createState() => _OrderCreateV2PageState();
}

class _OrderCreateV2PageState extends State<OrderCreateV2Page>
    with SingleTickerProviderStateMixin {
  final orderCreateCubit = getIt<OrderCreateV2Bloc>();
  final customerCubit = getIt<CustomerCubit>();

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderCreateV2Bloc>(
          create: (context) => orderCreateCubit
            ..init(
              widget.typeCreate,
              mbUuid: widget.mbUuid,
              idBranch: widget.idBranch,
            ),
        ),
        BlocProvider<CustomerCubit>(
          create: (context) => customerCubit,
        ),
      ],
      child: Scaffold(
        backgroundColor: bg_4,
        body: Container(
          height: heightDevice(context),
          width: widthDevice(context),
          //child: _appBar,
          child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: whiteColor,
                leading: InkWell(
                  onTap: () => context.router.pop(),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: blackColor,
                  ),
                ),
                centerTitle: true,
                title: const Text(
                  'Tạo mới đơn hàng 2',
                  style: TextStyle(color: blackColor),
                ),
                bottom: TabBar(
                  indicatorColor: blackColor,
                  controller: _tabController,
                  labelColor: blackColor,
                  tabs: [
                    const Tab(
                      text: 'Khách hàng',
                    ),
                    Tab(
                      text: widget.typeCreate == OrderType.product
                          ? 'Sản phẩm'
                          : 'Dịch vụ',
                    ),
                  ],
                  onTap: (value) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
                    builder: (context, state) {
                      return SelectCustomerV2(
                        onConfirm: (value) {
                          orderCreateCubit.selectCustomer(value);
                        },
                        customerSelected: state.customerSelected,
                      );
                    },
                  ),
                  BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
                    builder: (context, state) {
                      switch (state.typeCreate) {
                        case OrderType.product:
                          return SelectVariantV2(
                            orderCreateCubit: orderCreateCubit,
                          );
                        case OrderType.service:
                          return SelectServiceV2(
                            orderCreateCubit: orderCreateCubit,
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _bottomBar,
      ),
    );
  }

  Widget get _bottomBar {
    return BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
      builder: (context, state) {
        final canOrder = state.customerSelected != null &&
            (state.variantSelected.isNotEmpty ||
                state.serviceSelected.isNotEmpty);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: whiteColor,
              padding: const EdgeInsets.symmetric(
                vertical: sp12,
                horizontal: sp16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền',
                        style: p6.copyWith(color: greyColor),
                      ),
                      Text(
                        '${FormatCurrency(state.total)}đ',
                        style: p5.copyWith(color: mainColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: sp12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(sp12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(sp12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(sp12),
                              ),
                              border: Border.all(
                                color: greyColor,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                context.router.maybePop();
                              },
                              child: const Center(
                                child: Text(
                                  'Huỷ bỏ',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: sp12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(sp12),
                            decoration: BoxDecoration(
                              color: !canOrder ? greyColor : mainColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(sp12),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (!canOrder) {
                                  return;
                                }
                                _createOrder();
                              },
                              child: const Center(
                                child: Text(
                                  'Xác nhận đơn',
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _createOrder() {
    context.router.push(OrderConfirmRoute(myBloc: orderCreateCubit));
  }
}
