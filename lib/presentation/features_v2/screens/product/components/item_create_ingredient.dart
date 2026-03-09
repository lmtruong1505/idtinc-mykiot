import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/icon_btn.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../models/product/ingredient_v2_model.dart';

class ItemCreateIngredient extends StatefulWidget {
  const ItemCreateIngredient(
      {super.key, required this.list, required this.onAdd, this.onRemove, this.onUpdate});

  final List<IngredientV2Model> list;
  final Function() onAdd;
  final Function(int)? onRemove;
  final Function(int)? onUpdate;

  @override
  State<ItemCreateIngredient> createState() => _ItemCreateIngredientState();
}

class _ItemCreateIngredientState extends State<ItemCreateIngredient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 12.radius,
        border: Border.all(color: AppColors.border_tertiary),
      ),
      child: ClipRRect(
        borderRadius: 12.radius,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader().container(
              bgColor: AppColors.bg_secondary_subtle,
              radius: 0,
              padding: 0.pading,
            ),
            const Divider(
              color: AppColors.border_tertiary,
              height: 0,
              thickness: 1,
            ),
            ...List.generate(
              widget.list.length,
              (index) => _buildTag(index),
            ),
            _buildAdd(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Tên thành phần',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 1),
        Text(
          'Hàm lượng',
          textAlign: TextAlign.left,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 1),
        48.width,
      ],
    ).padding(12.pading);
  }

  _buildAdd(BuildContext context) {
    return Container(
      padding: 12.pading,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.bg_primary,
            AppColors.grey10,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ChipDashBorder(
          onTap: widget.onAdd,
          padding: 16.padingHor + 6.padingVer,
          color: AppColors.text_secondary,
          title: 'Thêm thành phần',
          titleStyle: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_secondary,
          ),
          suffixIcon: const Icon(
            Icons.add,
            size: 16,
            color: AppColors.fg_tertiary,
          ),
        ),
      ),
    );
  }

  _buildTag(int index) {
    final String? w =  widget.list[index].weight;
    return Row(
      children: [
        Text(
          widget.list[index].name ?? '',
          style: AppStyle.bodyBsMedium.copyWith(
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).container(padding: 12.padingHor).expanded(flex: 1),
        Text(
          w != null
              ? w
              : '-',
          style:AppStyle.bodyBsMedium.copyWith(
            height: 1.2,
          ),
        ).expanded(),
        _buildMenu(
          index,
          IconBtn(
            backgroundColor: Colors.transparent,
            icon: FaIcon(iconCode: 'f142', size: 12),
            size: const Size(48, 48),
          ),
        ),
      ],
    ).container(
      padding: 20.padingVer,
      radius: 0,
      border: const Border(
        bottom: BorderSide(color: AppColors.border_tertiary),
      ),
    );
  }

  _buildMenu(int index,  Widget child) {
    return  PopupMenuButton(
      color: AppColors.bg_primary,
      shape: RoundedRectangleBorder(
        borderRadius: 8.radius,
        side: const BorderSide(color: AppColors.border_tertiary),
      ),
      constraints: const BoxConstraints(
        maxWidth: 250,
        minWidth: 250,
      ),
      elevation: 1,
      offset: const Offset(0, 30),
      child: child,
      itemBuilder: (context) => [
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
          label: 'Chỉnh sửa',
          onTap: () {
            widget.onUpdate?.call(index);
          },
        ),
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
          onTap: () {
            widget.onRemove?.call(index);
          },
        ),
      ],
    );
  }

  PopupMenuItem _menuItem({
    required IconData icon,
    required String label,
    Color? color,
    Function()? onTap,
    bool enabled = true,
  }) {
    return PopupMenuItem(
      padding: 10.padingVer + 16.padingHor,
      height: 40,
      onTap: onTap,
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
