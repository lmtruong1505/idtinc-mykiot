import 'package:flutter/material.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../shared/components/widgets/icon_custom.dart';
import '../config/app_style/init_app_style.dart';

class EmptyContainer extends StatelessWidget {
  final String? msg;
  final String? svgAsset;
  final Widget? icon;
  final EdgeInsets? paddingView;
  const EmptyContainer({
    super.key,
    this.msg,
    this.svgAsset,
    this.icon,
    this.paddingView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconSpecial(
          svgPath: svgAsset ?? Assets.iconsEmpty,
          colorSvg: AppColors.fg_tertiary,
          icon: icon,
        ),
        Text(
          msg ?? 'Danh sách rỗng',
          textAlign: TextAlign.center,
          style: AppStyle.bodyBsMedium,
        ),
      ],
    ).container(padding: paddingView ?? (32.padingVer + 16.padingHor));
  }
}
