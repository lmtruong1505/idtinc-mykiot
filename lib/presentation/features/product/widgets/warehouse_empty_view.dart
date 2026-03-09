import 'package:flutter/cupertino.dart';
import 'package:pharmago/presentation/base/svg.dart';

import '../../../base/button.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

class WarehouseEmptyView extends StatelessWidget {
  const WarehouseEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          IcSvg.asset('/ic_empty.svg'),
          gapHeight(sp24),
          Text(
            'Chưa có sản phẩm',
            style: p3.copyWith(color: blackColor),
          ),
          gapHeight(sp8),
          Text(
            'Hiệu thuốc của bạn chưa có sản phẩm nào.\nHãy thêm sản phẩm để dễ dàng quản lý',
            style: p6.copyWith(color: blackColor),
          ),
          gapHeight(sp24),
          SizedBox(
            width: double.infinity,
            child: MainButton(
              title: 'Nhập sản phẩm',
              event: () {},
            ),
          )
        ],
      ),
    );
  }
}
