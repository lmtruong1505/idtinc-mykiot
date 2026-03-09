import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';

Widget TextInContainer(String text, Color color) {
  return Container(
    padding: 4.padingHor,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: 4.radius,
    ),
    child: Text(
      text,
      style: StyleApp.normal(fontSize: 12, color: color),
    ),
  );
}
