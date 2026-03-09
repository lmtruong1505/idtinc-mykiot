import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import 'dialog_message.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final Widget? content;
  final Function()? close;
  final Function()? confirm;
  final String? closeLabel;
  final String? confirmLabel;
  final bool actionConfirmBorder;
  final IconDiaLog? icon;
  final Color colorConfirmBtn;
  final bool isWarning;
  const DialogConfirm({
    super.key,
    required this.title,
    this.content,
    this.close,
    this.confirm,
    this.closeLabel,
    this.confirmLabel,
    this.icon,
    this.colorConfirmBtn = AppColors.button_brand_solid_backgroundDefault,
    this.actionConfirmBorder = false,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: 16.radius,
      ),
      child: Padding(
        padding: 16.padingHor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            10.height,
            icon ?? const IconDiaLog(),
            4.height,
            Text(
              title,
              style: AppStyle.headingLg,
              textAlign: TextAlign.center,
            ),
            if (content != null) content!.padding(4.padingTop),
            16.height,
            Row(
              children: [
                LabelButton(
                  label: closeLabel ?? 'Huỷ bỏ',
                  backgroundColor: !actionConfirmBorder
                      ? AppColors.button_neutral_alpha_backgroundDefault
                      : AppColors.button_neutral_solid_backgroundDefault,
                  labelStyle: AppStyle.bodyBsMedium.copyWith(
                    color: !actionConfirmBorder
                        ? AppColors.button_neutral_alpha_textDefault
                        : AppColors.button_neutral_solid_textDefault,
                  ),
                  onPressed: close ??
                      () {
                        context.pop();
                      },
                ).expanded(),
                if(!isWarning)12.width,
                if(!isWarning)
                LabelButton(
                  label: confirmLabel ?? 'Xác nhận',
                  border: BorderSide(
                    color: actionConfirmBorder
                        ? colorConfirmBtn
                        : AppColors.button_brand_solid_textDefault,
                  ),
                  backgroundColor: !actionConfirmBorder
                      ? colorConfirmBtn
                      : AppColors.bg_primary,
                  labelStyle: AppStyle.bodyBsMedium.copyWith(
                    color: actionConfirmBorder
                        ? colorConfirmBtn
                        : AppColors.button_brand_solid_textDefault,
                  ),
                  onPressed: confirm,
                ).expanded(),
              ],
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
