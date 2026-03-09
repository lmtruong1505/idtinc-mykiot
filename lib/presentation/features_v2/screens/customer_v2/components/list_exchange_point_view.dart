import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../models/customer/v2/customer_point_item_model.dart';

class ListExchangePointView extends StatelessWidget {
  const ListExchangePointView({
    super.key,
    required this.point,
    required this.listPoints,
  });

  final num point;
  final List<CustomerPointItemModel> listPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(sp8),
          decoration: BoxDecoration(
            color: AppColors.ultility_gray_20,
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    'Điểm tích luỹ',
                    style: s14w400.copyWith(color: AppColors.text_primary),
                  ),
                  Row(
                    children: [
                      Text(
                        '$point',
                        style: AppStyle.bodyBsSemiBold
                            .copyWith(color: AppColors.text_tertiary),
                      ),
                      sp8.width,
                      SvgPicture.asset('assets/svg/point.svg'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        16.height,
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = listPoints[index];
              return Container(
                padding: const EdgeInsets.all(sp12),
                decoration: BoxDecoration(
                  color: index % 2 != 1
                      ? AppColors.bg_white
                      : AppColors.bg_secondary_subtle,
                  border: Border.all(color: AppColors.border_tertiary),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: sp2,
                            horizontal: sp8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.ultility_carrot_10,
                            borderRadius: BorderRadius.circular(sp12),
                            border:
                                Border.all(color: AppColors.border_tertiary),
                          ),
                          child: Text(
                            'Đơn hàng',
                            style: s12w500.copyWith(
                              color: AppColors.ultility_carrot_60,
                            ),
                          ),
                        ),
                        Text(
                          item.createdAt.fomatCustom(fomat: 'hh:mm - dd/MM/y'),
                          style: s12w400.copyWith(
                            color: AppColors.text_quaternary,
                          ),
                        ),
                      ],
                    ),
                    4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${item.orderData?.code}',
                          style: s14w500.copyWith(
                            color: AppColors.text_primary,
                          ),
                        ),
                        Text(
                          '${item.orderData?.totalAmount.formatCurrency}đ',
                          style: s14w600.copyWith(
                            color: AppColors.blue60,
                          ),
                        ),
                      ],
                    ),
                    4.height,
                    Row(
                      children: [
                        Text(
                          _title(item.type!),
                          style: s14w400.copyWith(
                            color: item.point! > 0
                                ? AppColors.brand
                                : AppColors.red60,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${item.point! > 0 ? '+' : ''}${item.point.formatCurrency}',
                          style: s14w600.copyWith(
                            color: item.point! > 0
                                ? AppColors.brand
                                : AppColors.red60,
                          ),
                        ),
                        sp4.width,
                        SvgPicture.asset('assets/svg/point.svg'),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemCount: listPoints.length,
          ),
        ),
      ],
    ).padding(const EdgeInsets.all(sp16));
  }

  String _title(String type) {
    // ORDER_REVENUE (giá trị đơn hàng - setting point ws), ORDER_ITEM (điểm từ sản phẩm), ADMIN, PRODUCT_EXCHANGE (đổi điểm thành sản phẩm), POINT_EXCHANGE (đổi điểm thành tiền), PACKAGE_EXCHANGE (quy đổi gói)
    switch (type) {
      case 'ORDER_REVENUE':
        return 'Tích điểm theo giá trị đơn hàng';
      case 'ORDER_ITEM':
        return 'Tích điểm theo sản phẩm';
      case 'PRODUCT_EXCHANGE':
        return 'Quy đổi điểm từ đổi sản phẩm';
      case 'POINT_EXCHANGE':
        return 'Quy đổi điểm từ giảm tiền';
      case 'PACKAGE_EXCHANGE':
        return 'Quy đổi điểm từ đổi gói';
      default:
        return '';
    }
  }
}
