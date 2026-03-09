import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/role/role_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class RoleListItem extends StatelessWidget {
  const RoleListItem({super.key, required this.model});

  final RoleListModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 12.pading,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                model.title.validator,
                style: AppStyle.headingMd,
              ).expanded(),
              16.width,
              const Icon(
                CupertinoIcons.arrow_up_right,
                color: AppColors.fg_quaternary,
                size: 18,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                model.position?.title.validator ?? 'Không có thông tin',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
              ).expanded(),
              Text(
                model.totalEmployee.validator.toString(),
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
                textAlign: TextAlign.center,
              ).size(
                width: 16,
              ),
              const Icon(
                CupertinoIcons.person_solid,
                color: AppColors.fg_quaternary,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
