import 'package:flutter/material.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/base/v2/custom_nav_home_painter.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../shared/constants/pref_key.dart';
import '../../shared/constants/storage/shared_preference.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../features/order/widgets/bts_chose_type_order.dart';

enum TabCode {
  home('Trang chủ', Assets.iconsBottomBarHome, ''),
  customer('Khách hàng', Assets.iconsBottomBarList, ''),
  // product('Sản phẩm', '/bottom_bar/ic_product.svg', ''),
  //scan('Quét QR', '', ''),
  order('Tạo đơn', '', ''),
  orderSell('Đơn hàng', Assets.iconsBottomBarOrders, ''),
  staff('Nhân viên', Assets.iconsBottomBarList, ''),
  menu('Khác', Assets.iconsBottomBarOther, '');

  const TabCode(this.title, this.pathIcon, this.pathIconActive);

  final String title;
  final String pathIcon;
  final String pathIconActive;
}

class BuildBottomBar extends StatelessWidget {
  BuildBottomBar({
    super.key,
    required this.pageCode,
    this.onTap,
  });

  final TabCode pageCode;
  final Function(TabCode value)? onTap;
  final role = AppSharedPreference.instance.getValue(PrefKeys.userCode);

  @override
  Widget build(BuildContext context) {
    double pbottom =
        context.padding.bottom > 0 ? context.padding.bottom * 0.8 : 10;
    return CustomPaint(
      painter: CustomerNavHomePainter(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: TabCode.values
            .where(
              (e) => e != TabCode.staff || role == PrefKeys.codeAdmin,
            )
            .toList()
            .map(
              (e) => Expanded(
                child: InkWell(
                  onTap: () {
                    if (e == TabCode.order) {
                      context.bottomSheet(const BtsChoseTypeOrder());
                      return;
                    }
                    onTap?.call(e);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      e == TabCode.order
                          ? const CircleAvatar(
                              radius: sp24,
                              backgroundColor: mainColor,
                              child: Icon(
                                Icons.add,
                                color: whiteColor,
                              ),
                            )
                          : Image.asset(
                              e.pathIcon,
                              width: sp20,
                              color: pageCode == e ? mainColor : greyColor,
                            ),
                      const SizedBox(height: sp8),
                      Text(
                        e.title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              pageCode == e ? FontWeight.w500 : FontWeight.w400,
                          color: pageCode == e ? mainColor : greyColor,
                        ),
                      ),
                      pbottom.height,
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  final dynamic context;

  BNBCustomPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = whiteColor
      ..style = PaintingStyle.fill;
    final Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(0, 0, 16, 0);
    path.lineTo(size.width * 0.357, 0);
    path.quadraticBezierTo(size.width * 0.405, 0, size.width * 0.425, -13.5);
    // path.arcToPoint(Offset(size.width*0.6, 20), radius: Radius.circular(8), clockwise: false);
    path.quadraticBezierTo(size.width * 0.445, -sp28, size.width * 0.5, -sp28);
    path.quadraticBezierTo(
        size.width * 0.555, -sp28, size.width * 0.575, -13.5);
    path.quadraticBezierTo(size.width * 0.595, 0, size.width * 0.643, 0);
    path.lineTo(size.width - 16, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, 80);
    path.lineTo(0, 80);
    path.close();

    // Vẽ đổ bóng
    final Path shadowPath =
        path.shift(const Offset(0, -1)); // Dịch chuyển path để tạo đổ bóng
    canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.5), 5, false);

    canvas.drawPath(path, paint);
    // canvas.drawShadow(path, Colors.black45, 1, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
