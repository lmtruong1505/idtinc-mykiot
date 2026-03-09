import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../config/app_style/init_app_style.dart';
import '../constants/spacing.dart';

class BaseLoading extends StatelessWidget {
  const BaseLoading({super.key, this.color, this.size, this.height});

  final Color? color;
  final double? size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: color ?? AppColors.brand,
          size: size ?? sp32,
        ),
      ),
    );
  }
}

class BaseLoadingV2 extends StatelessWidget {
  const BaseLoadingV2({
    super.key,
    this.color,
    this.size,
    this.height,
  });

  final Color? color;
  final double? size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: color ?? AppColors.brand,
          size: height ?? sp32,
        ),
      ),
    );
  }
}
