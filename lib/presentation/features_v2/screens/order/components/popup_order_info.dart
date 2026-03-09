import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';

enum OrderEvent {
  edit('Chỉnh sửa'),
  delete('Xoá');

  final String title;
  const OrderEvent(this.title);
}

class PopupOrderInfo extends StatelessWidget {
  const PopupOrderInfo({super.key, required this.child, this.onTap});

  final Widget child;
  final Function(OrderEvent value)? onTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: AppColors.bg_primary,
      shape: RoundedRectangleBorder(
        borderRadius: 8.radius,
      ),
      constraints: const BoxConstraints(
        maxWidth: 200,
        minWidth: 175,
      ),
      elevation: 1,
      offset: const Offset(0, 30),
      onSelected: onTap,
      child: child,
      itemBuilder: (context) => _buildMenu,
    );
  }

  List<PopupMenuItem<OrderEvent>> get _buildMenu {
    return [
      PopupMenuItem(
        enabled: false,
        height: 35,
        labelTextStyle: WidgetStateProperty.all(
          AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        child: Row(
          children: [
            Text(
              'Tùy chọn',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ).flexible(),
            8.width,
            const Divider().expanded(),
          ],
        ),
      ),
      // _menuItem(
      //   icon: FaIcon(iconCode: 'f304'),
      //   label: OrderEvent.edit.title,
      //   value: OrderEvent.edit,
      // ),
      // const PopupMenuItem(
      //   enabled: false,
      //   height: 8,
      //   child: Divider(
      //     thickness: 1,
      //   ),
      // ),
      _menuItem(
        icon: FaIcon(iconCode: 'f2ed', color: AppColors.fg_negative),
        label: OrderEvent.delete.title,
        value: OrderEvent.delete,
        color: AppColors.fg_negative,
      ),
    ];
  }

  PopupMenuItem<OrderEvent> _menuItem({
    required Widget icon,
    required String label,
    Color? color,
    Function()? onTap,
    OrderEvent? value,
    bool enabled = true,
  }) {
    return PopupMenuItem(
      padding: 10.padingVer + 16.padingHor,
      height: 40,
      onTap: onTap,
      value: value,
      enabled: enabled,
      child: Row(
        children: [
          icon,
          6.width,
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.bodyBsRegular.copyWith(
              height: 1.2,
              color: !enabled ? AppColors.text_disable : color,
            ),
          ).expanded(),
        ],
      ),
    );
  }
}
