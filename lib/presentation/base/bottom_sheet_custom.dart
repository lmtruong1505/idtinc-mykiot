import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/fa_icon.dart';

class BottomSheetCustom extends StatelessWidget {
  const BottomSheetCustom({
    super.key,
    required this.title,
    this.confirmTitle,
    required this.body,
    required this.onConfirm,
    this.height,
    this.showBottomBar = true,
    this.isDoubleBtn = true,
  });
  final String title;
  final String? confirmTitle;
  final Widget body;
  final dynamic Function()? onConfirm;
  final double? height;
  final bool showBottomBar;
  final bool isDoubleBtn;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: SizedBox(
        height: height ?? heightDevice(context) / 2,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              title,
              style: s16w500.copyWith(color: AppColors.black, height: 1),
            ),
            actions: [
              GestureDetector(
                child: FaIcon(iconCode: 'f057', size: 24),
                onTap: () => context.pop(),
              ),
            ],
          ),
          body: body,
          bottomNavigationBar: showBottomBar == true
              ? Row(
                  children: [
                    if (isDoubleBtn) ...[
                      ExtraButton(
                        title: 'Huỷ bỏ',
                        borderRadius: sp24,
                        event: () => context.pop(),
                      ).expanded(),
                      gapWidth(sp16),
                    ],
                    MainButton(
                      title: confirmTitle ?? 'Xác nhận',
                      radius: sp24,
                      event: () async {
                        onConfirm?.call();
                      },
                    ).expanded(),
                  ],
                ).padding((Platform.isIOS ? 8 : 0).padingBottom)
              : null,
        ).padding(16.pading),
      ),
    );
  }
}

Future<dynamic> showModalBottomSheetCustom({
  required BuildContext context,
  required Widget body,
  required String title,
  required dynamic Function()? onConfirm,
  String? confirmTitle,
  bool? isScrollControlled,
  bool? isDismissible,
  bool showBottomBar = true,
  bool isDoubleBtn = true,
  double? height,
}) {
  return showModalBottomSheet(
    backgroundColor: AppColors.white,
    isDismissible: isDismissible ?? true,
    isScrollControlled: isScrollControlled ?? false,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(sp16)),
    ),
    builder: (context) => BottomSheetCustom(
      title: title,
      confirmTitle: confirmTitle,
      body: body,
      onConfirm: onConfirm,
      height: height,
      showBottomBar: showBottomBar,
      isDoubleBtn: isDoubleBtn,
    ),
  );
}
