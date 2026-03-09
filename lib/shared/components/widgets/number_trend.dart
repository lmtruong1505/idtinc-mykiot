import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class NumberTrending extends StatelessWidget {
  final String number;
  final num percent;
  final bool isUp;
  final TextStyle? style;
  final TextStyle? subStyle;
  final String? subNumber;
  const NumberTrending({
    super.key,
    required this.number,
    required this.percent,
    this.isUp = true,
    this.style,
    this.subStyle,
    this.subNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: number,
            style: (style ?? AppStyle.headingLg).copyWith(
              color: isUp ? AppColors.text_positive : AppColors.text_negative,
            ),
            children: [
              if (subNumber != null)
                TextSpan(
                  text: subNumber,
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
            ],
          ),
        ).flexible(),
        12.width,
        Container(
          padding: 6.padingHor + 4.padingVer,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: isUp
                ? AppColors.ultility_positive_10
                : AppColors.ultility_negative_10,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isUp
                    ? AppColors.ultility_positive_20
                    : AppColors.ultility_negative_20,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: isUp ? AppColors.text_positive : AppColors.text_negative,
                size: 15,
              ),
              2.width,
              Text(
                percent.formatPercent(type: '%'),
                textAlign: TextAlign.center,
                style: (subStyle ?? AppStyle.bodyXsBold).copyWith(
                  color:
                      isUp ? AppColors.text_positive : AppColors.text_negative,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
