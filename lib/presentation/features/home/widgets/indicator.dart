import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';

import '../../../constants/typography.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.value,
    required this.isSquare,
    this.size = 16,
    this.textColor,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });
  final Color color;
  final String text;
  final String? value;
  final bool isSquare;
  final double size;
  final Color? textColor;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        gapWidth(sp8),
        Text(
          text,
          style: p6.copyWith(color: greyTextColor),
        ),
        gapWidth(sp4),
        Text(
          value ?? '',
          style: h6.copyWith(color: blackColor),
        ),
      ],
    );
  }
}
