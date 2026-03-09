import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../config/app_style/init_app_style.dart';

class NotiCard extends StatelessWidget {
  const NotiCard({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    required this.close,
  });

  final Widget icon;
  final String title;
  final String? subTitle;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 12.radius,
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const Spacer(),
              InkWell(
                onTap: () => close.call(),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          8.height,
          Text(
            title,
            style: AppStyle.headingLg,
          ),
          if (subTitle != null) 4.height,
          if (subTitle != null)
            Text(
              subTitle!,
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
        ],
      ),
    );
  }
}
