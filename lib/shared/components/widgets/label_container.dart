import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../gen/flutter_assets.dart';
import '../../../presentation/config/app_style/init_app_style.dart';

Widget LabelContainer({
  required String title,
  Widget? icon,
}) =>
    Row(
      children: [
        Container(
          width: 32,
          height: 32,
          padding: 5.pading,
          decoration: const BoxDecoration(
            color: AppColors.bg_secondary,
            shape: BoxShape.circle,
          ),
          child: icon ??
              SvgPicture.asset(
                Assets.svgCircleInfo,
              ),
        ),
        16.width,
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: AppStyle.headingLg,
        ).expanded(),
      ],
    );
