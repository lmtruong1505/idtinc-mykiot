import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/bts_phone_action.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../models/customer/v2/customer_model.dart';

class ItemCustomerV2 extends StatelessWidget {
  final CustomerV2Model item;
  const ItemCustomerV2({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(DetailCustomerV2Route(id: item.id!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '#${item.code ?? ""}',
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.fg_quaternary,
                ),
              ).expanded(),
              12.width,
              const Icon(
                Icons.arrow_outward_rounded,
                color: AppColors.fg_quaternary,
                size: 16,
              ),
            ],
          ),
          4.height,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.fullName ?? 'Khách lẻ',
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.headingMd,
                  ),
                  2.height,
                  if (!item.phone.isEmptyOrNull)
                    Row(
                      children: [
                        Text(
                          item.phone ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.bodyBsMedium.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                        sp12.width,
                        IconBtn(
                          onTap: () {
                            BtsPhoneAction.show(
                              context,
                              phoneNumber: item.phone ?? '',
                              fullname: item.fullName ?? '',
                            );
                          },
                          size: const Size(32, 32),
                          icon: const Icon(
                            CupertinoIcons.phone,
                            size: 16,
                            color: AppColors.button_neutral_alpha_iconDefault,
                          ),
                        ),
                      ],
                    ),
                ],
              ).expanded(),
              if ((item.debt ?? 0) > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Còn nợ',
                      style: s14w400.copyWith(
                        color: AppColors.ultility_gray_60,
                      ),
                    ),
                    sp4.height,
                    Text(
                      '${item.debt.formatCurrency}đ',
                      style: s14w400.copyWith(
                        color: AppColors.ultility_gray_60,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ).padding(12.pading),
    );
  }
}
