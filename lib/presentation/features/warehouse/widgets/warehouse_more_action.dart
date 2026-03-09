import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../base/map_entry.dart';
import '../../../constants/colors.dart';

class WarehouseMoreAction extends StatefulWidget {
  const WarehouseMoreAction({
    super.key,
    this.id,
  });

  final int? id;

  @override
  State<WarehouseMoreAction> createState() => _WarehouseMoreActionState();
}

class _WarehouseMoreActionState extends State<WarehouseMoreAction> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: MenuEntry.build(
        _getMenus(widget.id),
      ),
    );
  }

  List<MenuEntry> _getMenus(int? id) {
    final List<MenuEntry> result = <MenuEntry>[
      MenuEntry(
        labelWidget: const Icon(
          Icons.more_vert_rounded,
          color: blackColor,
        ),
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: 'Sửa thông tin kho',
            onPressed: () => context.router.push(WarehouseEditRoute(id: id)),
          ),
          MenuEntry(
            label: 'Xem tồn kho',
            onPressed: () {},
            titleColor: red_1,
          ),
        ],
      ),
    ];
    return result;
  }
}
