import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

Widget SearchFilterCustom({
  Function(String)? onChange,
  Function(String)? onConfirm,
  Function()? onTap,
  String? value,
  bool isActive = false,
  required String hintText,
  VoidCallback? clear,
  VoidCallback? inputTap,
  TextEditingController? controller,
  Widget? prefix,
  Widget? suffixIcon,
  Widget? actionWidget,
  Color? backgroundColor,
}) {
  return Row(
    children: [
      AppInputV2(
        onTap: inputTap,
        backgroundColor: backgroundColor,
        hintText: hintText,
        onChanged: onChange,
        onConfirm: onConfirm,
        initialValue: controller != null ? null : value,
        controller: controller,
        prefixIcon: prefix ??
            const Icon(
              Icons.search,
              color: AppColors.input_iconDefault,
            ),
        borderColor: AppColors.input_borderDefault,
        suffixIcon: suffixIcon ??
            (clear != null
                ? InkWell(
                    onTap: clear,
                    child: const Icon(
                      Icons.clear_outlined,
                      size: 16,
                    ),
                  )
                : null),
        radius: 40,
        contentPadding: 12.padingHor,
      ).size(height: 40).expanded(),
      if (onTap != null) ...[
        12.width,
        Stack(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: 50.radius,
              child: actionWidget ?? SvgPicture.asset(Assets.iconsIcFilter),
            ),
            if (isActive)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.bg_primary,
                      width: 2,
                    ),
                    color: AppColors.ultility_brand_60,
                  ),
                ),
              ),
          ],
        ),
      ],
    ],
  );
}
