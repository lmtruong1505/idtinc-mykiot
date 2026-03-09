import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/typography.dart';
import '../../../../shared/utils/event.dart';

class CardProductConfirmOrder extends StatelessWidget {
  const CardProductConfirmOrder({
    super.key,
    required this.variant,
  });

  final VariantEntity variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: variant.amount != 0,
          child: RowItemCardProductConfirmOrder(
            title: '${variant.name ?? ''} (${variant.unit?.name ?? ''})',
            amount: variant.amount.toString(),
            total:
            '${FormatCurrency(variant.amount * ((variant.unit?.sellPrice.validator ?? 0) - variant.discount.validator))}đ',
          ),
        ),
        // Visibility(
        //   visible: variant.amount != 0,
        //   child: const SizedBox(height: sp12),
        // ),
        // Visibility(
        //   visible: variant.amount != 0,
        //   child: RowItemCardProductConfirmOrder(
        //     title: variant.name ?? '',
        //     amount: variant.amount.toString(),
        //     total: '${FormatCurrency(variant.amount * (variant.priceSell ?? 0))}đ',
        //   ),
        // ),
        // Visibility(
        //   visible: variant.amount != 0,
        //   child: const SizedBox(height: sp12),
        // ),
        // // Promotion in Variant
        // ListView.separated(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   itemBuilder: (context, index) {
        //     final promo = variant.promotionDetailEntity?[index];
        //     // Promotion Item Data
        //     return ListView.separated(
        //       shrinkWrap: true,
        //       physics: const NeverScrollableScrollPhysics(),
        //       itemBuilder: (context, index) {
        //         final promoItem = promo?.promotionItemData?[index];
        //         // Variant in Item Data
        //         return Visibility(
        //           visible: promoItem?.quantitySelected != 0,
        //           child: ListView.separated(
        //             shrinkWrap: true,
        //             physics: const NeverScrollableScrollPhysics(),
        //             itemBuilder: (context, index) {
        //               final variant = promoItem?.variantValueData?[index];
        //               return RowItemCardProductConfirmOrder(
        //                 title: variant?.title ?? '',
        //                 amount:
        //                 '${(variant?.quantity ?? 0) * (promoItem?.quantitySelected ?? 0)}',
        //                 total: '0đ',
        //                 color: borderColor_4,
        //               );
        //             },
        //             separatorBuilder: (context, index) =>
        //             const SizedBox(height: sp12),
        //             itemCount: promoItem?.variantValueData?.length ?? 0,
        //           ),
        //         );
        //       },
        //       separatorBuilder: (context, index) => Visibility(
        //         visible:
        //         promo?.promotionItemData?[index].quantitySelected != 0,
        //         child: const SizedBox(height: sp12),),
        //       itemCount: promo?.promotionItemData?.length ?? 0,
        //     );
        //   },
        //   separatorBuilder: (context, index) => const SizedBox(height: sp12),
        //   itemCount: variant.promotionDetailEntity?.length ?? 0,
        // ),
      ],
    );
  }
}

class RowItemCardProductConfirmOrder extends StatelessWidget {
  const RowItemCardProductConfirmOrder({
    super.key,
    required this.title,
    required this.amount,
    required this.total,
    this.color,
    this.style,
  });

  final String title;
  final String amount;
  final String total;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: (style ?? p5).copyWith(color: color ?? blackColor),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            amount,
            style: (style ?? p5).copyWith(color: color ?? blackColor),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            total,
            style: (style ?? p5).copyWith(color: color ?? blackColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
