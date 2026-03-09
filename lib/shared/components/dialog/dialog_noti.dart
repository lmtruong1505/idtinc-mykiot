import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

class DialogNoti extends StatelessWidget {
  final String message;
  final String icon;
  final Color color;
  final Widget? subTitle;
  final List<Widget>? actions;
  final Function()? onClose;
  const DialogNoti({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
    this.subTitle,
    this.onClose,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: AppColors.bg_primary,
      shape: RoundedRectangleBorder(
        borderRadius: 12.radius,
        side: const BorderSide(
          color: AppColors.border_secondary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBorderCustom(
                icon: SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  color: color,
                ),
                color: color,
              ),
              const Spacer(),
              IconBtn(
                onTap: onClose,
                backgroundColor: Colors.transparent,
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          Text(
            message,
            style: AppStyle.headingLg.copyWith(height: 1.5),
          ).padding(16.padingHor),
          if (subTitle != null) subTitle!.padding(16.padingHor + 4.padingTop),
          if (actions != null)
            Row(
              children: actions!,
            ),
          16.height,
        ],
      ),
    ).padding(16.pading).size(width: context.width);
  }
}
