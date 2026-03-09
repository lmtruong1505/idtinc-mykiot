import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/icon_btn.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../models/product/unit_v2_model.dart';

class ItemCreateUnit extends StatefulWidget {
  const ItemCreateUnit(
      {super.key,
      required this.units,
      required this.onAdd,
      this.onRemove,
      this.onUpdate,
      this.canEdit = true});

  final List<UnitV2Model> units;
  final Function() onAdd;
  final Function(int)? onRemove;
  final Function(int)? onUpdate;
  final bool canEdit;

  @override
  State<ItemCreateUnit> createState() => _ItemCreateUnitState();
}

class _ItemCreateUnitState extends State<ItemCreateUnit> {
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
              widget.units.length,
              (index) => _buildTag(index),
            ),
            if(widget.canEdit)_buildAdd(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Cấp',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 1),
        Text(
          'Quy đổi',
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
          title: 'Thêm đơn vị',
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

  Widget _buildTag(int index) {
    final styleAbove = AppStyle.bodyBsRegular.copyWith(
      color: AppColors.text_secondary,
    );
    final styleBelow = AppStyle.bodyMdMedium;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cấp ${widget.units[index].level} \n ${widget.units[index].name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: index != 0
                      ? styleAbove
                      : styleBelow.copyWith(
                          color: widget.units[index].sellUnit ?? false
                              ? AppColors.ultility_carrot_60
                              : null,
                        ),
                  // style: AppStyle.bodyBsMedium.copyWith(
                  //   color: widget.units[index].level == 1 ? AppColors.ultility_carrot_60 : null,
                  // ),
                ),
                if (index != 0) 4.height,
                if (index != 0)
                  Text(
                    '${widget.units[index].name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: styleBelow,
                  ),
              ],
            ).container(padding: 12.padingHor).expanded(flex: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  index == 0
                      ? '1 ${widget.units[index].name}'
                      : '1 ${widget.units[index - 1].name} ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: index != 0 ? styleAbove : styleBelow,
                ),
                if (index != 0) 4.height,
                if (index != 0)
                  Text(
                    '= ${widget.units[index].value} ${widget.units[index].name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: styleBelow,
                  ),
              ],
            ).expanded(flex: 1),
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
        ),
        if (widget.units[index].sellUnit ?? false)
          Container(
            height: 32,
            width: 4,
            decoration: BoxDecoration(
              color: AppColors.ultility_carrot_60,
              borderRadius: 8.radiusRight,
            ),
          ),
      ],
    );
  }

  _buildMenu(int index, Widget child) {
    return PopupMenuButton(
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
            if (widget.canEdit) {
              widget.onUpdate?.call(index);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Đã phát sinh đơn hàng hoặc nhập kho , không sửa đơn vị bán!'),
                  backgroundColor: AppColors.red60,
                  duration: Duration(seconds: 2),
                ),
              );
            }
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
            if (widget.canEdit) {
              widget.onRemove?.call(index);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Đã phát sinh đơn hàng hoặc nhập kho , không sửa đơn vị bán!'),
                  backgroundColor: AppColors.red60,
                  duration: Duration(seconds: 2),
                ),
              );
            }
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
