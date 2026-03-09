import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class AppRadio extends StatelessWidget {
  const AppRadio({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:  isActive
            ? AppColors.bg_primary
            : AppColors.radio_backgroundDisabled,
        border: Border.all(
          color: isActive
              ? AppColors.radio_foregoround_active
              : AppColors.radio_borderDefault,
          width: 1,
        ),
      ),
      padding: isActive ? 2.pading : 0.pading,
      child: isActive
          ? Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.radio_foregoround_active,
              ),
            )
          : null,
    );
  }
}
