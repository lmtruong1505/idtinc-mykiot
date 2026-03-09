import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../base/cache_image.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../shared/utils/event.dart';


class VariantPreviewCard extends StatelessWidget {
  const VariantPreviewCard({
    super.key,
    required this.item,
    this.borderColor,
    this.backgroundColor,
    this.isSelected,
    this.onRemove,
  });

  final Color? borderColor;
  final Color? backgroundColor;
  final VariantEntity item;
  final bool? isSelected;
  final Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(sp12).copyWith(top: sp4),
          margin: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp16).copyWith(bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            border: Border.all(color: borderColor ?? whiteColor),
            color: backgroundColor ?? whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: sp12),
                    child: SizedBox(
                      height: 65,
                      width: 65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(sp8),
                        child: BaseCacheImage(
                          url: item.media ?? PrefKeys.imgProductDefault,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: sp12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: p5.copyWith(color: blackColor),
                        ),
                        const SizedBox(height: sp4),
                        Wrap(
                          runSpacing: 2,
                          spacing: 5,
                          children: [
                            Text(
                              '${FormatCurrency(item.priceSell.validator - item.discount)}đ',
                              style: p7.copyWith(color: accentColor_1),
                            ),
                            Visibility(
                              visible: isSelected ?? false,
                              child: Text(
                                'Đã chọn: ${item.amount}SP - ${FormatCurrency((item.priceSell.validator - item.discount)* item.amount )}đ',
                                style: p7.copyWith(color: blackColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        isSelected == true
            ? Positioned(
          right: sp8,
          top: sp4,
          child: InkWell(
            onTap: () {
              onRemove?.call();
            },
            child: Container(
              padding: const EdgeInsets.all(sp4),
              decoration: BoxDecoration(
                color: red_1,
                borderRadius: BorderRadius.circular(sp12),
              ),
              child: const Icon(
                Icons.remove,
                color: whiteColor,
                size: sp16,
              ),
            ),
          ),
        )
            : const SizedBox.shrink(),
      ],
    );
  }
}
