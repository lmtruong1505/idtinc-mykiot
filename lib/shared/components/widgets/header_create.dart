import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import 'fa_icon.dart';
import 'icon_custom.dart';

class HeaderCreate extends StatelessWidget {
  final String title;
  final String iconCode;
  final bool isEdit;
  const HeaderCreate({
    super.key,
    required this.iconCode,
    required this.title,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (isEdit)
              Container(
                width: 36,
                height: 36,
                padding: 4.pading,
                margin: 16.padingLeft + 16.padingBottom,
                decoration: const BoxDecoration(
                  color: AppColors.bg_secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    iconCode: 'f304',
                    size: 20,
                    type: FaIconType.solid,
                    color: AppColors.text_tertiary,
                  ),
                ),
              ),
            if (!isEdit)
              IconCustom(
                icon: FaIcon(
                  iconCode: iconCode,
                  type: FaIconType.solid,
                  color: AppColors.bg_primary,
                ),
                color: AppColors.ultility_positive_60,
              ),
          ],
        ),
        Text(
          title,
          textAlign: TextAlign.left,
          style: AppStyle.heading2xl,
        ).padding(16.padingHor),
      ],
    );
  }
}
