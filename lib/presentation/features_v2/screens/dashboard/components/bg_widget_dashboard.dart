import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';

Widget BgWidgetDashboard({
  required Widget child,
  EdgeInsets? padding,
}) {
  return Container(
    padding: padding ?? 16.pading,
    decoration: BoxDecoration(
      borderRadius: 16.radius,
      color: ColorApp.white,
      border: Border.all(
        color: AppColors.border_tertiary,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0C101828),
          blurRadius: 2,
          offset: Offset(0, 1),
          spreadRadius: 0,
        ),
      ],
    ),
    child: child,
  );
}
