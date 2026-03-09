import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../base/cache_image.dart';
import '../../../../base/v2/text_row.dart';
import '../../../../config/app_style/init_app_style.dart';
class ItemAssignEmp extends StatelessWidget {
  const ItemAssignEmp({super.key, required this.model});

  final UserDataModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg_secondary,
        borderRadius: 16.radius,
        border: Border.all(
          color: AppColors.border_tertiary
        )
      ),
      padding: 12.pading,
      margin: 16.pading,
      child: Column(
        children: [
          _buildHeader(),
          8.height,
          TextRow4(title: 'Số điện thoại', content: model.phoneNumber),
          8.height,
          TextRow4(title: 'CMND/CCCD', content: model.identifyNumber),
          8.height,
          TextRow4(title: 'Email', content: model.email),
          8.height,
          TextRow4(title: 'Địa chỉ', content: model.addressString),
        ],
      ),
    );
  }

  _buildHeader() {
    return Row(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: AppColors.bg_secondary,
            boxShadow: AppShadows.elevator0,
            shape: BoxShape.circle,
          ),
          child: BaseCacheImage(
            url:
            '',
            borderRadius: 40.radius,
            errorWidget: const Icon(
              CupertinoIcons.person,
            ),
          ),
        ),
        12.width,
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(
                text: model.fullName,
                style: AppStyle.headingMd,
              ),
              TextSpan(
                text: ' #${model.code}',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_quaternary,
                ),
              ),
            ],
          ),
        ).expanded(),
      ],
    );
  }
}
