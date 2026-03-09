import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../features_v2/models/customer/v2/customer_model.dart';

class InfoCustomerView extends StatelessWidget {
  const InfoCustomerView({
    super.key,
    required this.customer,
    this.onEdit,
    this.onClose,
  });

  final CustomerV2Model customer;
  final Function()? onEdit;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg_white,
        borderRadius: BorderRadius.circular(sp16),
        border: Border.all(color: AppColors.border_primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.07),
            offset: const Offset(1, 2),
            spreadRadius: sp2,
            blurRadius: sp2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(sp12),
        minTileHeight: sp0,
        minVerticalPadding: sp0,
        title: Text(
          customer.fullName ?? 'Không có thông tin',
          style: s14w600.copyWith(
            color: AppColors.text_primary,
          ),
        ),
        subtitle: Text(
          customer.phone ?? 'Không có thông tin',
          style: s12w500.copyWith(
            color: AppColors.blue60,
            decoration: TextDecoration.underline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: sp12,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp4,
                horizontal: sp8,
              ),
              decoration: BoxDecoration(
                color: AppColors.bg_white,
                borderRadius: BorderRadius.circular(sp16),
                border: Border.all(color: AppColors.border_primary),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.07),
                    offset: const Offset(1, 2),
                    spreadRadius: sp2,
                    blurRadius: sp2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    iconCode: 'f890',
                    color: AppColors.carrot60,
                    size: sp12,
                  ),
                  sp4.width,
                  Text(
                    customer.id == null ? 'Mới' : 'Khách hàng',
                    style: s10w500.copyWith(color: AppColors.carrot60),
                  ),
                ],
              ),
            ),
            if (customer.id == null) InkWell(
              onTap: () {
                onEdit?.call();
              },
              child: const CircleAvatar(
                radius: sp16,
                backgroundColor: AppColors.bg_disable,
                child: Icon(
                  Icons.edit_rounded,
                  color: AppColors.icon_iconSecondary,
                  size: sp20,
                ),
              ),
            ),
            if (onClose != null) InkWell(
              onTap: () {
                onClose?.call();
              },
              child: const CircleAvatar(
                radius: sp16,
                backgroundColor: AppColors.bg_disable,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.icon_iconSecondary,
                  size: sp20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
