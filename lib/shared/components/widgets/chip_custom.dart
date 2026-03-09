import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import '../../../presentation/constants/spacing.dart';
import '../../../presentation/features/company/domain/enum/enum_data.dart';

Widget ChipCustom({
  required Color color,
  required String title,
  EdgeInsets? padding,
  Function()? onTap,
  bool isActive = false,
  Widget? suffixIcon,
  Widget? perfixIcon,
  TextStyle? titleStyle,
  bool isBorder = true,
  BorderRadius? borderRadius,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: onTap != null ? 3.pading : 0.pading,
      decoration: onTap != null
          ? BoxDecoration(
              borderRadius: 30.radius,
              border: Border.all(
                color: isActive ? color : Colors.transparent,
              ),
            )
          : null,
      child: Container(
        padding: padding ?? (6.padingHor + 2.5.padingVer),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: isBorder
              ? Border.all(
                  color: color.withOpacity(0.2),
                )
              : null,
          borderRadius: borderRadius ?? 20.radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (perfixIcon != null) perfixIcon,
            if (perfixIcon != null) 4.width,
            Text(
              title,
              style: titleStyle?.copyWith(color: color) ??
                  AppStyle.bodyXsBold.copyWith(
                    color: color,
                  ),
            ).flexible(),
            if (suffixIcon != null) 4.width,
            if (suffixIcon != null) suffixIcon,
          ],
        ),
      ),
    ),
  );
}

Widget ChipDashBorder({
  required Color color,
  required String title,
  TextStyle? titleStyle,
  EdgeInsets? padding,
  Function()? onTap,
  bool isActive = false,
  Widget? suffixIcon,
  Widget? perfixIcon,
  Radius? radius,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: onTap != null ? 3.pading : 0.pading,
      decoration: onTap != null
          ? BoxDecoration(
              borderRadius: 30.radius,
              border: Border.all(
                color: isActive ? color : Colors.transparent,
              ),
            )
          : null,
      child: DottedBorder(
        color: color.withOpacity(0.2),
        strokeWidth: 1,
        radius: radius ?? const Radius.circular(20),
        borderType: BorderType.RRect,
        borderPadding: 0.pading,
        child: Center(
          child: Container(
            padding: padding ?? (6.padingHor + 1.2.padingVer),
            decoration: BoxDecoration(
              borderRadius: 20.radius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (perfixIcon != null) perfixIcon,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle?.copyWith(color: color) ??
                      AppStyle.bodyXsBold.copyWith(
                        color: color,
                      ),
                ).flexible(),
                if (suffixIcon != null) ...[sp4.width, suffixIcon],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget ChipBadgeCustom({
  required Color color,
  required String title,
  EdgeInsets? padding,
  Widget? icon,
  Color? bgColor,
}) {
  return Container(
    padding: padding ?? (6.padingHor + 2.5.padingVer),
    decoration: BoxDecoration(
      color: bgColor ?? AppColors.bg_primary,
      borderRadius: 20.radius,
      boxShadow: AppShadows.elevator0 + AppShadows.elevator0,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ??
            Icon(
              Icons.circle,
              color: color,
              size: 6,
            ),
        4.width,
        Text(
          title,
          style: AppStyle.bodyXsBold.copyWith(
            color: color,
          ),
        ).flexible(),
      ],
    ),
  );
}

Widget ChipBadgeCustomEmp({
  required EmployeeStatus status,
}) {
  return Container(
    padding: 6.padingHor + 2.5.padingVer,
    decoration: BoxDecoration(
      color: status.getBackground,
      borderRadius: 20.radius,
      border: Border.all(
        color: status.borderColor,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status.icon != null) status.icon!,
        if (status.icon != null) 4.width,
        Text(
          status.title,
          style: AppStyle.bodyXsBold.copyWith(
            color: status.mainColor,
          ),
        ).flexible(),
      ],
    ),
  );
}

extension EmployeeStatusExt on EmployeeStatus {
  Color get mainColor {
    switch (this) {
      case EmployeeStatus.pending:
        return AppColors.ultility_carrot_60;
      case EmployeeStatus.refuse:
        return AppColors.ultility_negative_60;
      case EmployeeStatus.active:
        return AppColors.ultility_positive_60;
      case EmployeeStatus.suspended:
        return AppColors.ultility_negative_60;
      case EmployeeStatus.terminate:
        return AppColors.ultility_gray_60;
      case EmployeeStatus.declined:
        return AppColors.ultility_negative_60;
      default:
        return AppColors.ultility_negative_60;
    }
  }

  Color get getBackground {
    switch (this) {
      case EmployeeStatus.pending:
        return AppColors.bg_primary;
      case EmployeeStatus.refuse:
        return AppColors.ultility_negative_10;
      case EmployeeStatus.active:
        return AppColors.ultility_positive_10;
      case EmployeeStatus.suspended:
        return AppColors.bg_primary;
      case EmployeeStatus.terminate:
        return AppColors.ultility_gray_10;
      case EmployeeStatus.declined:
        return AppColors.ultility_negative_10;
      default:
        return AppColors.ultility_positive_10;
    }
  }

  Color get borderColor {
    switch (this) {
      case EmployeeStatus.pending:
        return AppColors.ultility_carrot_20;
      case EmployeeStatus.refuse:
        return AppColors.ultility_negative_20;
      case EmployeeStatus.active:
        return AppColors.ultility_positive_20;
      case EmployeeStatus.suspended:
        return AppColors.ultility_gray_20;
      case EmployeeStatus.terminate:
        return AppColors.ultility_gray_20;
      case EmployeeStatus.declined:
        return AppColors.ultility_negative_20;
      default:
        return AppColors.ultility_positive_20;
    }
  }

  Icon? get icon {
    switch (this) {
      case EmployeeStatus.pending:
        return Icon(
          Icons.circle,
          color: mainColor,
          size: 6,
        );
      case EmployeeStatus.refuse:
        return Icon(
          Icons.close_outlined,
          color: mainColor,
          size: 10,
        );
      case EmployeeStatus.active:
        return Icon(
          Icons.circle,
          color: mainColor,
          size: 6,
        );
      case EmployeeStatus.suspended:
        return Icon(
          Icons.pause,
          color: mainColor,
          size: 10,
        );
      case EmployeeStatus.declined:
        return Icon(
          Icons.close_outlined,
          color: mainColor,
          size: 10,
        );
      case EmployeeStatus.terminate:
        return null;
      case EmployeeStatus.all:
        return null;
    }
  }
}
