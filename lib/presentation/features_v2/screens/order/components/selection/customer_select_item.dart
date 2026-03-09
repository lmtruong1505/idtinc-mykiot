import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/widgets/avatar_custom.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../models/customer/v2/customer_model.dart';

class CustomerSelectItem extends StatelessWidget {
  const CustomerSelectItem({
    super.key,
    required this.isSelected,
    required this.model,
  });

  final bool isSelected;
  final CustomerV2Model model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 16.padingHor + 8.padingVer,
      margin: 8.padingHor,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.dropdown_backgroundActive
            : AppColors.bg_primary,
        borderRadius: 6.radius,
      ),
      child: Row(
        children: [
          const AvatarCustom(url: ''),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.fullName ?? 'Không có thông tin',
                style: AppStyle.headingMd,
              ),
              Text(
                model.phone ?? 'Không có thông tin',
                style: AppStyle.bodyBsSemiBold
                    .copyWith(color: AppColors.text_tertiary),
              ),
            ],
          ).expanded(),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppColors.fg_positive,
            ),
        ],
      ),
    );
  }
}
