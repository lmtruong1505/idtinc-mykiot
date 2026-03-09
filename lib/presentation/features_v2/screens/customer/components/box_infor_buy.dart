
import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';

Widget BoxInforBuy({
  required String titleLeft,
  required String contentLeft,
  required String titleRight,
  required String contentRight,
}) {
    return Container(
      padding: Dimensions.sp16.pading,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: Dimensions.sp8.radius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _columText(
              title: titleLeft,
              content: contentLeft,
            ),
          ),
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: ColorApp.greyF5,
              width: Dimensions.sp32,
            ),
          ),
          Expanded(
            child: _columText(
              title: titleRight,
              content: contentRight,
            ),
          ),
        ],
      ),
    );
  }
  Column _columText({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: StyleApp.medium(
            color: ColorApp.grey79,
          ),
        ),
        Dimensions.sp16.height,
        Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: StyleApp.semibold(fontSize: 16),
        ),
      ],
    );
  }
