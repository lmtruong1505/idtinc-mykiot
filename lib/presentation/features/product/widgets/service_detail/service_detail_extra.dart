import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/expandable.dart';

import '../../../../base/row_item.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../cubit/service_detail_cubit/service_detail_cubit.dart';

class ServiceDetailExtra extends StatefulWidget {
  const ServiceDetailExtra({required this.myBloc, super.key});

  final ServiceDetailCubit myBloc;

  @override
  State<ServiceDetailExtra> createState() => _ServiceDetailExtra();
}

class _ServiceDetailExtra extends State<ServiceDetailExtra> {
  @override
  Widget build(BuildContext context) {
    final item = widget.myBloc.state.service;
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Expandable(
        header: 'Thông tin bổ sung',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RowItem(title: 'Thuơng hiệu', content: item?.brand ?? ''),
            gapHeight(sp12),
            RowItem(title: 'Thời gian thực hiện', content: item?.actionTime ?? ''),
            gapHeight(sp12),
            const Text(
              'Chỉ định',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item?.chiDinh ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const Text(
              'Chống chỉ định',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item?.chongChiDinh ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const Text(
              'Công dụng',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item?.congDung ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const RowItem(title: 'Hình thức', content: 'Thuốc'),
            gapHeight(sp12),
            RowItem(title: 'Tác dụng phụ', content: item?.tacDungPhu ?? ''),
            gapHeight(sp12),
            RowItem(title: 'Lưu ', content: item?.luuY ?? ''),
            gapHeight(sp12),
            RowItem(
              title: 'Công ty đăng ký',
              content: item?.congTyDk ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
