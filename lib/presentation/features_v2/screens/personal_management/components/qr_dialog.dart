import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../data/local/get_data.dart';
import '../../../../base/cache_image.dart';

class QrDiaLog extends StatelessWidget {
  const QrDiaLog({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: 16.radius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          _buildBody(context),
        ],
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Padding(
      padding: 12.pading,
      child: Row(
        children: [
          24.width,
          Text(
            "Mã QR của tôi",
            style: AppStyle.headingLg,
            textAlign: TextAlign.center,
          ).expanded(),
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: 999.radius,
              color: AppColors.button_neutral_alpha_backgroundDefault,
            ),
            padding: 4.pading,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: Icon(
                CupertinoIcons.clear,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildAvatar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.bg_secondary,
            boxShadow: AppShadows.elevator0,
            shape: BoxShape.circle,
          ),
          child: BaseCacheImage(
            url: userAvatar,
            borderRadius: 40.radius,
            errorWidget: const Icon(
              CupertinoIcons.person,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userFullName,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.headingLg,
            ),
            4.height,
            Text(
              '#$userCode',
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
          ],
        ).padding(12.padingHor).expanded(),
      ],
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.button_neutral_alpha_backgroundDefault,
      ),
      padding: 12.padingTop + 32.padingHor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(),
          24.height,
          Container(
            padding: 12.pading,
            decoration: BoxDecoration(
              color: AppColors.bg_primary,
              borderRadius: 16.radius,
              border: Border.all(
                color: AppColors.border_tertiary,
              ),
            ),
            child: QrImageView(
              data: code,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          8.height,
          LabelButton(
            label: 'Đóng',
            labelStyle: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.button_neutral_alpha_textDefault,
            ),
            onPressed: () {
              context.pop();
            },
            backgroundColor: AppColors.button_neutral_alpha_textDefault.withOpacity(0.05),
          ),
          8.height,
        ],
      ),
    );
  }
}
