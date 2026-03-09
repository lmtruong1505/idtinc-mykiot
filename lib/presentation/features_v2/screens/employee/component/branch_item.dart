import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/shared/components/widgets/app_radio.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../features/company/domain/entities/company_entity.dart';

class ItemBranch extends StatelessWidget {
  const ItemBranch({super.key, required this.branch, required this.isActive});

  final CompanyEntity branch;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 12.pading,
      child: Row(
        children: [
          AppRadio(isActive: isActive),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                branch.name.validator,
                style: AppStyle.headingXl.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              Text(
                branch.typeName.validator,
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              4.height,
              Text(
                branch.address?.fullAddress.validator ?? '',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}

class ItemBranch2 extends StatelessWidget {
  const ItemBranch2({
    super.key,
    required this.branch,
    this.onEdit,
  });

  final CompanyEntity branch;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 12.pading,
      decoration: BoxDecoration(
        borderRadius: 8.radius,
        border: Border.all(
          color: AppColors.border_tertiary,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                branch.name.validator,
                style: AppStyle.headingXl.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              Text(
                branch.typeName.validator,
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              4.height,
              Text(
                branch.address?.fullAddress.validator ?? '',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ).expanded(),
          16.height,
          InkWell(
            onTap: () {
              onEdit?.call();
            },
            child: const Icon(
              CupertinoIcons.pencil_circle_fill,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
