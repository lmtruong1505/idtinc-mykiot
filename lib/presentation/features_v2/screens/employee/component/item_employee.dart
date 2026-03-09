import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/working_data_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

class ItemEmployee extends StatelessWidget {
  const ItemEmployee({super.key, required this.model});

  final PreEmpModel model;
  final double size = 56;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          12.height,
          _buildWorkingData(),
        ],
      ),
    );
  }

  _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: size,
          width: size,
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
        Container(
          height: size,
          alignment: Alignment.centerLeft,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: model.userData?.fullName.validator,
                  style: AppStyle.headingMd,
                ),
                TextSpan(
                  text: ' #${model.userData?.code.validator}',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_quaternary,
                  ),
                ),
              ],
            ),
          ),
        ).expanded(),
        const Icon(
          CupertinoIcons.arrow_up_right,
          color: AppColors.text_tertiary,
          size: 15,
        ),
      ],
    );
  }

  _buildWorkingData() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => WorkingDataItem(
        model: model.workingData[index],
      ),
      separatorBuilder: (context, index) => 8.height,
      itemCount: model.workingData.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
