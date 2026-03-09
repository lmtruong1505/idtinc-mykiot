import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/constants/colors.dart';
import '../../../presentation/constants/spacing.dart';
import '../../../presentation/constants/typography.dart';
import '../../style_app/init_style.dart';

class MainButtonV2 extends StatelessWidget {
  const MainButtonV2({
    super.key,
    this.title,
    this.onTap,
    this.icon,
    this.textStyle,
    this.backgroundColor,
    this.padding,
    this.radius = Dimensions.sp4,
    this.alignment = Alignment.center,
  });

  final String? title;
  final Function()? onTap;
  final Widget? icon;
  final double radius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorApp.main,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: Dimensions.sp12,
              horizontal: Dimensions.sp16,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: radius.radius,
        ),
        alignment: alignment,
        elevation: 0,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && title != null) Dimensions.sp8.width,
          if (title != null)
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: textStyle ?? s14w500.copyWith(height: 1),
            ),
        ],
      ),
    );
  }
}

Widget SupportButton({
  required String? title,
  required Function event,
  bool largeButton = false,
  Widget? icon,
  Color? backgroundColor,
  double? radius,
  Color? color,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: backgroundColor ?? ColorApp.purple78,
      padding: EdgeInsets.symmetric(
        vertical: largeButton ? sp16 : sp8,
        horizontal: largeButton ? sp16 : sp12,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? sp8)),
    ),
    onPressed: () {
      event();
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon,
        if (icon != null && title != null) const SizedBox(width: 8),
        if (title != null)
          Text(
              title,
              style: (largeButton ? h6 : p5)
                  .copyWith(color: color ?? whiteColor, height: 1),
            ),
      ],
    ),
  );
}
