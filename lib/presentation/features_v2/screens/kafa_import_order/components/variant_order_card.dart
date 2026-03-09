import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/check_box.dart';
import 'variant_order_expanded_card.dart';

class VariantOrderCard extends StatelessWidget {
  const VariantOrderCard({super.key, required this.variant, this.changeIsReady});

  final VariantKafaModel variant;
  final Function(bool?)? changeIsReady;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 16.radius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseCheckbox(
            value: variant.isReadyForOrder,
            onChanged: (value) {
              changeIsReady?.call(value);
            },
          ),
          8.width,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _basicInfo(),
              8.height,
              VariantOrderExpandedCard(variant: variant,)
            ],
          ).expanded(),
        ],
      ),
    );
  }

  _basicInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseCacheImage(url: variant.image ?? '', width: 64, height: 64),
        8.width,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  variant.title ?? '',
                  style: StyleApp.bold(color: ColorApp.black),
                  maxLines: 2,
                ),
                4.height,
                Row(
                  children: [
                    Text('SL: $quantity',style: StyleApp.bold(color: ColorApp.grey79)).expanded(),
                    Text('${FormatCurrency(quantity * variant.price.validator)}đ', style: StyleApp.bold(color: ColorApp.main),)
                  ],
                ),
                // Text(
                //   'Còn 1000',
                //   style: StyleApp.bold(color: ColorApp.black),
                //   maxLines: 2,
                // ),
              ],
            ).expanded(),
          ],
        ).expanded(),
      ],
    );
  }

  int get quantity {
    return (variant.amount) + variant.promotionDetail.fold(0, (total, promo){
      final totalInPromo = promo.promotionItemData?.fold(0, (total_2, variantPromo){
        return total_2 + (variantPromo.quantitySelected) * (variantPromo.valueMin?.toInt() ?? 0);
      });
      return total + (totalInPromo ?? 0);
    });
  }
}
