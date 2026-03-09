import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';

class BtsChoseKindCreateOrder extends StatelessWidget {
  const BtsChoseKindCreateOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(sp12),
      ),
      child: Container(
        padding: const EdgeInsets.all(sp16),
        color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tạo đơn nhập thuốc sỉ',
              style: h5.copyWith(color: blackColor),
            ),
            const SizedBox(height: sp16),
            InkWell(
              onTap: () async {
                context.router.push(
                  OrderWmCreateRoute(
                    typeCreate: TypeCreateOrder.byPromotion,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(sp12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: bg_4,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sell_outlined, size: sp20),
                    const SizedBox(width: sp12),
                    Text(
                      'Theo chương trình khuyến mãi',
                      style: p5.copyWith(color: blackColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: sp16),
            InkWell(
              onTap: () => context.router.push(
                OrderWmCreateRoute(
                  typeCreate: TypeCreateOrder.byProduct,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(sp12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: bg_4,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wallet_giftcard_rounded, size: sp20),
                    const SizedBox(width: sp12),
                    Text(
                      'Theo sản phẩm',
                      style: p5.copyWith(color: blackColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: sp24),
          ],
        ),
      ),
    );
  }
}
