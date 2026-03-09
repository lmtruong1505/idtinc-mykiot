import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/branch/data/entities/branch_emp_entity.dart';
import 'package:pharmago/shared/components/widgets/avatar_custom.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/button/icon_btn.dart';
import '../../../../../../shared/components/widgets/bts_phone_action.dart';
import '../../../../../config/role/check_role_per.dart';

class ItemStaffBranch extends StatelessWidget {
  final BranchEmpEntity item;
  final Function()? onTap;
  const ItemStaffBranch({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final staff = item.employee;
    final roles = item.employee?.roles ?? [];
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (isAdmin) ...[
                Icon(
                  item.isSelect
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank,
                  color: item.isSelect
                      ? AppColors.checkbox_backgroundActive
                      : AppColors.checkbox_borderDefault,
                ),
                16.width,
              ],
              AvatarCustom(url: staff?.avatar ?? ''),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${staff?.code ?? ''} ',
                        style: AppStyle.bodyBsRegular.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ).expanded(),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        size: 16,
                        color: AppColors.fg_quaternary,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            staff?.fullName ?? '',
                            style: AppStyle.headingLg.copyWith(height: 1.5),
                          ),
                          Text(
                            staff?.phoneNumber ?? '',
                            style: AppStyle.bodyBsMedium.copyWith(
                              height: 1.5,
                              color: AppColors.text_tertiary,
                            ),
                          ),
                        ],
                      ).expanded(),
                      IconBtn(
                        onTap: () {
                          //LaunchUrl.phone(company.manager?.phoneNumber ?? '');
                          if (staff?.phoneNumber.isEmptyOrNull == false) {
                            BtsPhoneAction.show(
                              context,
                              phoneNumber: staff?.phoneNumber ?? '',
                              fullname: staff?.fullName ?? '',
                            );
                          }
                        },
                        size: const Size(32, 32),
                        icon: const Icon(
                          CupertinoIcons.phone,
                          size: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ).expanded(),
            ],
          ),
          4.height,
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              roles.length,
              (index) => ChipCustom(
                color: AppColors.ultility_gray_60,
                title: roles[index].name ?? '',
              ),
            ),
          ).padding(95.padingLeft),
        ],
      ).container(),
    );
  }
}
