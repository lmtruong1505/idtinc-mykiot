import 'package:flutter/widgets.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../config/app_style/init_app_style.dart';

Widget ItemServiceEvent({
  required String title,
  Color? color,
  EdgeInsets? padding,
}) {
  return Row(
    children: [
      Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.14),
        child: FaIcon(
          iconCode: 'e110',
          size: 10,
          type: FaIconType.solid,
          color: AppColors.bg_tertiary,
        ),
      ),
      12.width,
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: AppStyle.bodySmSemiBold.copyWith(
          color: color ?? AppColors.text_quaternary,
          height: 1.5,
        ),
      ).expanded(),
    ],
  ).padding(padding ?? 9.padingLeft + 12.padingRight);
}
