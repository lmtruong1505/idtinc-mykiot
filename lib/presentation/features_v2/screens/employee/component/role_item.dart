import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/role/role_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

class RoleItem extends StatelessWidget {
  const RoleItem({super.key, required this.role, required this.isSelected});

  final RoleListModel role;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg_primary,
      ),
      padding: 10.padingHor + 4.padingVer,
      child: Container(
        padding: 6.pading,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bg_primary_hover : AppColors.bg_primary,
          borderRadius: 6.radius,
        ),
        child: Row(
          children: [
            Text(
              role.title ?? '',
              style: isSelected
                  ? AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.text_secondary,
                    )
                  : AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_secondary,
                    ),
            ).expanded(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.fg_positive,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
