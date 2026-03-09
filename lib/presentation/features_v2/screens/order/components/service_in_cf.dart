import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../models/service/service.dart';

class ServiceInCf extends StatelessWidget {
  const ServiceInCf({super.key, required this.idx, required this.model});

  final int idx;
  final ServiceV2Model model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 12.pading,
      child: Row(
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
            url: model.images?.firstOrNull ?? '',
            width: 56,
            height: 56,
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title ?? 'Không có thông tin',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodySmRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ).size(height: 34),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'SL: ',
                      style: AppStyle.bodySmRegular.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                    TextSpan(
                      text: model.quantity.formatCurrency,
                      style: AppStyle.bodySmMedium,
                    ),
                    TextSpan(
                      text: ' ${model.price?.priceNameSub}',
                      style: AppStyle.bodySmRegular.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              2.height,
              Row(
                children: [
                  Text(
                    '${(model.priceCustom?.price ?? model.price?.price).formatCurrency} đ',
                    style: AppStyle.bodyBsMedium,
                  ),
                  Visibility(
                    visible: model.discount > 0,
                    child: Text(
                      ' - ${(model.discount).formatCurrency} đ',
                      style: AppStyle.bodyBsRegular
                          .copyWith(color: AppColors.text_tertiary),
                    ),
                  ),
                  Text(
                    '${(((model.priceCustom?.price ?? model.price?.price ?? 0) - model.discount) * model.quantity).formatCurrency} đ',
                    style: AppStyle.headingMd.copyWith(
                      color: AppColors.text_brand_primary_variant1,
                    ),
                    textAlign: TextAlign.right,
                  ).expanded(),
                ],
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
