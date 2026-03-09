import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:toastification/toastification.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import '../button/label_button.dart';
import '../dialog/dialog_noti.dart';

class ToastCustom {
  static show(
    BuildContext context, {
    required String title,
    required String msg,
    String svgIcon = Assets.svgWarningOutline,
    Color color = AppColors.ultility_carrot_60,
    Widget? subTitle,
    Map<String, HighlightedWord>? highlightWords,
    Duration? timeClose,
    PageRouteInfo? route,
    String? labelBtn,
  }) {
    toastification.showCustom(
      context: context,
      autoCloseDuration: timeClose ?? const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
      builder: (BuildContext context, ToastificationItem holder) {
        return DialogNoti(
          message: title,
          actions: route != null
              ? [
                  LabelButton(
                    onPressed: () {
                      context.pushRoute(route);
                      toastification.dismissById(holder.id);
                    },
                    label: labelBtn ?? 'Xem chi tiết',
                    backgroundColor: AppColors.bg_primary,
                    labelStyle: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_brand_ghost_textDefault,
                    ),
                    spaceIcon: 4,
                    suffixIcon: const Icon(
                      Icons.arrow_outward_rounded,
                      color: AppColors.button_brand_ghost_textDefault,
                      size: 15,
                    ),
                  ),
                ]
              : null,
          subTitle: subTitle ??
              TextHighlight(
                text:
                    msg, // You need to pass the string you want the highlights
                words: highlightWords ?? {}, // Your dictionary words
                textStyle: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_secondary,
                  height: 1.2,
                ),
              ),
          icon: svgIcon,
          color: color,
          onClose: () {
            toastification.dismissById(holder.id);
          },
        );
      },
    );
  }

  static show2(
      BuildContext context, {
        required String title,
        required String msg,
        required String svgIcon,
        required Color color,
        Duration? timeClose,
        String? titleConfirm,
        String? titleClose,
        Function()? onConfirm,
        Function()? onClose,
      }) {
    toastification.showCustom(
      context: context,
      autoCloseDuration: timeClose ?? const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
      builder: (BuildContext context, ToastificationItem holder) {
        return DialogNoti(
          message: title,
          subTitle: Text(
            msg,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_secondary,
              height: 1.2,
            ),
          ),
          actions: [
            LabelButton(
              onPressed: () {
                if (onClose != null) {
                  onClose();
                }
                toastification.dismissById(holder.id);
              },
              label: titleClose ?? 'Đóng',
              backgroundColor: AppColors.bg_primary,
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.button_neutral_ghost_textDefault,
              ),
              spaceIcon: 4,
            ),
            LabelButton(
              onPressed: () {
                if (onConfirm != null) {
                  onConfirm();
                }
                toastification.dismissById(holder.id);
              },
              label: titleConfirm ?? 'Xác nhận',
              backgroundColor: AppColors.bg_primary,
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.button_brand_ghost_textDefault,
              ),
              spaceIcon: 4,
            ),
          ],
          icon: svgIcon,
          color: color,
          onClose: () {
            toastification.dismissById(holder.id);
          },
        );
      },
    );
  }
}
