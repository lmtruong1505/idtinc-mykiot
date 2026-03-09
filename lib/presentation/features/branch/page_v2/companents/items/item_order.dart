import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/bts/bts_filter_order.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../features_v2/models/order/preview_order_model.dart';


class ItemOrderV2 extends StatelessWidget {
  final bool isBg;
  final PreviewOrderModel order;
  const ItemOrderV2({
    super.key,
    this.isBg = false,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(
        OrderDetailProdV2Route(id: order.id!, isProd: type(order.type ?? '') == OrderTypeV2.product),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ChipCustom(
                color: type(order.type ?? '') == OrderTypeV2.service
                    ? AppColors.ultility_blue
                    : AppColors.ultility_carrot_60,
                title: 'Đơn hàng ${type(order.type ?? '').title.toLowerCase()}',
              ),
              const Spacer(),
              Text(
                order.createdAt.fomatCustom(fomat: 'hh:mm ∙ dd/MM/yyyy'),
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_quaternary,
                ),
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
                order.code ?? '',
                overflow: TextOverflow.ellipsis,
                style: AppStyle.headingBs.copyWith(
                  color: AppColors.text_secondary,
                ),
              ).expanded(),
              12.width,
              Text(
                '${order.paymentHistory.formatCurrency} đ',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyBsSemiBold.copyWith(
                  color: order.paymentHistory == order.totalPrice
                      ? AppColors.fg_tertiary
                      : order.paymentHistory == 0
                          ? AppColors.text_negative
                          : AppColors.ultility_blue,
                ),
              ).expanded(),
            ],
          ),
          4.height,
          Row(
            children: [
              Text(
                order.customerName ?? 'Khách lẻ',
                style: AppStyle.bodySmRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              12.width,
              Text(
                '/${order.totalPrice.formatCurrency} đ',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodySmMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ).expanded(),
            ],
          ),
        ],
      ).container(
        padding: 12.padingHor + 10.padingVer,
        radius: 0,
        bgColor: isBg ? AppColors.bg_secondary_subtle : AppColors.bg_primary,
      ),
    );
  }
}
