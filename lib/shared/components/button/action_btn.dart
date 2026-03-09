import 'package:flutter/cupertino.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';

Widget ActionBtn({
  required String title,
  required Function() onTap,
  Color? color = AppColors.bg_primary,
  TextStyle? style,
}) =>
    Container(
      color: color,
      child: CupertinoActionSheetAction(
        onPressed: onTap,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: style ?? AppStyle.bodyBsSemiBold.copyWith(
            color: AppColors.text_secondary,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
