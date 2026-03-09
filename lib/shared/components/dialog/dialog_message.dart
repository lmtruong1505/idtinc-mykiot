import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class DialogMessage extends StatelessWidget {
  final String? title;
  final String? content;
  final Function()? action1;
  final Function()? action2;
  final String? action1Label;
  final String? action2Label;
  final bool isError;
  final Widget? icon;
  const DialogMessage({
    super.key,
    this.title,
    this.icon,
    this.content,
    this.action1,
    this.action2,
    this.action1Label,
    this.action2Label,
    this.isError = false,
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
            icon ??
                IconDiaLog(
                  color: isError
                      ? AppColors.bg_negativePrimary
                      : AppColors.bg_positivePrimary,
                  icon: isError
                      ? const Icon(
                          Icons.error,
                          weight: 32,
                          color: AppColors.fg_negative,
                        )
                      : const Icon(
                          Icons.check_rounded,
                          weight: 32,
                          color: AppColors.fg_positive,
                        ),
                ),
            4.height,
            Text(
              title ?? (isError ? 'Thất bại' : 'Thành công'),
              style: AppStyle.headingLg,
              textAlign: TextAlign.center,
            ),
            if (content != null)
              Text(
                content ?? '',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
                textAlign: TextAlign.center,
              ).padding(4.padingTop),
            16.height,
            if (action1 != null && !isError)
              LabelButton(
                label: action1Label ?? 'Chi tiết',
                onPressed: action1,
              ),
            if (action2 != null && !isError)
              LabelButton(
                label: 'Danh sách',
                labelStyle: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.button_neutral_alpha_textDefault,
                ),
                backgroundColor:
                    AppColors.button_neutral_alpha_backgroundDefault,
                onPressed: action2,
              ),
            if (isError)
              LabelButton(
                label: 'Trở về',
                labelStyle: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.white,
                ),
                backgroundColor:
                    AppColors.button_neutral_solid_backgroundDefault,
                onPressed: () {
                  context.pop();
                },
              ),
            16.height,
          ],
        ),
      ),
    );
  }
}

class IconDiaLog extends StatelessWidget {
  final Color? color;
  final Widget? icon;
  const IconDiaLog({
    super.key,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color ?? AppColors.bg_positivePrimary,
        ),
      ),
      padding: 8.pading,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? AppColors.bg_positivePrimary,
            width: 1.5,
          ),
          shape: BoxShape.circle,
        ),
        padding: 8.pading,
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColors.bg_positivePrimary,
            shape: BoxShape.circle,
          ),
          padding: 8.pading,
          child: icon ??
              const Icon(
                Icons.check_rounded,
                color: AppColors.fg_positive,
                size: 32,
              ),
        ),
      ),
    );
  }
}
