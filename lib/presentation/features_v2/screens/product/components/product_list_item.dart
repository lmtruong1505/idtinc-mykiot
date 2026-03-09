import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:collection/collection.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../base/cache_image.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../models/product/product_v2_model.dart';

class ProductListItem extends StatelessWidget {
  ProductListItem({
    super.key,
    required this.model,
    this.showHead = true,
    this.showUpdateStock = false,
    this.canSelect = false,
    this.onChanged,
    this.onUpdate,
  });

  final ProductV2Model model;
  final bool showHead;
  final bool canSelect;
  final bool? showUpdateStock;
  final dynamic Function(bool?)? onChanged;
  final dynamic Function(ProductV2Model)? onUpdate;

  final delay = DelayCallBack(delay: 1.seconds);

  @override
  Widget build(BuildContext context) {
    final bool isSelling = model.active ?? false;

    final units = model.unit.where(
      (element) => element.sellUnit == true,
    );
    final stock =
        (units.isEmpty ? model.availableStock : units.first.stockChange);

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseCacheImage(
                  loadPharmagoLogo: true,
                  url: model.images?.firstOrNull?.url ?? '',
                  width: 56,
                  height: 56,
                  borderRadius: 4.radius,
                  fit: BoxFit.cover,
                ),
              ],
            ).padding(showHead ? 13.padingVer : 12.padingVer),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showHead && showUpdateStock != true)
                  Row(
                    children: [
                      ChipBadgeCustom(
                        color: isSelling
                            ? AppColors.ultility_positive_60
                            : AppColors.ultility_gray_60,
                        bgColor: isSelling ? null : AppColors.ultility_gray_20,
                        title: isSelling ? 'Đang bán' : 'Đã ẩn',
                        icon: isSelling
                            ? null
                            : FaIcon(
                                iconCode: 'f070',
                                size: 12,
                                color: AppColors.text_tertiary,
                                type: FaIconType.solid,
                              ),
                      ).size(height: 20),
                    ],
                  ),
                2.height,
                Text(
                  model.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyBsMedium.copyWith(
                    height: 1.5,
                    color: isSelling
                        ? AppColors.text_primary
                        : AppColors.text_disable,
                  ),
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: (showUpdateStock != true)
                            ? '${model.unitSell?.sellPrice.formatCurrency} đ'
                            : '${(model.unit.lastOrNull?.sellPrice)?.formatCurrency} đ',
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_secondary,
                        ),
                        children: [
                          TextSpan(
                            text: (showUpdateStock != true)
                                ? '/${model.unitSell?.name}'
                                : '/${model.unit.lastOrNull?.name}',
                            style: AppStyle.bodySmRegular.copyWith(
                              color: AppColors.text_tertiary,
                            ),
                          ),
                        ],
                      ),
                    ).expanded(),
                    12.width,
                    if (stock != 0 && showUpdateStock != true)
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          text: 'Tồn: ',
                          style: AppStyle.bodySmRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                          children: [
                            TextSpan(
                              text: stock.formatPrice(),
                              style: AppStyle.bodyBsMedium.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                          ],
                        ),
                      ).expanded(),
                    if (stock == 0 && showUpdateStock != true)
                      Text(
                        'Hết hàng',
                        textAlign: TextAlign.right,
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_negative,
                        ),
                      ).expanded(),
                    if (showUpdateStock == true)
                      AppInputV2(
                        key: UniqueKey(),
                        initialValue: (model.quantity ?? 0).toString(),
                        hintText: '-',
                        textAlign: TextAlign.center,
                        radius: 6,
                        textInputType: TextInputType.number,
                        contentPadding: EdgeInsets.zero,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8),
                        ],
                        onChanged: (value) {
                          delay.debounce(
                            () {
                              final quantityParse = int.tryParse(value) ?? 0;
                              final updatePrd =
                                  model.copyWith(quantity: quantityParse);
                              onUpdate?.call(updatePrd);
                            },
                          );
                        },
                        prefixIcon: _iconAction(
                          icon: Icons.remove,
                          onTap: () {
                            if ((model.quantity ?? 0) > 0) {
                              final updatePrd = model.copyWith(
                                quantity: (model.quantity ?? 0) - 1,
                              );
                              onUpdate?.call(updatePrd);
                              // context.unFocus();
                            }
                          },
                        ),
                        suffixIcon: _iconAction(
                          icon: Icons.add,
                          isLeft: true,
                          onTap: () {
                            final updatePrd = model.copyWith(
                              quantity: (model.quantity ?? 0) + 1,
                            );
                            onUpdate?.call(updatePrd);
                            // context.unFocus();
                          },
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(maxWidth: 32, maxHeight: 32),
                        suffixIconConstraints:
                            const BoxConstraints(maxWidth: 32, maxHeight: 32),
                        borderColor: AppColors.border_secondary,
                      ).size(height: 32, width: 100),
                    // if(model.availableStock == 0 || !isSelling)
                    //   Text(
                    //     !isSelling ? 'Đã ẩn' : 'Hết hàng',
                    //     style: AppStyle.bodyBsMedium.copyWith(
                    //       color: AppColors.text_negative,
                    //     ),
                    //   ).padding(2.padingLeft),
                  ],
                ),
                8.height,
                Visibility(
                  visible: model.totalSold != null && showUpdateStock != true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Đã mua: ',
                          style: AppStyle.bodyBsMedium.copyWith(
                            color: AppColors.text_secondary,
                          ),
                          children: [
                            TextSpan(
                              text: '${model.totalSold}',
                              style: AppStyle.bodySmRegular.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ],
                        ),
                      ).expanded(),
                      12.width,
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          text: 'Tổng tiền: ',
                          style: AppStyle.bodySmRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                          children: [
                            TextSpan(
                              text: model.totalRevenue.formatPrice(),
                              style: AppStyle.bodyBsMedium.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                          ],
                        ),
                      ).expanded(),
                    ],
                  ),
                ),
              ],
            ).expanded(),
          ],
        ),
        if (showHead)
          const Positioned(
            top: 0,
            right: 0,
            child: Icon(
              CupertinoIcons.arrow_up_right,
              size: 16,
              color: AppColors.fg_quaternary,
            ),
          ),
      ],
    ).padding(12.padingHor);
  }
}

InkWell _iconAction({
  required Function() onTap,
  required IconData icon,
  bool isLeft = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        border: Border(
          right: isLeft
              ? BorderSide.none
              : const BorderSide(
                  color: AppColors.border_secondary,
                  width: 1,
                ),
          left: !isLeft
              ? BorderSide.none
              : const BorderSide(
                  color: AppColors.border_secondary,
                  width: 1,
                ),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 12,
        ),
      ),
    ),
  );
}
