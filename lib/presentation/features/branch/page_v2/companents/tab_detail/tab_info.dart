import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/items/item_read_more_text.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/bts_phone_action.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/bg/bg_detail.dart';
import '../../../../../../shared/components/widgets/label_container.dart';

class TabInfoDetailBranch extends StatelessWidget {
  final CompanyEntity company;
  const TabInfoDetailBranch({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return BgDetail(
      child: SingleChildScrollView(
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfor(),
            const Divider(
              height: 32,
              color: AppColors.border_tertiary,
            ),
            _buildInforDetail(context),
            16.height,
            _buildBank(),
          ],
        ).container(
          boxShadow: AppShadows.elevator0,
          padding: 12.pading,
          radius: 16,
        ),
      ),
    );
  }

  TextStyle get titleStyle => AppStyle.bodyBsRegular.copyWith(
        color: AppColors.text_secondary,
      );
  TextStyle get contentStyle => AppStyle.bodyBsMedium;

  TextStyle get contentStyleDisable => AppStyle.bodyBsRegular.copyWith(
        color: AppColors.text_disable,
      );

  Widget _buildBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelContainer(
          title: 'Thông tin Ngân hàng',
        ),
        12.height,
        TextRow2(
          title: 'Số tài khoản',
          content: company.accountNumber ?? 'Chưa có thông tin',
          crossAxisAlignment: CrossAxisAlignment.start,
          titleStyle: titleStyle,
          contentStyle: company.accountNumber.isEmptyOrNull
              ? contentStyleDisable
              : contentStyle,
        ),
        8.height,
        TextRow2(
          title: 'Chủ tài khoản',
          content: company.accountName ?? 'Chưa có thông tin',
          crossAxisAlignment: CrossAxisAlignment.start,
          titleStyle: titleStyle,
          contentStyle: company.accountName.isEmptyOrNull
              ? contentStyleDisable
              : contentStyle,
        ),
        8.height,
        TextRow2(
          title: 'Ngân hàng',
          content: company.bankName ?? 'Chứa có thông tin',
          crossAxisAlignment: CrossAxisAlignment.start,
          titleStyle: titleStyle,
          contentStyle: company.bankName.isEmptyOrNull
              ? contentStyleDisable
              : contentStyle,
        ),
      ],
    );
  }

  Widget _buildInforDetail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelContainer(
          title: 'Thông tin chung',
        ),
        12.height,
        if (company.manager?.id != null) ...[
          Text(
            'Quản lý',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          4.height,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    company.manager?.fullName ?? '',
                    style: AppStyle.headingBs.copyWith(
                      height: 1.5,
                    ),
                  ),
                  Text(
                    company.manager?.phoneNumber ?? '',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_secondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ).expanded(),
              IconBtn(
                onTap: () {
                  //LaunchUrl.phone(company.manager?.phoneNumber ?? '');
                  if (company.manager?.phoneNumber?.isEmptyOrNull == false) {
                    BtsPhoneAction.show(
                      context,
                      phoneNumber: company.manager?.phoneNumber ?? '',
                      fullname: company.manager?.fullName ?? '',
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
        if (company.manager?.id == null)
          TextRow2(
            title: 'Quản lý',
            content: 'Chưa có quản lý',
            crossAxisAlignment: CrossAxisAlignment.start,
            titleStyle: titleStyle,
            contentStyle: contentStyleDisable,
          ),
        8.height,
        TextRow2(
          title: 'Nhân viên',
          content: company.totalEmployeesAll.validator > 0
              ? '${company.totalEmployeesAll.validator} thành viên'
              : 'Chưa có nhân viên',
          crossAxisAlignment: CrossAxisAlignment.start,
          titleStyle: titleStyle,
          contentStyle: company.totalEmployeesAll.validator > 0
              ? contentStyle
              : contentStyleDisable,
        ),
        8.height,
        Row(
          children: [
            Text(
              'Giờ mở cửa',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            12.width,
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: company.timeStart ?? '--:--',
                    style: AppStyle.bodyBsMedium,
                  ),
                  TextSpan(
                    text: ' đến ',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  TextSpan(
                    text: company.timeEnd ?? '--:--',
                    style: AppStyle.bodyBsMedium,
                  ),
                ],
              ),
            ).expanded(),
          ],
        ),
        8.height,
        ItemReadMoreText(
          title: 'Mô tả',
          description: company.description,
        ),
      ],
    );
  }

  Widget _buildInfor() {
    return Column(
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
          ],
        ),
        4.height,
        Text(
          company.name.validator,
          style: AppStyle.headingXl.copyWith(
            color: AppColors.text_secondary,
            height: 1.5,
          ),
        ),
        Text(
          company.typeName.validator,
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_tertiary,
            height: 1.5,
          ),
        ),
        Text(
          company.address?.formatAddress ?? 'Chưa có thông tin',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
            height: 1.5,
          ),
        ),
        Text(
          company.phone ?? 'Chưa có thông tin',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
