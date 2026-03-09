import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/label_button.dart';
import '../../../../config/app_style/init_app_style.dart';

class DialogCancelEvent extends StatefulWidget {
  const DialogCancelEvent({super.key});

  @override
  State<DialogCancelEvent> createState() => _DialogCancelEventState();
}

class _DialogCancelEventState extends State<DialogCancelEvent> {
  int indexData = -1;
  final textCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: 16.pading,
      shape: RoundedRectangleBorder(
        borderRadius: 16.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconSpecial(
            icon: FaIcon(
              iconCode: 'f273',
              size: 24,
              type: FaIconType.solid,
              color: AppColors.ultility_negative_60,
            ),
            color: AppColors.ultility_negative_60,
            svgPath: '',
          ),
          Text(
            'Xác nhận hủy lịch hẹn',
            style: AppStyle.headingLg,
            textAlign: TextAlign.center,
          ),
          18.height,
          ...List.generate(
            reason.length,
            (index) => _buildReason(
              index,
            ),
          ),
          Row(
            children: [
              _buildCheckBox(reason.length),
              8.width,
              AppInputV2(
                radius: 8,
                hintText: 'Lý do khác',
                controller: textCtl,
              ).expanded(),
            ],
          ).padding(8.padingVer + 16.padingHor),
          Row(
            children: [
              LabelButton(
                label: 'Huỷ bỏ',
                backgroundColor:
                    AppColors.button_neutral_solid_backgroundDefault,
                labelStyle: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.button_neutral_solid_textDefault,
                ),
                onPressed: () {
                  context.pop();
                },
              ).expanded(),
              12.width,
              LabelButton(
                label: 'Xác nhận',
                border: const BorderSide(
                  color: AppColors.button_negative_outlined_borderDefault,
                ),
                backgroundColor: AppColors.bg_primary,
                labelStyle: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.button_negative_ghost_textDefault,
                ),
                onPressed: () {
                  if (indexData >= 0 && indexData < reason.length) {
                    context.pop(result: reason[indexData]);
                  } else if (indexData == reason.length &&
                      textCtl.text.isNotEmpty) {
                    context.pop(result: textCtl.text);
                  } else {
                    ToastCustom.show(
                      context,
                      title: 'Cảnh báo',
                      msg: indexData == reason.length && textCtl.text.isEmpty
                          ? 'Vui lòng nhập lý do huỷ lịch hẹn'
                          : 'Vui lòng chọn lý do huỷ lịch hẹn',
                    );
                  }
                },
              ).expanded(),
            ],
          ).padding(16.pading),
        ],
      ),
    );
  }

  final List<String> reason = [
    'Sức khỏe không cho phép',
    'Bận công việc',
    'Do thời tiết',
    'Không sắp xếp được phương tiện',
  ];

  Widget _buildReason(int index) {
    return Row(
      children: [
        _buildCheckBox(index),
        8.width,
        Text(
          reason[index],
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_primary,
          ),
        ).expanded(),
      ],
    ).padding(16.padingHor);
  }

  Widget _buildCheckBox(int index) {
    return IconBtn(
      onTap: () {
        indexData = index;
        setState(() {});
      },
      padding: 4.pading,
      backgroundColor: AppColors.bg_primary,
      // size: const Size(24, 24),
      icon: FaIcon(
        iconCode: indexData == index ? 'f058' : 'f111',
        type: indexData == index ? FaIconType.solid : FaIconType.light,
        color: indexData == index ? AppColors.brand : AppColors.bg_secondary,
        size: 20,
      ),
    );
  }
}
