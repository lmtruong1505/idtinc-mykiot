import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

enum ProductEvent {
  nhap_kho('Nhập lô'),
  edit('Chỉnh sửa'),
  inactive('Vô hiệu hóa'),
  active('Kích hoạt'),
  delete('Xoá');

  final String title;
  const ProductEvent(this.title);
}

class PopupProductInfo extends StatelessWidget {
  const PopupProductInfo({
    super.key,
    required this.child,
    this.onTap,
    required this.active,
  });

  final Widget child;
  final Function(ProductEvent value)? onTap;
  final bool active;

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

  List<PopupMenuItem<ProductEvent>> get _buildMenu {
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
        icon: FaIcon(iconCode: 'f47a'),
        label: ProductEvent.nhap_kho.title,
        value: ProductEvent.nhap_kho,
      ),
      _menuItem(
        icon: FaIcon(iconCode: 'f304'),
        label: ProductEvent.edit.title,
        value: ProductEvent.edit,
      ),
      if (active)
        _menuItem(
          icon: FaIcon(iconCode: 'f023'),
          label: ProductEvent.inactive.title,
          value: ProductEvent.inactive,
        ),
      if (!active)
        _menuItem(
          icon: FaIcon(iconCode: 'f3c1'),
          label: ProductEvent.active.title,
          value: ProductEvent.active,
        ),
      const PopupMenuItem(
        enabled: false,
        height: 8,
        child: Divider(
          thickness: 1,
        ),
      ),
      _menuItem(
        icon: FaIcon(iconCode: 'f2ed', color: AppColors.fg_negative),
        label: ProductEvent.delete.title,
        value: ProductEvent.delete,
        color: AppColors.fg_negative,
      ),
    ];
  }

  PopupMenuItem<ProductEvent> _menuItem({
    required Widget icon,
    required String label,
    Color? color,
    Function()? onTap,
    ProductEvent? value,
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
