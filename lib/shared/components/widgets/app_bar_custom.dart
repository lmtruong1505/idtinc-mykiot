import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';


AppBar AppBarCustom({
  required String title,
  String? subTitle,
  double elevation = 0.2,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: AppColors.bg_primary,
    centerTitle: false,
    titleSpacing: 0,
    iconTheme: const IconThemeData(
      color: AppColors.fg_tertiary,
    ),
    leadingWidth: sp48,
    title: Text(
      title,
      textAlign: TextAlign.left,
      style: s12w500.copyWith(
        color: AppColors.text_tertiary,
      ),
    ),
    bottom: subTitle == null
        ? null
        : PreferredSize(
            preferredSize: const Size.fromHeight(sp48),
            child: Row(
              children: [
                50.width,
                Text(
                  subTitle,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingXl.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ).expanded(),
                16.width,
                ...(actions ?? []),
              ],
            ).padding(6.padingBottom),
          ),
    elevation: elevation,
  );
}

AppBar AppBarTitleCenter({
  required String title,
  String? leadingText,
  double elevation = 0.2,
  double leadingWidth = 120,
  List<Widget>? actions,
  Function()? back,
}) {
  return AppBar(
    backgroundColor: AppColors.bg_primary,
    centerTitle: true,
    titleSpacing: 0,
    iconTheme: const IconThemeData(
      color: AppColors.fg_tertiary,
    ),
    leadingWidth: leadingText == null ? 50 : leadingWidth,
    leading: Row(
      children: [
        BackButton(
          onPressed: back,
        ),
        if (leadingText != null)
          Text(
            leadingText,
            textAlign: TextAlign.left,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
      ],
    ),
    title: Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: AppStyle.headingBs,
    ),
    actions: actions,
    elevation: elevation,
  );
}

AppBar AppBarPage({
  required String title,
  double elevation = 0.2,
  List<Widget>? actions,
  Color? bgColor,
}) {
  return AppBar(
    backgroundColor: bgColor ?? AppColors.bg_primary,
    centerTitle: true,
    titleSpacing: 0,
    iconTheme: const IconThemeData(
      color: AppColors.fg_tertiary,
    ),
    leadingWidth: 50,
    title: Text(
      title,
      style: AppStyle.headingBs,
    ),
    elevation: elevation,
  );
}
