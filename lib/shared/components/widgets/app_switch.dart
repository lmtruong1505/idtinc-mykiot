import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 32,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Theme(
          data: ThemeData(
            useMaterial3: true,
          ),
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: AppColors.brand,
            inactiveTrackColor: AppColors.bg_secondary,
            inactiveThumbColor: AppColors.white,
            trackOutlineWidth: WidgetStateProperty.all(0.0),

          ),
        ),
      ),
    );
  }
}
