import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../../models/order/order_preview_model.dart';

class OrderPreviewCard extends StatelessWidget {
  const OrderPreviewCard({super.key, required this.order});

  final OrderPreviewV2Model order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              typeWidget(order.type ?? 'product'),
              Text(
                DateFormat('hh:mm ∙ dd/M/y').format(order.createdAt!),
                style: p9.copyWith(color: greyColor),
              ),
            ],
          ),
          gapHeight(sp4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.code ?? '',
                style: p5.copyWith(color: blackColor),
              ),
              Text(
                '${FormatCurrency(order.paymentHistory)} đ',
                style: p5.copyWith(
                  color: (order.paymentHistory ?? 0) > 0 ? blue_1 : red_1,
                ),
              ),
            ],
          ),
          gapHeight(sp4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.customerName ?? '',
                style: p6.copyWith(color: greyColor),
              ),
              Text(
                '/${FormatCurrency(order.totalPrice)} đ',
                style: p7.copyWith(color: greyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget typeWidget(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: sp4, horizontal: sp8),
      decoration: BoxDecoration(
        border: Border.all(color: type == 'product' ? yellow_3 : blue_4),
        borderRadius: BorderRadius.circular(sp24),
        color: type == 'product' ? yellow_4 : blue_4,
      ),
      child: Text(
        type == 'product' ? 'Đơn hàng sản phẩm' : 'Đơn hàng dịch vụ',
        style: p7.copyWith(
          color: type == 'product' ? yellow_1 : blue_1,
        ),
      ),
    );
  }
