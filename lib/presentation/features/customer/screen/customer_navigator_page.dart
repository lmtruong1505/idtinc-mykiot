import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

enum MenuTab {
  customer('Danh sách khách hàng', '/customer/ic_list.svg'),
  group('Nhóm khách hàng', '/customer/ic_group.svg'),
  conversation('Danh sách hội thoại', '/customer/ic_conversation.svg');

  final String title;
  final String iconPath;

  const MenuTab(this.title, this.iconPath);
}

@RoutePage()
class CustomerNavigatorPage extends StatelessWidget {
  CustomerNavigatorPage({super.key});

  final menuTabs = [
    MenuTab.customer,
    MenuTab.conversation,
    MenuTab.group,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: whiteColor,
        appBar: const BaseAppBar(title: 'Khách hàng'),
        body: Container(
          width: widthDevice(context),
          height: heightDevice(context),
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => gapHeight(sp16),
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: menuTabs.length,
                itemBuilder: (context, index) {
                  final tab = menuTabs[index];
                  return InkWell(
                    onTap: () {
                      late PageRouteInfo page;
                      switch (tab) {
                        case MenuTab.group:
                          page = const CustomerGroupRoute();

                          break;
                        case MenuTab.conversation:
                          page = const ConversationListRoute();
                          break;
                        default:
                          page = const CustomerManagerV2Route();
                        // page = const CustomerListRoute();
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
                          Text(tab.title, style: p5),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: sp16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
