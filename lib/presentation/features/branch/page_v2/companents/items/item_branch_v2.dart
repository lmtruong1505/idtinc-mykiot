import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/avatar_custom.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../config/app_style/init_app_style.dart';

class ItemBranchV2 extends StatelessWidget {
  final CompanyEntity company;
  const ItemBranchV2({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: checkPermission(PerBranchEnum.DETAIL.code)
          ? () {
              context.pushRoute(DetailBranchV2Route(id: company.id ?? -1));
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ChipBadgeCustom(
                title: company.status ? 'Đang hoạt động' : 'Dừng hoạt động',
                icon: company.status
                    ? null
                    : Icon(
                        Icons.pause_rounded,
                        color: !company.status
                            ? AppColors.ultility_gray_60
                            : AppColors.ultility_positive_60,
                        size: 10,
                      ),
                color: !company.status
                    ? AppColors.ultility_gray_60
                    : AppColors.ultility_positive_60,
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_outward_rounded,
                size: 17,
                color: AppColors.fg_quaternary,
              ),
            ],
          ),
          Opacity(
            opacity: company.status ? 1 : 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                4.height,
                Text(
                  company.name.validator,
                  style: AppStyle.headingXl.copyWith(
                    color: AppColors.text_secondary,
                    height: 1.5,
                  ),
                ),
                4.height,
                Text(
                  company.typeName.validator,
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                    height: 1.5,
                  ),
                ),
                8.height,
                Row(
                  children: [
                    if (company.manager?.id != null) ...[
                      const AvatarCustom(
                        url: 'url',
                        size: 24,
                      ),
                      6.width,
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: 'Quản lý ',
                          style: AppStyle.bodyMdRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                          children: [
                            TextSpan(
                              text: company.manager?.fullName ??
                                  'Chưa có thông tin',
                              style: AppStyle.bodyMdBold.copyWith(
                                color: AppColors.text_quaternary,
                              ),
                            ),
                          ],
                        ),
                      ).expanded(),
                    ] else
                      Text(
                        'Chưa có quản lý',
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodyMdRegular.copyWith(
                          color: AppColors.text_quaternary,
                        ),
                      ).expanded(),
                    16.width,
                    Text(
                      '${company.totalEmployees}',
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                    5.width,
                    const Icon(
                      CupertinoIcons.person_fill,
                      size: 17,
                      color: AppColors.fg_quaternary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ).container(),
    );
  }
}
