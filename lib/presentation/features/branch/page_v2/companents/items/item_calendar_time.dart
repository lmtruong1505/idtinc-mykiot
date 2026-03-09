import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

class ItemCalendarTimeBranch extends StatelessWidget {
  const ItemCalendarTimeBranch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ChipBadgeCustom(
                          color: AppColors.ultility_brand_60,
                          title: 'Đang diễn ra',
                        ),
                      ],
                    ),
                    4.height,
                    Row(
                      children: [
                        Text(
                          '#',
                          style: AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.text_quaternary,
                          ),
                        ),
                        Text(
                          'DH151224-0001',
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.headingXl.copyWith(
                            color: AppColors.text_secondary,
                          ),
                        ).expanded(),
                      ],
                    ),
                  ],
                ).expanded(flex: 3),
                const VerticalDivider(
                  width: 32,
                  color: AppColors.border_tertiary,
                ).size(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '22/02/2024',
                      style: AppStyle.bodySmMedium.copyWith(
                        color: AppColors.text_quaternary,
                      ),
                    ),
                    4.height,
                    Text(
                      '11:30',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyMdSemiBold.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ).expanded(flex: 2),
              ],
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.arrow_outward_rounded,
                size: 17,
                color: AppColors.fg_quaternary,
              ),
            ),
          ],
        ),
        8.height,
        Text(
          'Dịch vụ',
          style: AppStyle.bodySmRegular.copyWith(
            color: AppColors.text_quaternary,
          ),
        ),
        Text(
          'Khám răng hàm mặt',
          style: AppStyle.bodyBsSemiBold.copyWith(
            color: AppColors.text_secondary,
            height: 1.5,
          ),
        ),
        7.height,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Khách hàng',
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_quaternary,
                  ),
                ),
                Text(
                  'Johnny Doe',
                  style: AppStyle.bodyBsSemiBold.copyWith(
                    color: AppColors.text_tertiary,
                    height: 1.5,
                  ),
                ),
              ],
            ).expanded(),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Thực hiện',
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_quaternary,
                  ),
                ),
                Text(
                  'Nguyễn Văn A',
                  style: AppStyle.bodyBsSemiBold.copyWith(
                    color: AppColors.text_tertiary,
                    height: 1.5,
                  ),
                ),
              ],
            ).expanded(),
          ],
        ),
      ],
    ).container(
      radius: 12,
      padding: 12.pading,
      border: Border.all(color: AppColors.border_tertiary),
      boxShadow: AppShadows.elevator0,
    );
  }
}
