import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

class BasePriceItem extends StatelessWidget {
  const BasePriceItem({super.key, required this.model, required this.vat, required this.importPrice});

  final UnitV2Model model;
  final double vat;
  final double importPrice;

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
          children: [
            Row(
              children: [
                Text(
                  'Giá bán',
                  style: AppStyle.bodyBsMedium,
                ).expanded(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${model.sellPrice.formatCurrency} đ',
                      style: AppStyle.bodyBsSemiBold,
                    ),
                    Text(
                      '/${model.name}',
                      style: AppStyle.bodyBsRegular.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ).container(
              padding: 20.padingVer + 12.padingHor,
              radius: 0,
              border: const Border(
                bottom: BorderSide(color: AppColors.border_tertiary),
              ),
            ),
            Row(
              children: [
                Text(
                  'Giá nhập ban đầu',
                  style: AppStyle.bodyBsMedium,
                ).expanded(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${importPrice.formatCurrency} đ', style: AppStyle.bodyBsSemiBold,),
                    Text('/${model.name}', style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),),
                  ],
                ),
              ],
            ).container(
              padding: 20.padingVer + 12.padingHor,
              radius: 0,
              border: const Border(
                bottom: BorderSide(color: AppColors.border_tertiary),
              ),
            ),
            Row(
              children: [
                Text(
                  'Thuế VAT',
                  style: AppStyle.bodyBsMedium,
                ).expanded(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${vat.formatCurrency}%', style: AppStyle.bodyBsSemiBold,),
                  ],
                ),
              ],
            ).container(
              padding: 20.padingVer + 12.padingHor,
              radius: 0,
              border: const Border(
                bottom: BorderSide(color: AppColors.border_tertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
