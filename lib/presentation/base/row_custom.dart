import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class RowCustom extends StatelessWidget {
  const RowCustom({
    super.key,
    this.title,
    this.titleStyle,
    this.dataStyle,
    this.data,
    this.maxLine = 1,
    this.textAlign = TextAlign.end,
  });

  final String? title;
  final String? data;
  final TextStyle? titleStyle;
  final TextStyle? dataStyle;
  final int? maxLine;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? '',
          style: titleStyle ?? s12w400,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).flexible(),
        16.width,
        Text(
          data ?? '',
          maxLines: maxLine,
          overflow: TextOverflow.ellipsis,
          style: dataStyle ??
              s14w500.copyWith(
                color: AppColors.text_primary,
              ),
          textAlign: TextAlign.end,
        ).flexible(),
      ],
    );
  }
}
