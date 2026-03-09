import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/order_wm_entity.dart';

import '../../../base/row_item.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';
import 'status_order.dart';

class OrderWmPreviewCard extends StatelessWidget {
  const OrderWmPreviewCard({
    super.key,
    required this.item,
    this.onSelect,
  });

  final OrderWmDetailEntity item;
  final Function()? onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp24),
      decoration: BoxDecoration(
        // border: Border.all(color: mainColor, width: 0.5),
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Visibility(
              //   visible: onSelect != null,
              //   child: Container(
              //     margin: const EdgeInsets.only(right: sp8),
              //     child: BaseCheckbox(
              //       value: item.isSelected ?? false,
              //       onChanged: (value) => onSelect?.call(),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Text(
                  item.code ?? '',
                  style: p5.copyWith(color: borderColor_4),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: sp12),
              StatusOrderCard(
                title: item.orderStatus?.title ?? '',
                id: item.orderStatus?.id ?? 0,
                typeOrder: TypeOrder.cHTH,
              ),
            ],
          ),
          const Divider(height: sp32),
          // RowItem(
          //   title: 'Tên khách hàng',
          //   content: item.customerName ?? 'Chưa có thông tin',
          // ),
          // const SizedBox(height: sp12),
          RowItem(
            title: 'Thời gian tạo đơn',
            content: DateFormat('H:m a dd/MM/y')
                .format(item.createAt ?? DateTime.now()),
          ),
          // const SizedBox(height: sp12),
          // RowItem(title: 'Người tạo', content: item.userCreatedName ?? ''),
          const SizedBox(height: sp12),
          RowItem(title: 'Hoá đơn đỏ', content: item.orderRed ? 'Có' : 'Không'),
          const SizedBox(height: sp12),
          RowItem(
            title: 'Tổng tiền',
            content: '${FormatCurrency(item.total)} VNĐ',
            contetnColor: mainColor,
          ),
        ],
      ),
    );
  }
}
