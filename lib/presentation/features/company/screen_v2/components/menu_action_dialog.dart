import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../../shared/components/dialog/dialog_message.dart';
import 'menu_popup.dart';

void menuActionDialog(
  BuildContext context, {
  required StatusMenuWorkspace value,
  required String title,
  required Function() confirm,
  TypeCreateCompany type = TypeCreateCompany.company,
  String? contentText,
  String? typeName,
}) {
  context.dialog(
    DialogConfirm(
      title: '${value.title} ${typeName ?? type.value}',
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: contentText ?? content(value, type),
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
          ),
          children: [
            TextSpan(
              text: title,
              style: AppStyle.bodyBsSemiBold.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            TextSpan(
              text: ' không?',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
          ],
        ),
      ),
      //confirmLabel: value.title,
      actionConfirmBorder: value != StatusMenuWorkspace.active,
      colorConfirmBtn: value != StatusMenuWorkspace.active
          ? AppColors.button_negative_outlined_textDefault
          : AppColors.button_brand_solid_backgroundDefault,
      icon: icon(value),
      confirm: confirm,
    ),
  );
}

IconDiaLog icon(StatusMenuWorkspace value) {
  switch (value) {
    case StatusMenuWorkspace.unActive:
      return IconDiaLog(
        color: AppColors.fg_negative.withOpacity(0.1),
        icon: SvgPicture.asset(
          Assets.iconsLock,
        ),
      );
    case StatusMenuWorkspace.active:
      return IconDiaLog(
        color: AppColors.fg_positive.withOpacity(0.1),
        icon: SvgPicture.asset(
          Assets.iconsUnLock,
        ),
      );
    default:
      return IconDiaLog(
        color: AppColors.fg_negative.withOpacity(0.1),
        icon: const Icon(
          CupertinoIcons.delete,
          color: AppColors.fg_negative,
          size: 32,
        ),
      );
  }
}

String content(StatusMenuWorkspace value, TypeCreateCompany type) {
  switch (value) {
    case StatusMenuWorkspace.unActive:
      return 'Bạn có chắc chắn muốn vô hiệu hóa ${type.value} ';
    case StatusMenuWorkspace.active:
      return 'Bạn có chắc chắn muốn kích hoạt ${type.value} ';
    default:
      return 'Bạn có chắc chắn muốn xoá ${type.value} ';
  }
}
