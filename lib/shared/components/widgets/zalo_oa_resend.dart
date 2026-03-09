import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import 'fa_icon.dart';

Widget ZaloIcon(String svgPath) {
  return Container(
    width: 32,
    height: 32,
    padding: 4.pading,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.ultility_blue.withOpacity(0.05),
      ),
    ),
    child: Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.ultility_blue.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: SvgPicture.asset(
        svgPath,
        width: 18,
      ),
    ),
  );
}

Widget ReSendZaloOaWidget({
  Function()? reSend,
}) {
  return Row(
    children: [
      ZaloIcon(
        Assets.svgZalo,
      ),
      4.width,
      Text(
        'Gửi lịch hẹn đến khách hàng',
        style: AppStyle.bodyMdSemiBold.copyWith(
          color: AppColors.text_tertiary,
          fontSize: 12,
        ),
      ).expanded(),
      12.width,
      FaIcon(
        iconCode: 'f058',
        color: AppColors.fg_positive,
        type: FaIconType.solid,
      ),
      if (reSend != null) 8.width,
      if (reSend != null)
        LabelButton(
          label: 'Gửi lại',
          backgroundColor: AppColors.button_neutral_alpha_backgroundDefault,
          labelStyle: AppStyle.bodyBsMedium,
          onPressed: reSend,
        ).size(height: 32),
    ],
  ).container(
    bgColor: AppColors.bg_primary,
    padding: 8.pading,
    radius: 8,
    border: Border.all(color: AppColors.border_tertiary),
  );
}
