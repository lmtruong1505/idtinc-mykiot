import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../base/svg.dart';
import '../../../config/app_style/init_app_style.dart';

@RoutePage()
class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key, required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IcSvg.asset('/chuc_mung.svg', width: 24, height: 24).container(
                padding: 12.pading,
                bgColor: Colors.green.withOpacity(0.1),
                radius: 999,
              ),
              24.height,
              Text(
                'Xin chúc mừng!',
                textAlign: TextAlign.center,
                style: AppStyle.heading2xl,
              ),
              24.height,
              RichText(
                text: TextSpan(
                  text: 'Tài khoản ',
                  style: StyleApp.normal(
                    fontSize: 16,
                    color: ColorApp.black,
                  ),
                  children: [
                    TextSpan(
                      text: name,
                      style: StyleApp.bold(
                        fontSize: 16,
                        color: ColorApp.main,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' được tạo thành công. Vui lòng đăng nhập để sử dụng hệ thống!',
                      style: StyleApp.normal(
                        fontSize: 16,
                        color: ColorApp.black,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              24.height,
              MainButton(
                title: 'Đăng nhập ngay',
                event: () {
                  context.router.maybePop(true);
                },
                largeButton: true,
                radius: 999,
              )
            ],
        ),
      ).padding(16.pading),
    );
  }
}
