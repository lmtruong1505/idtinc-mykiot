import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class GradientProgressBar extends StatelessWidget {
  ///it can be anything between 0 to 100
  final int percent;
  final LinearGradient gradient;
  final Color backgroundColor;
  final double height;

  const GradientProgressBar({
    required this.percent,
    required this.gradient,
    required this.backgroundColor,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: percent,
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
            ),
            child: height.height,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 100 - percent,
          child: Container(
            color: backgroundColor,
            child: height.height,
          ),
        ),
      ],
    );
  }
}
