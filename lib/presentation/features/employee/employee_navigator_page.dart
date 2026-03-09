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
  employeeList('Danh sách nhân viên', IcSvg.iconEmployeeList),
  role('Phân quyền vai trò', IcSvg.iconEmployeeRole);

  final String title;
  final String iconSvg;

  const MenuTab(this.title, this.iconSvg);
}

@RoutePage()
class EmployeeNavigatorPage extends StatelessWidget {
  EmployeeNavigatorPage({super.key});

  final menuTabs = [
    MenuTab.employeeList,
    MenuTab.role,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const BaseAppBar(title: 'Nhân viên'),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: menuTabs.length,
              itemBuilder: (context, index) {
                final tab = menuTabs[index];
                return InkWell(
                  onTap: () {
                    late PageRouteInfo page;
                    switch (tab) {
                      case MenuTab.role:
                        page = const RoleListRoute();
                        break;
                      default:
                         page = const EmployeeListRoute();
                        
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
                        IcSvg.img(tab.iconSvg, width: sp28),
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
              separatorBuilder: (BuildContext context, int index) =>
                  gapHeight(sp16),
            ),
          ],
        ),
      ),
    );
  }
}
