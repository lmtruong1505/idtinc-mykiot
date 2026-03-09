import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../../shared/components/widgets/filter_item.dart';
import '../../../../blocs/enum/enum_bloc.dart';


class BtsFilterPrdService extends StatelessWidget {
  const BtsFilterPrdService({super.key});

  @override
  Widget build(BuildContext context) {
    return BgBts(
      onCancel: () {
        context.pop();
      },
      onConfirm: () {
        context.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterItem(
            select: 1,
            label: 'Thương hiệu',
            items: [
              'Tất cả',
              'Panadol',
              'Hưng Long',
            ],
          ),
          16.height,
          FilterItem(
            select: 1,
            label: 'Loại sản phẩm',
            items: [
              'Tất cả',
              'Tân dược',
              'Nam dược',
            ],
          ),
          16.height,
          FilterItem(
            select: 1,
            label: 'Đơn giá (VND)',
            onTap: (p0) {},
            items: RangePriceV2Enum.values
                .map(
                  (e) => e.title,
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
