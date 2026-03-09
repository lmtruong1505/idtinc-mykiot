import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';

import '../../../../config/app_style/init_app_style.dart';

Widget EmptyEvent({
  Function()? onPressed,
}) {
  return EmptyComfirm(
    icon: FaIcon(
      iconCode: 'f133',
      size: 32,
      type: FaIconType.solid,
    ),
    labelBtn: 'Tạo lịch hẹn',
    suffixIcon: const Icon(
      Icons.add,
      size: 16,
      color: AppColors.bg_primary,
    ),
    text: 'Chưa có lịch hẹn',
    onPressed: onPressed,
  );
}
