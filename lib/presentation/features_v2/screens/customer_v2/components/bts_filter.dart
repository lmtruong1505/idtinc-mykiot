import 'package:flutter/material.dart';

import 'package:pharmago/presentation/shared/constants/enums/status_order.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../shared/components/widgets/filter_item.dart';
import '../../../blocs/enum/enum_bloc.dart';

class BtsFilterCustomer extends StatefulWidget {
  final bool? isZalo;
  final RangePriceV2Enum? rangePrice;
  final TypeOrderV2Enum? typeOrder;
  final IsDebtEnum? isDebt;

  final Function(
    bool? isZalo,
    RangePriceV2Enum? rangePrice,
    TypeOrderV2Enum? typeOrder,
    IsDebtEnum? isDebt,
  )? onChanged;

  const BtsFilterCustomer({
    super.key,
    this.isZalo,
    this.rangePrice,
    this.typeOrder,
    this.onChanged,
    this.isDebt,
  });

  @override
  State<BtsFilterCustomer> createState() => _BtsFilterCustomerState();
}

class _BtsFilterCustomerState extends State<BtsFilterCustomer> {
  int typeOrder = 0;
  int rangePrice = 0;
  int isZalo = 0;
  int isDebt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.rangePrice != null) {
      rangePrice = widget.rangePrice!.index;
    }
    if (widget.typeOrder != null) {
      typeOrder = widget.typeOrder!.index;
    }
    if (widget.isDebt != null) {
      isDebt = widget.isDebt!.index;
    }
    if (widget.isZalo != null) {
      isZalo = ZaloOaEnum.values.indexWhere(
        (element) => element.data == widget.isZalo!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Cấu hình giá dịch vụ',
      cancelText: 'Thiết lập lại',
      confirmText: 'Xác nhận',
      onCancel: () {
        context.pop();
        widget.onChanged?.call(null, null, null, null);
      },
      onConfirm: () {
        context.pop();
        widget.onChanged?.call(
          ZaloOaEnum.values[isZalo].data,
          RangePriceV2Enum.values[rangePrice],
          TypeOrderV2Enum.values[typeOrder],
          IsDebtEnum.values[isDebt],
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterItem(
            select: typeOrder,
            onTap: (p0) {
              setState(() {
                typeOrder = p0;
              });
            },
            label: 'Khách hàng',
            items: List.generate(
              TypeOrderV2Enum.values.length,
              (index) => TypeOrderV2Enum.values[index].title,
            ),
          ),
          16.height,
          FilterItem(
            select: isZalo,
            onTap: (p0) {
              setState(() {
                isZalo = p0;
              });
            },
            label: 'Quan tâm zalo OA',
            items: List.generate(
              ZaloOaEnum.values.length,
              (index) => ZaloOaEnum.values[index].title,
            ),
          ),
          16.height,
          FilterItem(
            select: rangePrice,
            onTap: (p0) {
              setState(() {
                rangePrice = p0;
              });
            },
            label: 'Tổng đơn (VNĐ)',
            items: List.generate(
              RangePriceV2Enum.values.length,
              (index) => RangePriceV2Enum.values[index].title,
            ),
          ),
          16.height,
          FilterItem(
            select: isDebt,
            onTap: (p0) {
              setState(() {
                isDebt = p0;
              });
            },
            label: 'Công nợ',
            items: List.generate(
              IsDebtEnum.values.length,
              (index) => IsDebtEnum.values[index].title,
            ),
          ),
        ],
      ),
    );
  }
}
