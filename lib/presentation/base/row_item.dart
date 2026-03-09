import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/typography.dart';

class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
    required this.title,
    required this.content,
    this.contetnColor,
    this.titleColor,
    this.titleStyle,
    this.contetnStyle,
    this.contentOnTap,
  });

  final String title;
  final String content;
  final Color? contetnColor;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final TextStyle? contetnStyle;
  final Function()? contentOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: titleStyle ?? p6.copyWith(color: titleColor ?? blackColor),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: contentOnTap,
            child: Text(
              content.isEmpty ? 'Chưa có thông tin' : content,
              style: contetnStyle ??
                  h6.copyWith(
                      color: contetnColor ??
                          (content.isEmpty ? Colors.grey : blackColor)),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}

class RowItem2 extends StatelessWidget {
  const RowItem2({
    super.key,
    required this.title,
    required this.content,
    this.titleColor,
    this.titleStyle,
    this.flexContent,
  });

  final String title;
  final Widget content;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final int? flexContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: titleStyle ?? p6.copyWith(color: titleColor ?? blackColor),
          ),
        ),
        Expanded(
          flex: flexContent ?? 1,
          child: content,
        ),
      ],
    );
  }
}
