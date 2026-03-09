import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/date.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import 'dialog.dart';

// Widget oneDoubleTime(
//   BuildContext context, {
//   required String label,
//   List<DateTime>? value,
//   Function(List<DateTime>? value)? changeDate,
// }) =>
//     Column(
//       children: [
//         Container(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             label,
//             style: p5.copyWith(color: blackColor),
//           ),
//         ),
//         gapHeight(sp12),
//         InkWell(
//           onTap: () async {
//             final dates = await DialogUtils.showCalendarDatePicker(context);
//             if (dates != null) changeDate?.call(dates[0]!);
//           },
//           child: Row(
//             children: [
//               oneDate(context, value: value, changeDate: changeDate),
//               gapWidth(sp12),
//               oneDate(context, value: value, changeDate: changeDate),
//             ],
//           ),
//         ),
//       ],
//     );

Widget oneDate(
  BuildContext context, {
  DateTime? value,
  Function(DateTime value)? changeDate,
}) =>
    Expanded(
      child: InkWell(
        onTap: () async {
          final dates = await DialogUtils.showCalendarDatePicker(context);
          if (dates != null) changeDate?.call(dates[0]!);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp12,
            horizontal: sp16,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: borderColor_2),
            borderRadius: BorderRadius.circular(sp8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value == null ? 'Từ ngày' : Date.formatDateDay(value),
                  style: p6.copyWith(color: blackColor),
                ),
              ),
              gapWidth(sp12),
              const Icon(Icons.calendar_month, size: sp20, color: greyColor),
            ],
          ),
        ),
      ),
    );
