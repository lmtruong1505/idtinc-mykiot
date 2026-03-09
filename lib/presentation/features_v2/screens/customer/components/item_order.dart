import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/v2/text_row.dart';
import '../../../../router/router.gr.dart';
import '../../../models/order/order_preview_model.dart';

class ItemOrder extends StatelessWidget {
  final OrderPreviewV2Model order;
  final bool isCustomer;
  final Function()? onTap;
  const ItemOrder({
    super.key,
    required this.order,
    this.isCustomer = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    return InkWell(
      onTap: onTap ??
          () {
            context.router.push(
              OrderDetailV2Route(
                id: order.id ?? -1,
              ),
            );
          },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 8.radius,
          border: Border.all(
            color: ColorApp.greyE2,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '#${order.code ?? ''}',
                  style: StyleApp.medium(
                    color: ColorApp.grey79,
                  ),
                ).expanded(),
                8.width,
                Text(
                  order.type == TypeOrderEnum.service.code.toLowerCase()
                      ? TypeOrderEnum.service.name
                      : TypeOrderEnum.sell.name,
                  style: StyleApp.medium(
                    color:
                        order.type == TypeOrderEnum.service.code.toLowerCase()
                            ? ColorApp.yellowD2
                            : ColorApp.blue20,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 32,
              color: ColorApp.greyF2,
            ),
            TextRow2(
              title: 'Tên khách hàng',
              content: order.customerName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Cơ sở',
              content: getCompanyName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Người tạo',
              content: order.userCreated,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Thời gian tạo',
              content: order.createdAt?.fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            Row(
              children: [
                Text(
                  'Đã thu',
                  style: titleStyle,
                ).expanded(),
                8.width,
                RichText(
                  text: TextSpan(
                    text: order.totalPrice.validator.formatPrice(type: ' VNĐ'),
                    style: contentStyle.copyWith(
                      color: order.totalPrice.validator >=
                              order.totalPrice.validator
                          ? ColorApp.main
                          : ColorApp.red,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '/${order.totalPrice.validator.formatPrice(type: ' VNĐ')}',
                        style: contentStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
