import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';

enum MenuTab {
  revenue('Báo cáo theo doanh thu', '/report/ic_revenue.svg'),
  product('Báo cáo theo sản phẩm', '/report/ic_customer.svg'),
  time('Báo cáo theo thời gian', '/report/ic_time.svg'),
  staff('Báo cáo theo nhân viên', '/report/ic_staff.svg'),
  customer('Báo cáo theo khách hàng', '/report/ic_customer.svg');

  final String title;
  final String iconPath;

  const MenuTab(this.title, this.iconPath);
}

@RoutePage()
class ReportPage extends StatelessWidget {
  ReportPage({super.key});

  final menuTabs = [
    MenuTab.revenue,
    MenuTab.product,
    MenuTab.time,
    MenuTab.staff,
    MenuTab.customer,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const BaseAppBar(
        title: 'Báo cáo',
      ),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: menuTabs.length,
              itemBuilder: (context, index) {
                final tab = menuTabs[index];
                return InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(top: sp16),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
