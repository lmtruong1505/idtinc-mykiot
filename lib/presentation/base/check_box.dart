import 'package:flutter/material.dart';

import '../config/app_style/init_app_style.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';

class BaseCheckbox extends StatelessWidget {
  const BaseCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sp4)),
      side: const BorderSide(width: 2, color: borderColor_2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      splashRadius: sp8,
      checkColor: whiteColor,
      activeColor: mainColor,
      value: value,
      onChanged: (value) {
        onChanged.call(value);
      },
    );
  }
}

class BaseCheckbox2 extends StatelessWidget {
  const BaseCheckbox2({
    super.key,
    this.value,
    required this.onChanged,
    this.error = false,
  });

  final bool? value;
  final Function(bool? value) onChanged;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sp4)),
      side: const BorderSide(width: 2, color: borderColor_2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      splashRadius: sp8,
      checkColor: whiteColor,
      activeColor: AppColors.blue60,
      value: error == false ? (value ?? false) : value,
      tristate: error,
      onChanged: (value) {
        onChanged.call(value);
      },
    );
  }
}