import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../router/router.gr.dart';

class ItemCustomer extends StatefulWidget {
  final CustomerModel customer;
  const ItemCustomer({
    super.key,
    required this.customer,
  });

  @override
  State<ItemCustomer> createState() => _ItemCustomerState();
}

class _ItemCustomerState extends State<ItemCustomer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.customer.zalo == null) {
          context.pushRoute(RouteCustomerDetail(customer: widget.customer));
        } else {
          widget.customer.zalo?.lastMessage?.read = true;
          setState(() {});
          context.pushRoute(RouteChatRoom(customer: widget.customer));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: Dimensions.sp8.radius,
          color: ColorApp.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      widget.customer.fullName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: StyleApp.semibold(
                        fontSize: 16,
                      ),
                    ).expanded(),
                    Text(
                      widget.customer.revenue.formatPrice(type: 'đ'),
                      style: StyleApp.semibold(color: ColorApp.teal),
                    ),
                  ],
                ),
                Dimensions.sp12.height,
                Row(
                  children: [
                    Text(
                      widget.customer.phone ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: StyleApp.normal(),
                    ).expanded(),
                    Text(
                      '(${widget.customer.orders ?? 0} đơn hàng)',
                      style: StyleApp.normal(),
                    ),
                  ],
                ),
              ],
            ).padding(
              Dimensions.sp16.padingHor + Dimensions.sp12.padingVer,
            ),
            const Divider(
              height: 0,
              color: ColorApp.greyE2,
            ),
            Text(
              zaloMessage,
              style: StyleApp.medium(
                color: widget.customer.zalo?.lastMessage?.read == false
                    ? ColorApp.black
                    : ColorApp.greyAA,
              ),
            ).padding(Dimensions.sp8.pading),
          ],
        ),
      ),
    );
  }

  String get zaloMessage {
    final String text =
        (widget.customer.zalo?.lastMessage?.sendBy == 1 ? 'Bạn: ' : 'Khách: ');
    if (widget.customer.zalo?.lastMessage?.message.isEmptyOrNull == false) {
      return text + (widget.customer.zalo?.lastMessage?.message ?? '');
    }

    if (widget.customer.zalo?.lastAttachment.isEmptyOrNull == false) {
      return '$textĐã gửi 1 ảnh';
    }
    return 'Chưa tương tác Zalo OA';
  }
}
