import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../customer/data/models/customer_model.dart';

Widget customerViewItem(
  BuildContext context,
  CustomerModel item,
  bool isSelected, {
  Function()? onTap,
}) {
  return MaterialButton(
    onPressed: onTap,
    padding: 12.pading,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.fullName ?? '',
          style: StyleApp.semibold(
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.phone_outlined,
              size: 12,
            ),
            4.width,
            Text(
              item.phone ?? '',
              style: StyleApp.normal(fontSize: 14, color: ColorApp.grey79),
            ),
          ],
        ),
      ],
    ),
  );
}
