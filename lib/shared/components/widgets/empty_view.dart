import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import '../button/label_button.dart';

Widget EmptyComfirm({
  String? labelBtn,
  required String text,
  Function()? onPressed,
  String? svgAsset,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Widget? icon,
  Color? btnColor,
  Widget? imgEmpty,
}) {
  return Center(
    child: Column(
      children: [
        imgEmpty ??
            IconSpecial(
              svgPath: svgAsset ?? Assets.iconsEmpty,
              colorSvg: AppColors.fg_tertiary,
              icon: icon,
            ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppStyle.bodyMdRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        if (onPressed != null) ...[
          16.height,
          LabelButton(
            onPressed: onPressed,
            label: labelBtn ?? 'Thêm mới',
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            backgroundColor: btnColor ?? AppColors.brand,
          ),
        ],
      ],
    ).container(padding: 32.padingVer + 16.padingHor),
  );
}

Widget EmptySearch({
  String? text,
  String? svgAsset,
}) {
  return Column(
    children: [
      SvgPicture.asset(svgAsset ?? Assets.svgSearchEmpty),
      16.height,
      Text(
        text ?? 'Không tìm thấy kết quả',
        textAlign: TextAlign.center,
        style: AppStyle.headingLg,
      ),
    ],
  ).container(padding: 32.padingVer + 16.padingHor);
}
