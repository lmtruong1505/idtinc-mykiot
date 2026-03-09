import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class ItemPriceCreate extends StatelessWidget {
  final ServiceTypeV2Model item;
  final Function()? remove;
  final Function()? callBack;
  final Function(int)? setDefault;
  final Function(int)? removePrice;
  final Function(int?)? addOrUpdate;
  final bool isDetail;
  const ItemPriceCreate({
    super.key,
    required this.item,
    this.remove,
    this.callBack,
    this.setDefault,
    this.removePrice,
    this.isDetail = false,
    this.addOrUpdate,
  });

  @override
  Widget build(BuildContext context) {
    item.prices ??= [];
    return Container(
      decoration: BoxDecoration(
        borderRadius: 12.radius,
        border: Border.all(color: AppColors.border_tertiary),
      ),
      child: ClipRRect(
        borderRadius: 12.radius,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              item.prices!.length,
              (index) => _buildTag(index),
            ),
            if (!isDetail) _buildAdd(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(int index) {
    final price = item.prices![index];
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  price.priceName ?? 'Vé lượt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: price.isActive ? AppColors.ultility_carrot_60 : null,
                  ),
                ),
                if (price.priceName != null) 4.height,
                if (price.priceName != null)
                  Text(
                    price.count == null
                        ? '(Không giới hạn)'
                        : '(${price.count.formatPrice()} ${item.type == "MEMBERSHIP" ? 'lượt' : "buổi"})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.bodySmRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
              ],
            ).container(padding: 12.padingHor).expanded(flex: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  price.price.formatPrice(type: ' đ'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodyBsMedium,
                ),
                4.height,
                Text(
                  '/${price.valueName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ).expanded(flex: 1),
            12.width,
            if (!isDetail)
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
        if (price.isActive)
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

  Widget _buildMenu(
    int index,
    Widget child,
  ) {
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
            addOrUpdate?.call(index);
          },
        ),
        _menuItem(
          icon: Icons.star_border,
          label: 'Đặt làm giá cơ sở',
          color: AppColors.ultility_carrot_60,
          onTap: () {
            setDefault?.call(index);
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
            removePrice?.call(index);
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

  Widget _buildHeader() {
    return Row(
      children: [
        12.width,
        Text(
          item.title ?? '',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 2),
        Text(
          'Giá',
          textAlign: TextAlign.right,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 1),
        12.width,
        if (!isDetail)
          // IconBtn(
          //   onTap: remove,
          //   backgroundColor: Colors.transparent,
          //   icon: FaIcon(iconCode: 'f1f8', size: 12),
          //   size: const Size(48, 32),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChipCustom(
                onTap: remove,
                color: AppColors.ultility_negative_60,
                title: 'Xoá',
                isBorder: false,
                padding: 10.padingHor + 3.padingVer,
              ),
            ],
          ).size(width: 48),
      ],
    ).size(height: 32);
  }

  Widget _buildAdd(BuildContext context) {
    if (item.type == 'SINGLE' && item.prices?.isNotEmpty == true) {
      return const SizedBox();
    }

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
          onTap: () => addOrUpdate?.call(null),
          padding: 16.padingHor + 6.padingVer,
          color: AppColors.text_secondary,
          title: 'Thêm',
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
}
