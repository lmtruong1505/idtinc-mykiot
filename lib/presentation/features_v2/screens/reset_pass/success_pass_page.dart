import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../base/svg.dart';
import '../../../config/app_style/init_app_style.dart';
@RoutePage()
class SuccessPassPage extends StatelessWidget {
  const SuccessPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IcSvg.asset("/chuc_mung.svg", width: 24, height: 24).container(
            padding: 12.pading,
            bgColor: Colors.green.withOpacity(0.1),
            radius: 999,
          ),
          24.height,
          Text(
            'Xin chúc mừng!!!!',
            textAlign: TextAlign.center,
            style: AppStyle.heading2xl,
          ),
          24.height,
          Text(
            'Tạo mật khẩu mới thành công. Vui lòng đăng nhập để sử dụng hệ thống!',
            style: AppStyle.bodyBsRegular.copyWith(color: AppColors.text_tertiary),
            textAlign: TextAlign.center,
          ),
          24.height,
          MainButtonV2(
            onTap: () {
              context.router.replaceAll([const LoginRoute()]);
            },
            radius: 999,
            title: 'Đăng nhập ngay',
            textStyle: StyleApp.semibold(fontSize: 16, color: ColorApp.white),
          ).size(height: 48),
        ],
      ).padding(32.pading),
    );
  }
}
