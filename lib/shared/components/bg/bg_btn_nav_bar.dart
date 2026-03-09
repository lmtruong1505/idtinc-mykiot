import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class BgBtnNavBar extends StatelessWidget {
  final Widget child;
  const BgBtnNavBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child.container(
      radius: 0,
      padding:
          12.padingTop + 16.padingHor + context.padding.bottom.padingBottom,
      boxShadow: AppShadows.elevator3,
      border: const Border(
        top: BorderSide(width: 2, color: AppColors.border_tertiary),
      ),
    );
  }
}
