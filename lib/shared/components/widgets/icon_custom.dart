import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

Widget IconCustom({
  required Widget icon,
  required Color color,
}) {
  return Container(
    padding: 8.pading,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: color.withOpacity(0.05),
      ),
    ),
    child: Container(
      padding: 8.pading,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
      ),
      child: Container(
        padding: 6.pading,
        decoration: BoxDecoration(
          color: AppColors.bg_primary,
          shape: BoxShape.circle,
          boxShadow: AppShadows.elevator1,
        ),
        child: Container(
          padding: 6.pading,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: icon,
        ),
      ),
    ),
  );
}

Widget IconBorderCustom({
  required Widget icon,
  required Color color,
}) {
  return Container(
    padding: 8.pading,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: color.withOpacity(0.05)),
    ),
    child: Container(
      padding: 8.pading,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
      ),
      child: Container(
        padding: 6.pading,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: icon,
      ),
    ),
  );
}

Widget IconSpecial({
  required String svgPath,
  Widget? icon,
  Color? color,
  Color? colorSvg,
}) {
  return Container(
    padding: 8.pading,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: (color ?? AppColors.border_primary).withOpacity(0.05),
      ),
    ),
    child: Container(
      padding: 8.pading,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: (color ?? AppColors.border_primary).withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Container(
        padding: 12.pading,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (color ?? AppColors.fg_tertiary).withOpacity(0.15),
        ),
        child: icon ??
            SvgPicture.asset(
              svgPath,
              color: colorSvg ?? AppColors.fg_tertiary,
              height: 32,
              width: 32,
            ),
      ),
    ),
  );
}
