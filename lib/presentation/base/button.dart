import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    this.title,
    this.event,
    this.largeButton = true,
    this.icon,
    this.radius = 12,
  });
  final double radius;
  final String? title;
  final Function()? event;
  final bool largeButton;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button_negative_ghost_iconDefault,
        padding: EdgeInsets.symmetric(
          vertical: largeButton ? sp16 : sp8,
          horizontal: largeButton ? sp16 : sp12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: () {
        event?.call();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && title != null) const SizedBox(width: sp8),
          if (title != null)
            Text(
              title ?? '',
              style: (largeButton ? h6 : p5)
                  .copyWith(color: whiteColor, height: 1),
            ),
        ],
      ),
    );
  }
}

class ExtraButton extends StatelessWidget {
  const ExtraButton({
    super.key,
    this.title,
    this.event,
    this.largeButton = true,
    this.borderColor,
    this.icon,
    this.iconSuffix,
    this.backgroundColor,
    this.borderRadius,
    this.titleColor,
  });

  final String? title;
  final Function()? event;
  final bool largeButton;
  final Color? borderColor;
  final Widget? icon;
  final Widget? iconSuffix;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            backgroundColor?.withOpacity(event == null ? 0.3 : 1) ??
                const Color.fromARGB(0, 0, 0, 0),
        padding: EdgeInsets.symmetric(
          vertical: largeButton ? sp16 : sp8,
          horizontal: largeButton ? sp16 : sp12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? sp12),
        ),
        side: BorderSide(
          style: BorderStyle.solid,
          color: borderColor ?? borderColor_2,
          width: borderColor != null ? 1 : 0,
        ),
      ),
      onPressed: event == null ? null : () => event!.call(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && title != null) const SizedBox(width: sp8),
          if (title != null)
            Flexible(
              child: Text(
                title ?? '',
                style: (largeButton ? h6 : p5)
                    .copyWith(color: titleColor ?? blackColor, height: 1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (iconSuffix != null) ...[8.width, iconSuffix!],
        ],
      ),
    );
  }
}

Widget supportButton({
  required String? title,
  required Function event,
  required bool largeButton,
  required Widget? icon,
  required Color? backgroundColor,
  double? borderRadius,
  Color? color,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: backgroundColor ?? accentColor_1,
      padding: EdgeInsets.symmetric(
        vertical: largeButton ? sp16 : sp8,
        horizontal: largeButton ? sp16 : sp12,
      ),
      shape: RoundedRectangleBorder(borderRadius: (borderRadius ?? 8).radius),
    ),
    onPressed: () {
      event();
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon,
        if (icon != null && title != null) const SizedBox(width: sp8),
        if (title != null)
          Text(
            title,
            style: largeButton
                ? h6.copyWith(color: color ?? blackColor, height: 1)
                : p5.copyWith(color: color ?? blackColor, height: 1),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    ),
  );
}
