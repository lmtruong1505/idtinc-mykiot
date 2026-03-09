import 'package:flutter/material.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

Widget DividerCustom({
  Color? color = AppColors.border_tertiary,
  bool isVertival = false,
  double space = 0,
}) {
  return !isVertival
      ? Divider(
          height: space,
          thickness: 1,
          color: color,
        )
      : VerticalDivider(
          width: space,
          thickness: 1,
          color: color,
        );
}
