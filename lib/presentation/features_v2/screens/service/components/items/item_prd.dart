import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../config/app_style/init_app_style.dart';
import '../../../../models/product/product_v2_model.dart';

class ItemPrdService extends StatelessWidget {
  final bool isList;
  final bool isActive;
  final Function()? remove;
  final ProductV2Model product;
  const ItemPrdService({
    super.key,
    this.isList = false,
    this.isActive = false,
    this.remove,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelling = product.active ?? false;
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isList)
                  Icon(
                    isActive ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 20,
                    color: isActive
                        ? AppColors.ultility_positive_60
                        : AppColors.border_tertiary,
                  ).padding(
                    12.padingRight,
                  ),
                BaseCacheImage(
                  url: product.images?.firstOrNull?.url ?? '',
                  width: 56,
                  height: 56,
                  borderRadius: 4.radius,
                  fit: BoxFit.cover,
                ),
              ],
            ).padding(26.padingTop),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ChipBadgeCustom(
                      color: isSelling
                          ? AppColors.ultility_positive_60
                          : AppColors.ultility_gray_60,
                      bgColor: isSelling ? null : AppColors.ultility_gray_20,
                      title: isSelling ? 'Đang bán' : 'Đã ẩn',
                    ).size(height: 20),
                  ],
                ),
                2.height,
                Text(
                  product.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyBsMedium.copyWith(
                    height: 1.5,
                  ),
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text:
                            '${product.unitSell?.sellPrice.formatPrice() ?? 0} đ',
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_secondary,
                        ),
                        children: [
                          TextSpan(
                            text: '/${product.unitSell?.name ?? ''}',
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
                        text: 'Tồn: ',
                        style: AppStyle.bodySmRegular.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                        children: [
                          TextSpan(
                            text: product.availableStock.formatPrice(),
                            style: AppStyle.bodyBsMedium.copyWith(
                              color: AppColors.text_secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ).expanded(),
          ],
        ),
        if (!isList && remove != null)
          Positioned(
            top: 0,
            right: 0,
            child: IconBtn(
              onTap: remove,
              size: const Size(24, 24),
              icon: const Icon(
                Icons.remove,
                size: 15,
              ),
              padding: 5.pading,
            ),
          ),
      ],
    ).padding(12.pading);
  }
}
