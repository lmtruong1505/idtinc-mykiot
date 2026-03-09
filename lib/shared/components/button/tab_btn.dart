import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import '../widgets/badge_custom.dart';

Widget TabBtn({
  required String label,
  Color? color,
  int count = 0,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        overflow: TextOverflow.ellipsis,
      ).flexible(),
      if (count > 0) ...[
        6.width,
        BadgeCustom(
          count: count,
          color: color ?? AppColors.ultility_gray_60,
        ),
      ],
    ],
  );
}
