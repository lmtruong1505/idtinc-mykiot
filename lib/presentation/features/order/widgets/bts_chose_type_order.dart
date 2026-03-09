import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../shared/style_app/style_text.dart';
import '../../../constants/colors.dart';

class BtsChoseTypeOrder extends StatefulWidget {
  const BtsChoseTypeOrder({super.key, this.idBranch});

  final int? idBranch;

  @override
  State<BtsChoseTypeOrder> createState() => _BtsChoseTypeOrderState();
}

class _BtsChoseTypeOrderState extends State<BtsChoseTypeOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radiusTop,
      ),
      padding: 16.pading.copyWith(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tạo mới đơn hàng',
            style: StyleApp.bold(fontSize: 16),
          ),
          16.height,
          // InkWell(
          //   onTap: () {
          //     context.router.maybePop();
          //     context.router.push(OrderScanRoute(dataInit: []));
          //   },
          //   child: _buildItem('Quét mã sản phẩm/đơn thuốc', '/ic_service.svg'),
          // ),
          // 8.height,
          InkWell(
            onTap: () {
              context.router.maybePop();
              context.router.push(CreateOrderRoute(type: 'service'));
            },
            child: _buildItem('Đơn hàng dịch vụ', '/ic_product.svg'),
          ),
          8.height,
          InkWell(
            onTap: () {
              context.router.maybePop();
              context.router
                  .push(CreateOrderRoute(type: 'product'));
            },
            child: _buildItem('Đơn hàng sản phẩm', '/ic_product.svg'),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: borderColor_1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          IcSvg.asset(icon),
          8.width,
          Text(
            title,
            style: StyleApp.bold(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
