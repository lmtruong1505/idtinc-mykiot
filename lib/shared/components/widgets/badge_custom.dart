import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

Widget BadgeCustom({
  int count = 0,
  Color color = AppColors.ultility_gray_60,
}) {
  return Container(
    height: 20,
    constraints: const BoxConstraints(
      maxHeight: 20,
      minWidth: 20,
    ),
    padding: 2.padingHor,
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: 16.radius,
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    alignment: Alignment.center,
    child: Text(
      count.toString(),
      style: AppStyle.bodyXsBold.copyWith(
        color: color,
        height: 1,
      ),
    ),
  );
}
