import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/bts/bts_filter_order.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../models/order/preview_order_model.dart';
import '../../../../router/router.gr.dart';

class ItemOrderPageV2 extends StatelessWidget {
  final bool isBg;
  final bool? isShowCheckbox;
  final bool? isSend;
  final PreviewOrderModel order;
  final dynamic Function(bool?)? onChanged;
  const ItemOrderPageV2({
    super.key,
    this.isBg = false,
    required this.order,
    this.onChanged,
    this.isShowCheckbox,
    this.isSend,
  });

  @override
  Widget build(BuildContext context) {
    final canSelectOrder = isShowCheckbox == true;
    return InkWell(
      onTap: () {
        if (canSelectOrder) {
          onChanged?.call(order.isSelect);
        } else {
          context.router.push(
            OrderDetailProdV2Route(
              id: order.id!,
              isProd: type(order.type ?? '') == OrderTypeV2.product,
            ),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canSelectOrder)
            Container(
              width: 4,
              height: 115,
              color:
                  order.isSelect == true ? AppColors.green80 : AppColors.white,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // if (isShowCheckbox == true) ...[
                  //   BaseCheckbox2(
                  //     onChanged: (value) {
                  //       onChanged?.call(value);
                  //     },
                  //     value: order.isSelect,
                  //   ),
                  //   8.width,
                  // ],
                  ChipCustom(
                    color: type(order.type ?? '') == OrderTypeV2.service
                        ? AppColors.ultility_blue
                        : AppColors.ultility_carrot_60,
                    title:
                        'Đơn hàng ${type(order.type ?? '').title.toLowerCase()}',
                  ),
                  const Spacer(),
                  Text(
                    order.createdAt.fomatCustom(fomat: 'HH:mm ∙ dd/MM/yyyy'),
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_quaternary,
                    ),
                  ),
                  if (canSelectOrder) ...[
                    InkWell(
                      child: FaIcon(iconCode: 'e09f', size: 24)
                          .padding(8.padingLeft),
                      onTap: () => context.router.push(
                        OrderDetailProdV2Route(
                          id: order.id!,
                          isProd: type(order.type ?? '') == OrderTypeV2.product,
                        ),
                      ),
                    ),
                  ],
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
              if (canSelectOrder)
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      statusRedInvoice(order.redInvoiceStatus),
                      style: s12w400.copyWith(
                        color: AppColors.ultility_gray_60,
                      ),
                    ),
                    4.width,
                    //  sta   BaseLoadingV2(height: 14, color: AppColors.blue60):
                    iconRedInvoice(order.redInvoiceStatus),
                    // isSend == true
                    //     ? const BaseLoadingV2(height: 14)
                    //     : FaIcon(
                    //         iconCode: 'f058',
                    //         color: AppColors.brand,
                    //         size: 14,
                    //       ),
                  ],
                ),
              if (canSelectOrder)
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Đã phát hành HĐĐT',
                      style: s12w400.copyWith(
                        color: AppColors.ultility_gray_60,
                      ),
                    ),
                    4.width,
                    isSend == true
                        ? const BaseLoadingV2(height: 14)
                        : FaIcon(
                            iconCode: 'f058',
                            color: AppColors.brand,
                            size: 14,
                          ),
                  ],
                ),
            ],
          )
              .container(
                padding: 12.padingHor + 10.padingVer,
                radius: 0,
                // bgColor: isBg ? AppColors.bg_secondary_subtle : AppColors.bg_primary,
              )
              .expanded(),
        ],
      ),
    );
  }
}

String statusRedInvoice(String? status) {
  switch (status) {
    case 'not_created':
      return RedInvoiceEnum.notCreate.value;
    case 'waiting':
      return RedInvoiceEnum.waiting.value;
    case 'processing':
      return RedInvoiceEnum.processing.value;
    case 'success':
      return RedInvoiceEnum.success.value;
    case 'failed':
      return RedInvoiceEnum.failed.value;
    default:
      return RedInvoiceEnum.notCreate.value;
  }
}

Widget iconRedInvoice(String? status) {
  switch (status) {
    case 'not_created':
      return FaIcon(
          iconCode: 'e09a', size: 14, color: AppColors.ultility_carrot_60);
    case 'waiting':
      return const BaseLoadingV2(height: 14, color: AppColors.blue60);
    case 'processing':
      return FaIcon(iconCode: 'e1d4', size: 14, color: AppColors.blue60);
    case 'success':
      return FaIcon(iconCode: 'f058', size: 14, color: AppColors.brand);
    case 'failed':
      return FaIcon(iconCode: 'f366', size: 14, color: AppColors.red60);
    default:
      return FaIcon(
          iconCode: 'e09a', size: 14, color: AppColors.ultility_carrot_60);
  }
}

enum RedInvoiceEnum {
  notCreate('not_created', 'Chưa tạo hóa đơn'),
  waiting('waiting', 'Chờ xử lý'),
  processing('processing', 'Đang xử lý'),
  success('success', 'Chưa tạo hóa đơn'),
  failed('failed', 'Tạo thất bại');

  final String title;
  final String value;
  const RedInvoiceEnum(this.title, this.value);
}
