import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

Widget headerItem({
  required Widget prefix,
  required String title,
}) {
  return Row(
    children: [
      prefix,
      16.width,
      Text(
        title,
        style: AppStyle.headingLg,
      ),
    ],
  );
}