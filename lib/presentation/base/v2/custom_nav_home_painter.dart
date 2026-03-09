import 'package:flutter/material.dart';

import '../../../shared/style_app/init_style.dart';

class CustomerNavHomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    const double circle = 56;
    const double cornerRadius = 8;

    final double center = size.width / 2;
    const double radius = circle / 2;

    path.moveTo(0, cornerRadius + circle / 3);
    path.arcToPoint(
      const Offset(cornerRadius, circle / 3),
      radius: const Radius.circular(cornerRadius),
    );

    path.lineTo(center - radius - 30, circle / 3);
    path.quadraticBezierTo(
      center - radius,
      20,
      center - radius + 5,
      circle / 6,
    );

    path.lineTo(center - radius + 5, circle / 6);

    path.arcToPoint(
      Offset(
        center + radius - 5,
        circle / 6,
      ),
      radius: const Radius.circular(circle / 2),
      clockwise: true,
      rotation: 180,
    );
    path.lineTo(center + radius - 5, circle / 6);
    path.quadraticBezierTo(
      center + radius,
      20,
      center + radius + 30,
      circle / 3,
    );
    path.lineTo(center + radius + 30, circle / 3);

    path.lineTo(size.width - cornerRadius, circle / 3);
    path.arcToPoint(
      Offset(size.width, cornerRadius + circle / 3),
      radius: const Radius.circular(cornerRadius),
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cornerRadius);

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = ColorApp.white;

    // Vẽ đổ bóng
     final Path shadowPath =
        path.shift(const Offset(0, -6)); 
    canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.2), 5, false);

    canvas.drawPath(path, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
