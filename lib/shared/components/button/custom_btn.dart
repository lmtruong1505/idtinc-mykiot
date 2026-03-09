import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../style_app/init_style.dart';

Widget CustomBtn({
  required String? title,
  Function()? onPressed,
  Function()? onLongPress,
  Widget? icon,
  Color? backgroundColor,
  double radius = Dimensions.sp8,
  BorderSide side = BorderSide.none,
  EdgeInsets? padding,
  TextStyle? textStyle,
  Size? fixedSize,
}) {
  return TextButton(
    onPressed: onPressed,
    onLongPress: onLongPress,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor ?? ColorApp.main,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: Dimensions.sp8,
            horizontal: Dimensions.sp12,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: radius.radius,
        side: side,
      ),
      fixedSize: fixedSize,
    ),
    child: RichText(
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: icon,
            ),
          if (icon != null)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox(
                width: Dimensions.sp8,
              ),
            ),
          if (title != null)
            TextSpan(
              text: title,
              style: textStyle ?? AppStyle.bodyBsBold,
            ),
        ],
      ),
    ),
  );
}

Widget CustomOutlineBtn({
  String? title,
  Function()? onPressed,
  Function()? onLongPress,
  Widget? icon,
  Color? backgroundColor,
  Color? borderColor,
  Color? textColor,
  double radius = Dimensions.sp8,
  Alignment? alignment,
  EdgeInsets? padding,
  Size? fixedSize,
  TextStyle? textStyle,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    onLongPress: onLongPress,
    style: OutlinedButton.styleFrom(
      backgroundColor: backgroundColor ?? ColorApp.main,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: Dimensions.sp12,
            horizontal: Dimensions.sp16,
          ),
      alignment: alignment,
      fixedSize: fixedSize,
      shape: RoundedRectangleBorder(
        borderRadius: radius.radius,
        side: BorderSide(color: borderColor ?? ColorApp.greyF2),
      ),
    ),
    child: RichText(
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: icon,
            ),
          if (icon != null && title != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Dimensions.sp8.width,
            ),
          if (title != null)
            TextSpan(
              text: title,
              style:textStyle ?? StyleApp.normal(
                color: textColor,
              ),
            ),
        ],
      ),
    ),
  );
}

Widget OutlineBtnFilter({
  required String title,
  Function()? onPressed,
  Function()? onClosed,
  Widget? icon,
  Widget? closeIcon,
  Color? backgroundColor,
  Color? borderColor,
  TextStyle? textStyle,
  double radius = Dimensions.sp8,
  Alignment? alignment,
  EdgeInsets? padding,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: backgroundColor ?? ColorApp.main,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: Dimensions.sp12,
            horizontal: Dimensions.sp16,
          ),
      alignment: alignment,
      shape: RoundedRectangleBorder(
        borderRadius: radius.radius,
        side: BorderSide(
          color: borderColor ?? ColorApp.greyF2,
        ),
      ),
    ),
    child: Row(
      children: [
        if (icon != null) icon,
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? StyleApp.semibold(),
          ),
        ),
        if (closeIcon != null) InkWell(onTap: onClosed, child: closeIcon),
      ],
    ),
  );
}

Widget BtnStatusCount({
  int count = 0,
  required String title,
  bool isActive = false,
  Function()? onPressed,
  Color colorActive = ColorApp.main,
  Color colorInActive = ColorApp.white,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: isActive ? colorActive : colorInActive,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: StyleApp.semibold(
              color: isActive ? ColorApp.white : ColorApp.grey79,
            ),
          ),
          8.width,
          Container(
            height: 24,
            constraints: const BoxConstraints(minWidth: 24),
            decoration: BoxDecoration(
              color: isActive ? ColorApp.white : ColorApp.greenE6,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            padding: 2.pading,
            child: Text(
              count.toString(),
              style: StyleApp.semibold(
                color: isActive ? colorActive : ColorApp.main,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget BtnFilter({
  required String title,
  required IconData icon,
  Function()? onPressed,
  Function()? onClosed,
}) {
  return OutlineBtnFilter(
    onPressed: onPressed,
    onClosed: onClosed,
    title: title,
    textStyle: StyleApp.normal(),
    alignment: Alignment.centerLeft,
    backgroundColor: ColorApp.white,
    padding: EdgeInsets.zero,
    borderColor: ColorApp.greyE2,
    icon: Padding(
      padding: Dimensions.sp16.padingHor + Dimensions.sp12.padingVer,
      child: Icon(
        icon,
        color: ColorApp.black,
      ),
    ),
    closeIcon: Padding(
      padding: Dimensions.sp16.padingHor + Dimensions.sp12.padingVer,
      child: const Icon(
        Icons.close,
        size: 20,
        color: ColorApp.grey79,
      ),
    ),
  );
}

Widget RowBtn({
  Function()? onCancel,
  Function()? onConfirm,
  String? cancelText,
  String? confirmText,
}) {
  return Row(
    children: [
      CustomOutlineBtn(
        title: cancelText ?? 'Huỷ bỏ',
        radius: 8,
        onPressed: onCancel,
        backgroundColor: ColorApp.white,
        borderColor: ColorApp.greyE2,
      ).expanded(),
      16.width,
      CustomOutlineBtn(
        title: confirmText ?? 'Xác nhận',
        onPressed: onConfirm,
        backgroundColor: ColorApp.main,
        textColor: ColorApp.white,
        radius: 8,
      ).expanded(),
    ],
  );
}
