import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/role/role_model.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/avatar_custom.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../bloc/branch_staff_bloc/add_staff_branch_bloc.dart';
import '../bottom_sheets/bts_add_role.dart';

class ItemStaffChooseRole extends StatelessWidget {
  final AddStaffModel item;
  final Function(List<RoleListModel>) onTap;
  final Function() remove;
  const ItemStaffChooseRole({
    super.key,
    required this.item,
    required this.onTap,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    final staff = item.staff;
    final roles = item.roles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AvatarCustom(url: staff.userData?.avatar ?? ''),
            16.width,
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
            ).expanded(),
            12.width,
            LabelButton(
              label: 'Xoá',
              onPressed: remove,
              labelStyle: AppStyle.bodySmMedium.copyWith(
                color: AppColors.button_negative_alpha_textDefault,
              ),
              padding: EdgeInsets.zero,
              backgroundColor:
                  AppColors.button_negative_alpha_backgroundDefault,
            ).size(height: 24, width: 45),
          ],
        ),
        12.height,
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(
            roles.length + 1,
            (index) {

              if (index == roles.length) {
                return ChipDashBorder(
                  onTap: () async {
                    final res = await context.bottomSheet(
                      BtsAddRole(
                        roles: roles,
                      ),
                    );
                    if (res is List<RoleListModel>) {
                      onTap.call(res);
                    }
                  },
                  color: AppColors.ultility_gray_40,
                  title: 'Vai trò',
                  suffixIcon: const Icon(
                    Icons.add,
                    color: AppColors.ultility_gray_40,
                    size: 14,
                  ).padding(2.padingLeft),
                );
              }
              return ChipCustom(
                onTap: () {
                  roles.removeAt(index);
                  onTap.call(roles);
                },
                color: AppColors.ultility_gray_60,
                title: roles[index].title ?? '',
                suffixIcon: const Icon(
                  Icons.close,
                  color: AppColors.ultility_gray_40,
                  size: 14,
                ).padding(2.padingLeft),
              );
            },
          ),
        ),
      ],
    ).container();
  }
}
