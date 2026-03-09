import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

enum ProfileEvent{
  edit('Chỉnh sửa'),
  inactive('Xoá tài khoản'),
  changePassword('Đổi mật khẩu'),
  changeAvatar('Đổi ảnh đại diện');

  final String title;
  const ProfileEvent(this.title);
}

class ProfilePopup extends StatelessWidget {
  const ProfilePopup({super.key, required this.child, this.onTap});

  final Widget child;
  final Function(ProfileEvent value)? onTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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

  List<PopupMenuItem<ProfileEvent>> get _buildMenu {
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
        label: ProfileEvent.edit.title,
        value: ProfileEvent.edit,
      ),
      _menuItem(
        icon: Icons.key,
        label: ProfileEvent.changePassword.title,
        value: ProfileEvent.changePassword,
      ),
      _menuItem(
        icon: Icons.person_pin_outlined,
        label: ProfileEvent.changeAvatar.title,
        value: ProfileEvent.changeAvatar,
      ),
      _menuItem(
        icon: Icons.delete_outline_rounded,
        label: ProfileEvent.inactive.title,
        value: ProfileEvent.inactive,
      ),
    ];
  }

  PopupMenuItem<ProfileEvent> _menuItem({
    required IconData icon,
    required String label,
    Color? color,
    Function()? onTap,
    ProfileEvent? value,
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
