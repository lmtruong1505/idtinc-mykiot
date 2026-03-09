import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarcodeWidget extends StatelessWidget {
  final String data;
  final Size size;
  const BarcodeWidget(
    this.data,
    this.size,
  );

  @override
  Widget build(BuildContext context) {
    final Barcode barcode = Barcode.code128();

    final svg = barcode.toSvg(
      data,
      width: size.width,
      height: size.height,
      drawText: false,
    );
    return SvgPicture.string(svg);
  }
}
