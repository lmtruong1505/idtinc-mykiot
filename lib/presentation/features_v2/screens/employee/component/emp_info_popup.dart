import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

enum EmpInfoEvent {
  edit('Chỉnh sửa'),
  quit('Xoá nhân viên');

  final String title;

  const EmpInfoEvent(this.title);
}

class EmpInfoPopup extends StatelessWidget {
  const EmpInfoPopup({super.key, required this.child, this.onTap});

  final Widget child;
  final Function(EmpInfoEvent value)? onTap;

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

  List<PopupMenuItem<EmpInfoEvent>> get _buildMenu {
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
        label: EmpInfoEvent.edit.title,
        value: EmpInfoEvent.edit,
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
        label: EmpInfoEvent.quit.title,
        value: EmpInfoEvent.quit,
        color: AppColors.fg_negative,
      ),
    ];
  }

  PopupMenuItem<EmpInfoEvent> _menuItem({
    required IconData icon,
    required String label,
    Color? color,
    Function()? onTap,
    EmpInfoEvent? value,
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
