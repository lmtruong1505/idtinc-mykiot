import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../button/double_button.dart';

class BgBts extends StatelessWidget {
  final Widget child;
  final Widget? subChild;
  final String label;
  final FlexFit fit;
  final EdgeInsets? padding;
  final Function()? onCancel;
  final Function()? onConfirm;
  final String? cancelText;
  final String? confirmText;
  final ScrollController? controller;
  final bool needBottom;
  const BgBts({
    super.key,
    this.label = 'Bộ lọc',
    required this.child,
    this.fit = FlexFit.loose,
    this.padding,
    this.onConfirm,
    this.onCancel,
    this.cancelText,
    this.confirmText,
    this.subChild,
    this.controller,
    this.needBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 20.radiusTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        margin: 8.pading,
                        decoration: const BoxDecoration(
                          color: AppColors.border_tertiary,
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppStyle.headingMd.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ).padding(6.pading),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconBtn(
                  onTap: () => context.pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            fit: fit,
            child: SingleChildScrollView(
              controller: controller,
              padding: (padding ?? 16.pading),
              child: child,
            ),
          ),
          if (subChild != null) subChild!,
          if (needBottom) ...[
            const Divider(
              color: AppColors.border_tertiary,
              height: 12,
            ).padding(16.padingHor),
            DoubleButton(
              cancelText: cancelText ?? 'Thiết lập lại',
              confirmText: confirmText ?? 'Áp dụng',
              onCancel: onCancel,
              onConfirm: onConfirm,
            ).padding(16.padingHor),
          ],
          context.padding.bottom.height,
        ],
      ),
    );
  }
}
