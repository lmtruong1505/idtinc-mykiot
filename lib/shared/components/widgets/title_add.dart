import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

Widget TitleAdd({
  required String labelButton,
  required Function()? onPressed,
  String? title,
  TextStyle? styleTitle,
  Widget? suffixIcon,
}) {
  return Row(
    children: [
      12.width,
      Text(
        title ?? 'Tất cả',
        style: styleTitle ??
            AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_tertiary,
            ),
      ).expanded(),
      16.width,
      if (onPressed != null)
        LabelButton(
          label: labelButton,
          onPressed: onPressed,
          fixedSize: const Size(double.infinity, 32),
          backgroundColor: AppColors.button_neutral_alpha_backgroundDefault,
          labelStyle: AppStyle.bodyBsMedium,
          suffixIcon: suffixIcon ??
              const Icon(
                Icons.add,
                color: AppColors.button_neutral_alpha_iconDefault,
                size: 17,
              ),
        ),
    ],
  ).size(height: 35).padding(6.padingBottom);
}
