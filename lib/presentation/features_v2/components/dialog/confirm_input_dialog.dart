import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../gen/flutter_assets.dart';

class ConfirmInputDialog extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? labelInput;
  final Function()? onCancel;
  final Function(String)? onConfirm;

  ConfirmInputDialog({
    super.key,
    required this.title,
    this.subTitle,
    this.labelInput,
    this.onCancel,
    this.onConfirm,
  });

  final _keyForm = GlobalKey<FormState>();
  final _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: 24.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: ColorApp.red,
            child: Center(
              child: SvgPicture.asset(
                Assets.imgsError,
                height: 50,
              ),
            ),
          ),
          24.height,
          Text(
            title,
            textAlign: TextAlign.center,
            style: StyleApp.semibold(fontSize: 18),
          ),
          if (subTitle != null) ...[
            16.height,
            Text(
              subTitle!,
              style: StyleApp.normal(color: ColorApp.grey),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
          24.height,
          Form(
            key: _keyForm,
            onChanged: () {
              _keyForm.currentState?.validate();
            },
            child: AppInputV2(
              label: labelInput,
              required: true,
              controller: _text,
              maxLines: null,
              radius: 4,
              hintText: 'Nhập ${labelInput?.toLowerCase() ?? ""}',
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập ${labelInput?.toLowerCase() ?? " đầy đủ thông tin"}';
                }
              },
            ),
          ),
          24.height,
          RowBtn(
            cancelText: 'Đóng',
            confirmText: 'Xác nhận',
            onCancel: onCancel ?? () => context.pop(),
            onConfirm: () {
              if (_keyForm.currentState?.validate() ?? false) {
                onConfirm?.call(_text.text);
              }
            },
          ),
        ],
      ).padding(16.pading),
    );
  }
}
