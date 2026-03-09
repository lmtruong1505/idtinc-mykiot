import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';
import 'package:pharmago/shared/components/widgets/avatar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../../config/app_style/init_app_style.dart';

class ItemStaffAddBranchV2 extends StatelessWidget {
  final PreEmpModel staff;
  final bool isActive;
  final Function()? onTap;
  final bool isRadio;
  const ItemStaffAddBranchV2({
    super.key,
    required this.staff,
    required this.onTap,
    this.isActive = false,
    this.isRadio = false,
  });

  @override
  Widget build(BuildContext context) {
    final comapanyWorkings = staff.workingData;
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              icon,
              16.width,
              AvatarCustom(url: staff.userData?.avatar ?? ''),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ChipBadgeCustom(
                        color: AppColors.ultility_brand_60,
                        title: 'Đang hoạt động',
                      ),
                    ],
                  ),
                  4.height,
                  RichText(
                    text: TextSpan(
                      text: staff.userData?.fullName ?? '',
                      style: AppStyle.headingMd,
                      children: [
                        TextSpan(
                          text: ' #${staff.userData?.code ?? ''}',
                          style: AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).expanded(),
            ],
          ),
          6.height,
          ...List.generate(
            comapanyWorkings.length,
            (index) => _itemInWork(comapanyWorkings[index]),
          ),
        ],
      ).container(),
    );
  }

  Widget _itemInWork(WorkingDataModel comapanyWorking) {
    final roles = comapanyWorking.roleData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          comapanyWorking.company?.workspaceName ?? '',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        if (roles.isNotEmpty) ...[
          4.height,
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              roles.length,
              (index) => ChipCustom(
                color: AppColors.ultility_gray_60,
                title: roles[index].title ?? '',
              ),
            ),
          ),
        ],
      ],
    ).padding(40.padingLeft + 6.padingTop);
  }

  Icon get icon {
    if (isRadio) {
      return Icon(
        isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: isActive
            ? AppColors.radio_backgroundActive
            : AppColors.radio_borderDefault,
      );
    }
    return Icon(
      isActive ? Icons.check_box_rounded : Icons.check_box_outline_blank,
      color: isActive
          ? AppColors.checkbox_backgroundActive
          : AppColors.checkbox_borderDefault,
    );
  }
}
