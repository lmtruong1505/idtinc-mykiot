import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import 'chip_custom.dart';

Widget FilterItem({
  required String label,
  required List<String> items,
  int? select,
  Function(int)? onTap,
  bool isDivide = true,
  List<bool> chooseList = const [],
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          if (isDivide) ...[
            8.width,
            const Divider().expanded(),
          ],
        ],
      ),
      8.height,
      if (items.isNotEmpty)
        Wrap(
          spacing: 8,
          runSpacing: 2,
          children: List.generate(
            items.length,
            (index) => _customChip(
              label: items[index],
              isActive: index == select ||
                  (chooseList.length == items.length && chooseList[index]),
              onTap: () => onTap?.call(index),
            ),
          ),
        ),
    ],
  );
}

Widget _customChip({
  Function()? onTap,
  bool isActive = false,
  required String label,
}) {
  return ChipCustom(
    color: isActive ? AppColors.ultility_brand_60 : AppColors.ultility_gray_60,
    title: label,
    isActive: isActive,
    onTap: onTap,
    titleStyle: AppStyle.bodyBsMedium,
  );
}
