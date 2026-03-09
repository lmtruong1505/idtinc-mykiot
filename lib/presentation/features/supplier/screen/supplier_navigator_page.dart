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
  supplier('Nhà cung cấp', IcSvg.iconSupplier),
  group('Nhóm nhà cung cấp', IcSvg.iconSupplierGroup);

  final String title;
  final String iconSvg;

  const MenuTab(this.title, this.iconSvg);
}

@RoutePage()
class SupplierNavigatorPage extends StatelessWidget {
  SupplierNavigatorPage({super.key});

  final menuTabs = [
    MenuTab.supplier,
    // MenuTab.group,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: const BaseAppBar(title: 'Nhà cung cấp'),
        body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            child: Column(children: [
              ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuTabs.length,
                  itemBuilder: (context, index) {
                    final tab = menuTabs[index];
                    return InkWell(
                        onTap: () {
                          late PageRouteInfo page;
                          switch (tab) {
                            case MenuTab.group:
                              page = const SupplierGroupRoute();
                              break;
                            default:
                              page = const SupplierListRoute();
                          }
                          context.router.push(page);
                        },
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
                                      blurRadius: sp4)
                                ]),
                            child: Row(children: [
                              IcSvg.img(tab.iconSvg, width: sp28),
                              const SizedBox(width: sp16),
                              Text(tab.title, style: p5),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  size: sp16)
                            ])));
                  })
            ])));
  }
}
