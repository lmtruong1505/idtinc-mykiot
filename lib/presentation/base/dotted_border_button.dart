import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({
    super.key,
    this.onTap,
    this.title,
    this.preIcon,
    this.subIcon,
  });
  final Function()? onTap;
  final String? title;
  final Widget? preIcon;
  final Widget? subIcon;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(999),
      dashPattern: const [8, 4],
      color: Colors.blue,
      strokeWidth: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          onTap?.call();
        },
        child: Padding(
          padding: 8.pading,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (preIcon != null) ...[
                  preIcon!,
                  8.width,
                ],
                Text(
                  title ?? '',
                  style: s16w400.copyWith(color: AppColors.blue60),
                ),
                if (subIcon != null) ...[8.width, subIcon!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
