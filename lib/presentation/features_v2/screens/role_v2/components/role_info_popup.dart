import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

enum RoleInfoEvent {
  edit('Chỉnh sửa'),
  delete('Xoá');

  final String title;

  const RoleInfoEvent(this.title);
}

class RoleInfoPopup extends StatelessWidget {
  const RoleInfoPopup({super.key, required this.child, this.onTap});

  final Widget child;
  final Function(RoleInfoEvent value)? onTap;

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

  List<PopupMenuItem<RoleInfoEvent>> get _buildMenu {
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
      _menuItem(
        icon: Icons.edit_outlined,
        label: RoleInfoEvent.edit.title,
        value: RoleInfoEvent.edit,
      ),
      const PopupMenuItem(
        enabled: false,
        height: 8,
        child: Divider(
          thickness: 1,
        ),
      ),
      _menuItem(
        icon: Icons.delete_outline,
        label: RoleInfoEvent.delete.title,
        value: RoleInfoEvent.delete,
        color: AppColors.fg_negative,
      ),
    ];
  }

  PopupMenuItem<RoleInfoEvent> _menuItem({
    required IconData icon,
    required String label,
    Color? color,
    Function()? onTap,
    RoleInfoEvent? value,
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
          Icon(
            icon,
            color: !enabled
                ? AppColors.text_disable
                : color ?? AppColors.fg_tertiary,
            size: 20,
          ),
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
