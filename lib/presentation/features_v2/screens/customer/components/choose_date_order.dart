import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/custom_btn.dart';
import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/v2/date_time_widget.dart';
import '../../../blocs/date_time/param_date.dart';

class ChooserDateOrder extends StatefulWidget {
  final Function(DateTime?, DateTime?) onChnaged;
  const ChooserDateOrder({
    super.key,
    required this.onChnaged,
  });

  @override
  State<ChooserDateOrder> createState() => _ChooserDateOrderState();
}

class _ChooserDateOrderState extends State<ChooserDateOrder> {
  ParamDate? paramDate;
  onTap() {
    context.dialog(DateTimeWidget()).then(
      (value) {
        if (value is ParamDate) {
          paramDate = value;
          widget.onChnaged(value.startDate, value.endDate);
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CustomOutlineBtn(
            onPressed: onTap,
            title: paramDate?.startDate?.fomatCustom() ?? 'Chọn thời gian',
            backgroundColor: ColorApp.white,
            borderColor: ColorApp.greyE2,
            textColor: paramDate?.startDate != null
                ? ColorApp.black
                : ColorApp.greyAA,
            padding: Dimensions.sp8.pading,
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 17,
              color: ColorApp.grey79,
            ),
          ),
        ),
        Dimensions.sp16.width,
        const Icon(
          Icons.remove,
          color: ColorApp.black,
        ),
        Dimensions.sp16.width,
        Flexible(
          child: CustomOutlineBtn(
            onPressed: onTap,
            title: paramDate?.endDate?.fomatCustom() ?? 'Chọn thời gian',
            padding: Dimensions.sp8.pading,
            backgroundColor: ColorApp.white,
            borderColor: ColorApp.greyE2,
            textColor: paramDate?.startDate != null
                ? ColorApp.black
                : ColorApp.greyAA,
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 17,
              color: ColorApp.grey79,
            ),
          ),
        ),
      ],
    );
  }
}
