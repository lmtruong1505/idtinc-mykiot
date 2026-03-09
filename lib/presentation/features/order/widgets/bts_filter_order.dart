import 'package:flutter/material.dart';

import '../../../base/date_select.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

enum OrderFilterOrderBy {
  createNearest(title: 'Ngày tạo gần nhất', code: 'created_at'),
  createFurthest(title: 'Ngày tạo xa nhất', code: '-created_at'),
  updateNearest(title: 'Ngày cập nhật gần nhất', code: 'updated_at'),
  updateFurthest(title: 'Ngày cập nhật xa nhất', code: '-updated_at');

  final String title;
  final String code;
  const OrderFilterOrderBy({
    required this.title,
    required this.code,
  });
}

class BtsFilterOrder extends StatefulWidget {
  const BtsFilterOrder({
    super.key,
    this.onConfirm,
    this.createdAtFrom,
    this.createdAtTo,
    this.orderBy,
    this.updatedFrom,
    this.updatedTo,
  });

  final Function({
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    DateTime? updatedFrom,
    DateTime? updatedTo,
    OrderFilterOrderBy? orderBy,
  })? onConfirm;
  final DateTime? createdAtFrom;
  final DateTime? createdAtTo;
  final DateTime? updatedFrom;
  final DateTime? updatedTo;
  final OrderFilterOrderBy? orderBy;

  @override
  State<BtsFilterOrder> createState() => _BtsFilterOrderState();
}

class _BtsFilterOrderState extends State<BtsFilterOrder> {
  OrderFilterOrderBy? _orderByGroup;
  DateTime? _createdAtFrom;
  DateTime? _createdAtTo;
  DateTime? _updatedFrom;
  DateTime? _updatedTo;

  @override
  void initState() {
    super.initState();

    _orderByGroup = widget.orderBy;
    _createdAtFrom = widget.createdAtFrom;
    _createdAtTo = widget.createdAtTo;
    _updatedFrom = widget.updatedFrom;
    _updatedTo = widget.updatedTo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightDevice(context) * 0.9,
      padding: const EdgeInsets.all(sp16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _orderByGroup = null;
                    _createdAtFrom = null;
                    _createdAtTo = null;
                    _updatedFrom = null;
                    _updatedTo = null;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Text('Đặt lại', style: p3.copyWith(color: blue_1)),
                ),
              ),
              const Text('Bộ lọc', style: p3),
              InkWell(
                onTap: () {
                  widget.onConfirm?.call(
                    createdAtFrom: _createdAtFrom,
                    createdAtTo: _createdAtTo,
                    updatedFrom: _updatedFrom,
                    updatedTo: _updatedTo,
                    orderBy: _orderByGroup,
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Text('Áp dụng', style: p3.copyWith(color: blue_1)),
                ),
              ),
            ],
          ),
          const Divider(height: sp32),
          Text(
            'Sắp xếp theo',
            style: p5.copyWith(color: blackColor),
          ),
          SizedBox(
            height: sp32,
            child: RadioListTile<OrderFilterOrderBy>(
              contentPadding: const EdgeInsets.all(sp0),
              value: OrderFilterOrderBy.createNearest,
              groupValue: _orderByGroup,
              onChanged: _orderByChange,
              title: Text(
                OrderFilterOrderBy.createNearest.title,
                style: p6.copyWith(color: blackColor),
              ),
            ),
          ),
          gapHeight(sp12),
          SizedBox(
            height: sp32,
            child: RadioListTile<OrderFilterOrderBy>(
              contentPadding: const EdgeInsets.all(sp0),
              value: OrderFilterOrderBy.createFurthest,
              groupValue: _orderByGroup,
              onChanged: _orderByChange,
              title: Text(
                OrderFilterOrderBy.createFurthest.title,
                style: p6.copyWith(color: blackColor),
              ),
            ),
          ),
          gapHeight(sp12),
          SizedBox(
            height: sp32,
            child: RadioListTile<OrderFilterOrderBy>(
              contentPadding: const EdgeInsets.all(sp0),
              value: OrderFilterOrderBy.updateNearest,
              groupValue: _orderByGroup,
              onChanged: _orderByChange,
              title: Text(
                OrderFilterOrderBy.updateNearest.title,
                style: p6.copyWith(color: blackColor),
              ),
            ),
          ),
          gapHeight(sp12),
          SizedBox(
            height: sp32,
            child: RadioListTile<OrderFilterOrderBy>(
              contentPadding: const EdgeInsets.all(sp0),
              value: OrderFilterOrderBy.updateFurthest,
              groupValue: _orderByGroup,
              onChanged: _orderByChange,
              title: Text(
                OrderFilterOrderBy.updateFurthest.title,
                style: p6.copyWith(color: blackColor),
              ),
            ),
          ),
          gapHeight(sp24),
          Text(
            'Thời gian tạo',
            style: p5.copyWith(color: blackColor),
          ),
          gapHeight(sp12),
          Row(
            children: [
              oneDate(
                context,
                value: _createdAtFrom,
                changeDate: (value) => {
                  setState(
                    () {
                      _createdAtFrom = value;
                    },
                  ),
                },
              ),
              gapWidth(sp12),
              oneDate(
                context,
                value: _createdAtTo,
                changeDate: (value) => {
                  setState(
                    () {
                      _createdAtTo = value;
                    },
                  ),
                },
              ),
            ],
          ),
          gapHeight(sp16),
          Text(
            'Thời gian cập nhật',
            style: p5.copyWith(color: blackColor),
          ),
          gapHeight(sp12),
          Row(
            children: [
              oneDate(
                context,
                value: _updatedFrom,
                changeDate: (value) => {
                  setState(
                    () {
                      _updatedFrom = value;
                    },
                  ),
                },
              ),
              gapWidth(sp12),
              oneDate(
                context,
                value: _updatedTo,
                changeDate: (value) => {
                  setState(
                    () {
                      _updatedTo = value;
                    },
                  ),
                },
              ),
            ],
          ),
          gapHeight(sp16),
          // CommonDropdown(
          //   label: 'Theo kho',
          //   items: [
          //     DropdownMenuItem(value: 1, child: Text('Kho 1', style: p6)),
          //     DropdownMenuItem(value: 2, child: Text('Kho 2', style: p6)),
          //     DropdownMenuItem(value: 3, child: Text('Kho 3', style: p6)),
          //     DropdownMenuItem(value: 4, child: Text('Kho 4', style: p6)),
          //   ],
          //   hintText: 'Chọn kho',
          //   onChanged: (value) => {},
          // ),
          // gapHeight(sp16),
          // CommonDropdown(
          //   label: 'Theo nhà cung cấp',
          //   items: [
          //     DropdownMenuItem(
          //         value: 1, child: Text('Nhà cung cấp 1', style: p6)),
          //     DropdownMenuItem(
          //         value: 2, child: Text('Nhà cung cấp 2', style: p6)),
          //     DropdownMenuItem(
          //         value: 3, child: Text('Nhà cung cấp 3', style: p6)),
          //     DropdownMenuItem(
          //         value: 4, child: Text('Nhà cung cấp 4', style: p6)),
          //   ],
          //   hintText: 'Chọn nhà cung cấp',
          //   onChanged: (value) => {},
          // ),
        ],
      ),
    );
  }

  void _orderByChange(OrderFilterOrderBy? value) {
    setState(() {
      _orderByGroup = value;
    });
  }
}
