import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';

import 'package:pharmago/shared/ext/init_ext.dart';

import 'label_button.dart';

// ignore: must_be_immutable
class DoubleButton extends StatelessWidget {
  Function()? onCancel;
  Function()? onConfirm;
  String? cancelText;
  String? confirmText;

  DoubleButton({
    super.key,
    this.onCancel,
    this.onConfirm,
    this.cancelText,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LabelButton(
          label: cancelText ?? 'Hủy bỏ',
          onPressed: onCancel,
          backgroundColor: AppColors.button_neutral_alpha_backgroundDefault,
          labelStyle: AppStyle.medium().copyWith(height: 1),
          fixedSize: const Size(double.infinity, 40),
        ).expanded(),
        12.width,
        LabelButton(
          label: confirmText ?? 'Xác nhận',
          onPressed: onConfirm,
          labelStyle: onConfirm == null
              ? AppStyle.bodyMdMedium.copyWith(
                  color: AppColors.button_brand_ghost_textDisabled,
                  height: 1,
                )
              : null,
          fixedSize: const Size(double.infinity, 40),
        ).expanded(),
      ],
    );
  }
}

// ignore: must_be_immutable
class DoubleButtonWithIcon extends StatelessWidget {
  Function()? onCancel;
  Function()? onConfirm;
  String? cancelText;
  String? confirmText;
  Widget? iconConfirm;
  Widget? iconCancel;
  bool equal;
  bool canPressed;

  DoubleButtonWithIcon({
    super.key,
    this.onCancel,
    this.onConfirm,
    this.cancelText,
    this.confirmText,
    this.iconConfirm,
    this.iconCancel,
    this.equal = false,
    this.canPressed = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        equal ? cancelBtn.expanded() : cancelBtn,
        12.width,
        LabelButton(
          label: confirmText ?? 'Xác nhận',
          onPressed: canPressed ? onConfirm : null,
          fixedSize: const Size(double.infinity, 40),
          prefixIcon: iconConfirm,
          labelStyle: AppStyle.bodyMdMedium.copyWith(
            color: canPressed
                ? AppColors.button_brand_solid_textDefault
                : AppColors.button_brand_solid_textDisabled,
          ),
        ).expanded(),
      ],
    );
  }

  Widget get cancelBtn => LabelButton(
        label: cancelText ?? 'Hủy bỏ',
        onPressed: onCancel,
        backgroundColor: AppColors.bg_primary,
        labelStyle: AppStyle.medium(),
        fixedSize: const Size(double.infinity, 40),
        border: const BorderSide(
          color: AppColors.button_neutral_outlined_borderDefault,
          width: 1,
        ),
        prefixIcon: iconCancel,
        padding: 16.padingHor + 8.padingVer,
      );
}
