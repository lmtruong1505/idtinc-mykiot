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
  warehouseManage('Quản lý kho', '/inventory/ic_warehouse_manage.svg'),
  inventory('Tồn kho', '/inventory/ic_inventory.svg'),
  warehouseImport('Nhập kho', '/inventory/ic_warehouse_import.svg'),
  discharge('Xuất kho', '/inventory/ic_discharge.svg'),
  warehouseTransfer('Chuyển kho', '/inventory/ic_warehouse_transfer.svg');

  final String title;
  final String iconPath;

  const MenuTab(this.title, this.iconPath);
}

@RoutePage()
class InventoryNavigatorPage extends StatelessWidget {
  InventoryNavigatorPage({super.key});

  final menuTabs = [
    MenuTab.warehouseManage,
    MenuTab.inventory,
    MenuTab.warehouseImport,
    // MenuTab.discharge,
    // MenuTab.warehouseTransfer,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const BaseAppBar(
        title: 'Kho & Tồn',
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
                  onTap: () {
                    late PageRouteInfo page;
                    switch (tab) {
                      case MenuTab.warehouseManage:
                        page = const WarehouseListRoute();
                        break;
                      case MenuTab.inventory:
                        page = const InventoryListRoute();
                        break;
                      case MenuTab.warehouseImport:
                        page = const TicketListRoute();
                        break;
                      default:
                        page = const InventoryListRoute();
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
