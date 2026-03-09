import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../router/router.gr.dart';
import '../../../models/calendar/event_model.dart';

class ItemPhieuKham extends StatelessWidget {
  final EventModel phieuKham;
  const ItemPhieuKham({
    super.key,
    required this.phieuKham,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    return InkWell(
      onTap: () {
        context.pushRoute(DetailPhieuKhamRoute(
          item: phieuKham,
        ));
      },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 8.radius,
          border: Border.all(
            color: ColorApp.greyE2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '#${phieuKham.code ?? ""}',
              style: StyleApp.medium(
                color: ColorApp.grey79,
              ),
            ),
            const Divider(
              height: 32,
              color: ColorApp.greyF2,
            ),
            TextRow2(
              title: 'Tên khách hàng',
              content: phieuKham.customer?.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Cơ sở',
              content: getCompanyName ?? '',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Bác sĩ',
              content: phieuKham.doctor?.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Thời gian tạo',
              content: phieuKham.createdAt.toDate?.fomatDefaulft,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Dịch vụ',
              content: phieuKham.services
                  ?.map(
                    (e) => e.title ?? '',
                  )
                  .toList()
                  .listToString,
              titleStyle: titleStyle,
              contentStyle: StyleApp.medium(color: ColorApp.main),
            ),
          ],
        ),
      ),
    );
  }
}
