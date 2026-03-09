import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../constants/typography.dart';

enum OrderTab {
  sell('Đơn bán hàng', '/order_tab/sell.svg'),
  wholesaleMedicine('Đơn thuốc sỉ', '/order_tab/wholesale_medicine.svg');

  final String title;
  final String iconPath;

  const OrderTab(
    this.title,
    this.iconPath,
  );
}

@RoutePage()
class OrderManagerPage extends StatefulWidget {
  const OrderManagerPage({super.key});

  @override
  State<OrderManagerPage> createState() => _OrderManagerPageState();
}

class _OrderManagerPageState extends State<OrderManagerPage> {
  final menuTabs = [
    OrderTab.sell,
    OrderTab.wholesaleMedicine,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_5,
      appBar: BaseAppBar(
        title: 'Quản lý đơn hàng',
        leading: Container(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        height: heightDevice(context),
        width: widthDevice(context),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: menuTabs.length,
          itemBuilder: (context, index) {
            final tab = menuTabs[index];
            return InkWell(
              onTap: () {
                late PageRouteInfo page;
                switch (tab) {
                  case OrderTab.sell:
                    page = const OrderListRoute();
                    break;
                  case OrderTab.wholesaleMedicine:
                    page = const ListWholesaleMadicineRoute();
                    break;
                  default:
                    page = const OrderListRoute();
                }
                context.router.push(page);
              },
              child: Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withOpacity(0.3),
                      offset: const Offset(1, 2),
                      blurRadius: sp4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IcSvg.asset(tab.iconPath, width: sp28),
                    const SizedBox(width: sp16),
                    Text(
                      tab.title,
                      style: p5,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: sp16,
                    ),
                  ],
                ),
              ),
            );
          }, separatorBuilder:(context, index) => gapHeight(sp16),
        ),
      ),
    );
  }
}
