import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class ProductInCf extends StatelessWidget {
  const ProductInCf({super.key, required this.idx, required this.model});

  final int idx;
  final ProductV2Model model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 12.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$idx.',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              6.width,
              BaseCacheImage(
                url: model.images?.firstOrNull?.url ?? '',
                width: 56,
                height: 56,
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name ?? 'Không có thông tin',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.bodySmMedium.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ).size(height: 34),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'SL: ',
                          style: AppStyle.bodySmMedium.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                        TextSpan(
                          text: model.quantity.formatCurrency,
                          style: AppStyle.bodySmMedium,
                        ),
                        TextSpan(
                          text: ' ${model.unitSell?.name}',
                          style: AppStyle.bodySmMedium.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  2.height,
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${(model.unitSell?.realPrice ?? 0).formatCurrency} đ',
                              style: AppStyle.headingBs,
                            ),
                            if (model.chietKhau.formatCurrency != '0')
                              TextSpan(
                                text: ' - ${model.chietKhau.formatCurrency}đ',
                                style: AppStyle.bodySmRegular.copyWith(
                                  color: AppColors.text_tertiary,
                                ),
                              ),
                          ],
                        ),
                      ).expanded(),
                      Text(
                        '${(((model.unitSell?.realPrice ?? 0) - (model.chietKhau.validator)) * (model.quantity ?? 0)).formatCurrency} đ',
                        style: AppStyle.headingMd.copyWith(
                          color: AppColors.text_brand_primary_variant1,
                        ),
                      ),
                    ],
                  ),
                ],
              ).expanded(),
            ],
          ),
          12.height,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(sp12),
            decoration: BoxDecoration(
              color: AppColors.brand5,
              borderRadius: BorderRadius.circular(sp12),
            ),
            child: Wrap(
              runSpacing: sp12,
              spacing: sp12,
              children: model.listShipmentItemByQuantity.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp2,
                    horizontal: sp8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp4),
                    color: AppColors.bg_black.withOpacity(0.05),
                  ),
                  child: Text(
                    'Lô ${e.code} - SL: ${e.selectedQuantity ~/ model.valueUnitChange} ${model.unitSell?.name}',
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
