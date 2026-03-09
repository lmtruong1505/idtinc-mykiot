import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/home/cubit/home_state.dart';
import 'package:pharmago/presentation/features/home/widgets/chart_customer.dart';
import 'package:pharmago/presentation/features/home/widgets/chart_customer_revenue.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../../../constants/typography.dart';
import '../cubit/home_cubit.dart';
import 'chart_employee_revenue.dart';
import 'chart_order.dart';
import 'chart_revenue.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.myBloc,
  });

  final HomeCubit myBloc;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return Container(
          height: heightDevice(context),
          width: widthDevice(context),
          color: bg_5,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [
                  _appBar,
                  state.revenueItems.isEmpty ? gapHeight(sp0) : _charRevenue,
                  _charCustomer,
                  _orderReort,
                  _customerRevenue,
                  _employeeRevenue,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _appBar {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(sp16),
            ),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: CommonDropdown(
                  value: state.companySelected,
                  items: state.companies,
                  onChanged: widget.myBloc.companyChange,
                  suffixIcon: const Icon(Icons.swap_horiz_rounded),
                  hintText: '',
                  borderColor: bg_6,
                  color: bg_6,
                  radius: sp24,
                  boxShadow: const [],
                  showIconRemove: false,
                ),
              ),
              gapWidth(sp16),
              InkWell(
                onTap: () => context.navPush(const ConversationListRoute()),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: sp24,
                      backgroundColor: bg_6,
                      child: Icon(
                        Icons.message_outlined,
                        color: blackColor,
                        size: sp20,
                      ),
                    ),
                    Positioned(
                      right: sp0,
                      top: sp0,
                      child: CircleAvatar(
                        radius: sp12,
                        backgroundColor: red_3,
                        child: Text(
                          state.countNotiNotSeen.toString(),
                          style: p7.copyWith(color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapWidth(sp12),
              InkWell(
                onTap: () => context.navPush(const NotificationListRoute()),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: sp24,
                      backgroundColor: bg_6,
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: blackColor,
                        size: sp20,
                      ),
                    ),
                    Positioned(
                      right: sp0,
                      top: sp0,
                      child: CircleAvatar(
                        radius: sp12,
                        backgroundColor: red_3,
                        child: Text(
                          state.countNotiNotSeen.toString(),
                          style: p7.copyWith(color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get _charRevenue => ChartRevenueView(cubit: widget.myBloc);

  Widget get _charCustomer => ChartCustomer(cubit: widget.myBloc);

  Widget get _orderReort => ChartOrder(cubit: widget.myBloc);

  Widget get _customerRevenue => ChartCustomerRevenue(cubit: widget.myBloc);

  Widget get _employeeRevenue => ChartEmployeeRevenue(cubit: widget.myBloc);
}
