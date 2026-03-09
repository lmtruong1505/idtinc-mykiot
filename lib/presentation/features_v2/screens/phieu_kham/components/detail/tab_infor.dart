import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/bg_action.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/launch_url.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../../shared/style_app/init_style.dart';

class TabInforPhieuKham extends StatefulWidget {
  final EventModel item;
  const TabInforPhieuKham({
    required this.item,
  });
  @override
  State<TabInforPhieuKham> createState() => _TabInforPhieuKhamState();
}

class _TabInforPhieuKhamState extends State<TabInforPhieuKham>
    with AutomaticKeepAliveClientMixin {
  final titleStyle = StyleApp.normal(color: ColorApp.grey79);

  final contentStyle = StyleApp.medium();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SingleChildScrollView(
          padding: sp16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  color: ColorApp.white,
                  width: 200,
                  height: 200,
                  padding: sp16.pading,
                  child: QrImageView(
                    data: widget.item.code ?? '',
                    version: QrVersions.auto,
                  ),
                ),
              ),
              sp16.height,
              _buildInfor(),
              sp16.height,
              _buildPayment(),
              sp16.height,
              _buildUserCreate(),
              context.padding.bottom.height,
            ],
          ),
        ).expanded(),
      ],
    );
  }

  Widget _buildPayment() {
    final style = StyleApp.normal();
    final list = widget.item.payments ?? [];
    final total = list.fold(
      0.0,
      (previousValue, element) => previousValue + (element.mustPaid ?? 0),
    );
    final hadPaid = list.fold(
      0.0,
      (previousValue, element) => previousValue + (element.hadPaid ?? 0),
    );
    double service = 0;
    double product = 0;

    for (final element in list) {
      if (element.code == TypeOrderEnum.sell.code) {
        product += element.mustPaid ?? 0;
      }
      if (element.code == TypeOrderEnum.service.code) {
        service += element.mustPaid ?? 0;
      }
    }
    print(widget.item.payments?.map(
      (e) => e.toJson(),
    ));
    return BgAction(
      title: 'Thông tin thanh toán',
      isTextClick: false,
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      click: true,
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Tổng tiền',
              content: total.formatPrice(),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Sản phẩm',
              content: product.formatPrice(),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Dịch vụ',
              content: service.formatPrice(),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            Row(
              children: [
                Text(
                  'Đã thu',
                  style: style,
                ).expanded(),
                8.width,
                RichText(
                  text: TextSpan(
                    text: hadPaid.formatPrice(),
                    style: contentStyle.copyWith(
                      color: ColorApp.red,
                    ),
                    children: [
                      TextSpan(
                        text: '/${total.formatPrice()}',
                        style: contentStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCreate() {
    final style = StyleApp.normal();
    return BgAction(
      title: 'Thông tin tài khoản',
      isTextClick: false,
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      click: true,
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Người tạo',
              content: widget.item.userCreated?.fullName,
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Thời gian tạo',
              content: widget.item.createdAt.toDate
                  .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Người cập nhật',
              content: widget.item.userUpdated?.fullName,
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Thời gian cập nhật',
              content: widget.item.updatedAt.toDate
                  .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfor() {
    return BgAction(
      title: 'Thông tin phiếu khám',
      isTextClick: false,
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      click: true,
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Mã phiếu khám',
              content: widget.item.code,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Khách hàng',
              content: widget.item.customer?.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            _textBtn(
              onTap: () {
                if (widget.item.customer != null) {
                  context.pushRoute(
                    RouteCustomerDetail(customer: widget.item.customer!),
                  );
                }
              },
              title: 'Xem chi tiết khách hàng',
            ),
            TextRow2(
              title: 'Cơ sở',
              content: getCompanyName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Bác sĩ',
              content: widget.item.doctor?.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            _textBtn(
              onTap: () {
                print(widget.item.doctor?.username);
                if (widget.item.doctor?.username != null) {
                  LaunchUrl.phone(widget.item.doctor!.username!);
                }
              },
              title: 'Liên hệ bác sĩ',
            ),
            TextRow2(
              title: 'Dịch vụ',
              content: widget.item.services
                  ?.map(
                    (e) => e.title ?? '',
                  )
                  .toList()
                  .listToString,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            sp16.height,
            TextRow2(
              title: 'Mã lịch hẹn',
              content: widget.item.appointmentCode ?? 'Chưa có thông tin',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textBtn({
    Function()? onTap,
    required String title,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        alignment: Alignment.centerRight,
        padding: 16.padingVer,
      ),
      child: Text(
        title,
        style: StyleApp.medium(
          color: ColorApp.blue20,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
