import 'package:flutter/cupertino.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';

Widget customIcon({
  required Widget icon,
  EdgeInsets? padding,
}) {
  return Container(
    decoration: BoxDecoration(
      color: ColorApp.black.withOpacity(0.05),
      shape: BoxShape.circle,
    ),
    padding: padding ?? 8.pading,
    child: icon,
  );
}