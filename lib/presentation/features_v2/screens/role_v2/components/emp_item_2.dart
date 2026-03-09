import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/components/widgets/avatar_custom.dart';
import '../../../../config/app_style/init_app_style.dart';

class EmpItem2 extends StatelessWidget {
  const EmpItem2({super.key, required this.emp});

  final PreEmpModel emp;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AvatarCustom(url: ''),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: emp.userData?.fullName ?? '',
                style: AppStyle.headingMd,
                children: [
                  TextSpan(
                    text: ' #${emp.userData?.code ?? ''}',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_quaternary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              emp.userData?.phoneNumber ?? '',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ).expanded(),
      ],
    );
  }
}
