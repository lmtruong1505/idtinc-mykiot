import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_cubit.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

enum MenuTab {
  report('Khoản phải thu', '/debt/ic_receivable.svg', DebtNoteType.REVENUE),
  inventory('Khoản phải chi', '/debt/ic_spend.svg', DebtNoteType.EXPENSE);

  final String title;
  final String iconPath;
  final DebtNoteType debtType;

  const MenuTab(this.title, this.iconPath, this.debtType);
}

@RoutePage()
class DebtPage extends StatelessWidget {
  DebtPage({super.key});

  final menuTabs = [
    MenuTab.report,
    MenuTab.inventory,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_5,
      appBar: const BaseAppBar(
        title: 'Công nợ',
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
            ListView.separated(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: menuTabs.length,
              separatorBuilder: (context, index) => gapHeight(sp16),
              itemBuilder: (context, index) {
                final tab = menuTabs[index];
                return InkWell(
                  onTap: () => context.navPush(DebtListRoute(debtType: tab.debtType)),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
