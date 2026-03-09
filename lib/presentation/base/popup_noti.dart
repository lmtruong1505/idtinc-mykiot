import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../config/app_style/init_app_style.dart';
import '../constants/colors.dart';
import '../constants/size_device.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import 'button.dart';

// ignore: must_be_immutable
class BasePopupNoti extends StatelessWidget {
  BasePopupNoti({
    super.key,
    required this.content,
    required this.status,
    this.click,
    this.close,
    this.titleClose,
    this.titleConfirm,
    this.isClose = true,
    this.header,
  });

  String content;
  Function? click;
  Function? close;
  StatusNoti status;
  bool isClose;

  String? titleConfirm;
  String? titleClose;

  String? header;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(sp16)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp16),
          ),
          width: max(widthDevice(context) - sp32, 343),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == StatusNoti.LOADING)
                const CircularProgressIndicator()
              else
                CircleAvatar(
                  radius: 30,
                  backgroundColor: status == StatusNoti.SUCCESS
                      ? green_2
                      : status == StatusNoti.WARNING
                          ? yellow_2
                          : red_2,
                  child: IcSvg.asset(
                    status == StatusNoti.SUCCESS
                        ? '/noti/icon_noti_success.svg'
                        : status == StatusNoti.WARNING
                            ? '/noti/warning.svg'
                            : '/noti/icon_noti_err.svg',
                  ),
                ),
              const SizedBox(height: sp24),
              Text(
                header != null
                    ? header!
                    : (status == StatusNoti.SUCCESS
                        ? 'Thành công'
                        : 'Cảnh báo'),
                style: h3.copyWith(color: blackColor),
              ),
              const SizedBox(height: sp12),
              Text(
                content,
                style: p4.copyWith(color: AppColors.bg_black),
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
              if (status != StatusNoti.LOADING) const SizedBox(height: sp24),
              if (status != StatusNoti.LOADING)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (click != null && isClose)
                      Expanded(
                        flex: 1,
                        child: ExtraButton(
                          title: titleClose ?? 'Quay lại',
                          event: () {
                            if (close != null) close!.call();
                          },
                          borderColor: borderColor_2,
                          largeButton: true,
                          icon: null,
                        ),
                      ),
                    if (click != null && isClose) const SizedBox(width: sp16),
                    if (click != null)
                      Expanded(
                        flex: 1,
                        child: supportButton(
                          title: titleConfirm ?? 'Xác nhận',
                          event: () {
                            if (click != null) {
                              click!();
                            }
                          },
                          largeButton: true,
                          icon: null,
                          backgroundColor: mainColor,
                          color: whiteColor,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BasePopupNotiV2 extends StatelessWidget {
  const BasePopupNotiV2({
    super.key,
    required this.title,
    required this.content,
    required this.titleClose,
    required this.titleConfirm,
    required this.leftIcon,
    this.confirm,
    this.close,
  });

  final String title;
  final String content;
  final String titleClose;
  final String titleConfirm;
  final Widget leftIcon;
  final VoidCallback? confirm;
  final VoidCallback? close;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(sp16)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: sp16, horizontal: sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp16),
          ),
          width: max(widthDevice(context) - sp32, 343),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leftIcon,
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (close != null) close!();
                    },
                    child: const Icon(
                      Icons.close,
                      color: AppColors.button_neutral_alpha_iconDefault,
                    ).container(
                      padding: 3.pading,
                      radius: 999,
                      bgColor: AppColors.button_neutral_alpha_backgroundDefault
                          .withOpacity(0.05),
                    ),
                  ),
                ],
              ),
              16.height,
              Text(
                title,
                style: AppStyle.headingLg,
              ),
              Text(
                content,
                style: AppStyle.bodyBsRegular
                    .copyWith(color: AppColors.text_secondary),
              ),
              16.height,
              Row(
                children: [
                  ExtraButton(
                    title: titleClose,
                    event: () {
                      if (close != null) close!();
                    },
                    titleColor: AppColors.button_neutral_alpha_textDefault,
                    backgroundColor: AppColors.button_neutral_alpha_backgroundDisabled
                        .withOpacity(0.05),
                    borderRadius: 999,
                    largeButton: false,
                  ).expanded(),
                  16.width,
                  ExtraButton(
                    title: titleConfirm,
                    event: () {
                      if (confirm != null) confirm!();
                    },
                    titleColor: AppColors.button_neutral_solid_textDefault,
                    backgroundColor:
                        AppColors.button_neutral_solid_backgroundDefault,
                    borderRadius: 999,
                    largeButton: false,
                  ).expanded(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
