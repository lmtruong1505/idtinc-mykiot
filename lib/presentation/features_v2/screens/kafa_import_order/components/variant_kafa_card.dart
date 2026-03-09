import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/color_app.dart';
import '../../../../../shared/style_app/style_text.dart';
import '../../../../base/svg.dart';

class VariantKafaCard extends StatelessWidget {
  const VariantKafaCard({super.key, required this.item});

  final VariantKafaPreviewModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 8.radius,
        color: ColorApp.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseCacheImage(
            url: item.image.isEmptyOrNull
                ? PrefKeys.imgProductDefault
                : item.image.validator,
            fit: BoxFit.contain,
          ).size(height: 167.5),
          Expanded(
            child: Padding(
              padding: 8.pading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: StyleApp.medium(fontSize: 12),
                    maxLines: 2,
                  ),
                  8.height,
                  if (item.promotion.validator > 0)
                    Container(
                      decoration: BoxDecoration(
                        color: ColorApp.yellow19,
                        borderRadius: 4.radius,
                      ),
                      padding: 4.padingHor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IcSvg.asset('/ic_badge_per.svg'),
                          2.width,
                          Text(
                            '${item.promotion ?? 0} CTKM',
                            style: StyleApp.normal(
                              color: ColorApp.yellowD2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        item.price.formatPrice(type: 'đ'),
                        style: StyleApp.bold(color: ColorApp.main),
                      ).expanded(),
                      12.width,
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorApp.main,
                        ),
                        padding: 4.pading,
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: ColorApp.white,
                          size: 17,
                        ),
                      ),
                    ],
                  ).padding(8.padingHor),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_rounded,
                        color: ColorApp.grey79,
                      ),
                      4.width,
                      Text(
                        'Giao hàng tận nơi',
                        style: StyleApp.normal(
                          color: ColorApp.grey79,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
