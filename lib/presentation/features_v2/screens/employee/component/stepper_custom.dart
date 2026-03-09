import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

class StepperCustom extends StatelessWidget {
  const StepperCustom({super.key, required this.doing, required this.done});

  final bool doing;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: !doing && !done
            ? AppColors.bg_disable
            : (done
                ? AppColors.button_brand_solid_backgroundHover
                : AppColors.bg_primary),
        borderRadius: 9.radius,
        border: !doing && !done
            ? null
            : Border.all(
                color: AppColors.button_brand_solid_backgroundHover,
                width: 2,
              ),
      ),
    );
  }
}
