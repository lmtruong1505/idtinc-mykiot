import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:readmore/readmore.dart';

import '../../../shared/style_app/init_style.dart';
import '../../config/app_style/init_app_style.dart';

Widget textRow({
  required String title,
  required String content,
  TextStyle? contentStyle,
  TextStyle? titleStyle,
  TextAlign textAlign = TextAlign.right,
}) {
  return Row(
    children: [
      Text(
        title,
        style: titleStyle ??
            StyleApp.normal(
              fontSize: 12,
              color: ColorApp.white,
            ),
      ),
      Dimensions.sp12.width,
      Expanded(
        child: Text(
          content,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
          style: contentStyle ??
              StyleApp.medium(
                color: ColorApp.white,
              ),
        ),
      ),
    ],
  );
}

Widget TextRow2({
  required String title,
  String? content,
  int maxLines = 1,
  TextStyle? contentStyle,
  TextStyle? titleStyle,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Expanded(
        child: Text(
          title,
          style: titleStyle ??
              AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
        ),
      ),
      Dimensions.sp16.width,
      Expanded(
        child: Text(
          content.isEmptyOrNull ? 'Chưa có thông tin' : content!,
          textAlign: TextAlign.right,
          // overflow: TextOverflow.ellipsis,
          style: contentStyle ??
              (content.isEmptyOrNull
                  ? AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_disable,
                    )
                  : AppStyle.bodyBsMedium),
        ),
      ),
    ],
  );
}

Widget TextRow3({
  required String title,
  required String content,
  TextStyle? contentStyle,
  TextStyle? titleStyle,
  TextAlign textAlign = TextAlign.right,
}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: titleStyle ?? StyleApp.semibold(),
        ),
      ),
      Dimensions.sp12.width,
      Text(
        content,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: contentStyle ?? StyleApp.semibold(),
      ),
    ],
  );
}

Widget TextRow4({
  required String title,
  String? content,
  int maxLines = 1,
  TextStyle? contentStyle,
  TextStyle? titleStyle,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Text(
        title,
        style: titleStyle ?? StyleApp.normal(),
      ),
      Dimensions.sp16.width,
      Expanded(
        child: Text(
          content.isEmptyOrNull ? 'Chưa có thông tin' : content!,
          textAlign: TextAlign.right,
          // overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
          style: contentStyle ?? StyleApp.medium(),
        ),
      ),
    ],
  );
}

Row TextRowDashboard({
  required String title,
  required String content,
  double percent = 0,
  bool isPercent = true,
  TextStyle? titleStyle,
}) {
  const color = Color(0xFF039457);
  const colorRed = Color(0xFFC74B4B);

  return Row(
    children: [
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: titleStyle ?? StyleApp.normal(),
      ),
      sp12.width,
      Expanded(
        child: Text(
          content,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: StyleApp.semibold(),
        ),
      ),
      if (isPercent) ...[
        4.width,
        RotatedBox(
          quarterTurns: percent >= 0 ? 0 : 2,
          child: Image.asset(
            Assets.iconsIcUp,
            width: 8,
            color: percent >= 0 ? color : colorRed,
          ),
        ),
        2.width,
        Text(
          percent.formatPercent(type: '%').replaceAll('-', ''),
          overflow: TextOverflow.ellipsis,
          style: StyleApp.normal(
            fontSize: 12,
            color: percent >= 0 ? color : colorRed,
          ),
        ),
      ],
    ],
  );
}

Widget TextRowReadMore({
  required String title,
  String? content,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.text_secondary,
        ),
      ),
      ReadMoreText(
        content ?? 'Chưa có thông tin',
        trimMode: TrimMode.Line,
        trimLines: 1,
        textAlign: TextAlign.justify,
        isExpandable: true,
        trimCollapsedText: 'Xem thêm',
        trimExpandedText: 'Ẩn bớt',
        colorClickableText: AppColors.button_brand_ghost_textDefault,
        style: AppStyle.bodyBsRegular.copyWith(
          color: content.isEmptyOrNull
              ? AppColors.text_disable
              : AppColors.text_primary,
        ),
      ),
    ],
  );
}
