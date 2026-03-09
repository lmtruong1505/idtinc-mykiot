import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_string.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/components/widgets/avatar_custom.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../features/employee/employee/domain/entities/employee_entity.dart';

class EmpItem extends StatelessWidget {
  const EmpItem({super.key, required this.emp});

  final EmployeeEntity emp;

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
                text: emp.fullName ?? '',
                style: AppStyle.headingMd,
                children: [
                  TextSpan(
                    text: ' #${emp.code ?? ''}',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_quaternary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              emp.phoneNumber ?? '',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            8.height,
            Wrap(
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              spacing: 6,
              runSpacing: 6,
              children: List.generate(emp.roles?.length ?? 0, (index) {
                final role = emp.roles![index];
                return ChipCustom(color: AppColors.ultility_gray_60, title: role.name.validator);
              }),
            )
          ],
        ).expanded(),
      ],
    );
  }
}
