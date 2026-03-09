import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

enum StatusMenuWorkspace {
  detail('Xem chi tiết'),
  edit('Chỉnh sửa'),
  active('Kích hoạt'),
  unActive('Vô hiệu hoá'),
  remove('Xoá');

  final String title;
  const StatusMenuWorkspace(this.title);
}

class MenuPopupWorkSpace extends StatelessWidget {
  final Widget child;
  final bool isDetail;
  final bool isActive;
  final bool isStatus;
  final bool isDelete;
  final bool isEdit;
  final Function(StatusMenuWorkspace value)? onTap;
  const MenuPopupWorkSpace({
    super.key,
    required this.child,
    this.isDetail = false,
    this.isActive = true,
    this.isStatus = true,
    this.isDelete = true,
    this.isEdit = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<StatusMenuWorkspace>(
      color: AppColors.bg_primary,
      shape: RoundedRectangleBorder(
        borderRadius: 8.radius,
      ),
      constraints: const BoxConstraints(
        maxWidth: 250,
        minWidth: 250,
      ),
      elevation: 1,
      offset: const Offset(0, 30),
      onSelected: onTap,
      child: child,
      itemBuilder: (context) => _buildMenu,
    );
  }

  List<PopupMenuItem<StatusMenuWorkspace>> get _buildMenu {
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
      if (!isDetail)
        _menuItem(
          icon: Icons.remove_red_eye_outlined,
          label: 'Xem chi tiết',
          value: StatusMenuWorkspace.detail,
        ),
      if (isEdit)
        _menuItem(
          icon: Icons.edit_outlined,
          label: 'Chỉnh sửa',
          value: StatusMenuWorkspace.edit,
          // enabled: isActive,
        ),
      if (isStatus) ...[
        if (!isActive)
          _menuItem(
            icon: Icons.lock_open_rounded,
            label: 'Kích hoạt',
            enabled: !isActive,
            value: StatusMenuWorkspace.active,
          ),
        if (isActive)
          _menuItem(
            icon: Icons.lock_outline,
            label: 'Vô hiệu hóa',
            enabled: isActive,
            value: StatusMenuWorkspace.unActive,
          ),
      ],
      if (isDelete) ...[
        const PopupMenuItem(
          padding: EdgeInsets.zero,
          height: 1,
          child: Divider(
            height: 0,
          ),
        ),
        _menuItem(
          icon: CupertinoIcons.delete_solid,
          label: 'Xoá',
          color: AppColors.fg_negative,
          value: StatusMenuWorkspace.remove,
        ),
      ],
    ];
  }

  PopupMenuItem<StatusMenuWorkspace> _menuItem({
    required IconData icon,
    required String label,
    Color? color,
    Function()? onTap,
    StatusMenuWorkspace? value,
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
