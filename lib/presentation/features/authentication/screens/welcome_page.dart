import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../check_version/check_vesion.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/spacing.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckVersion.checkAndPush(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        padding: const EdgeInsets.only(top: sp32),
        width: widthDevice(context),
        height: heightDevice(context),
        child: Column(
          children: [
            gapHeight(sp56),
            // SvgPicture.asset('${AssetsPath.lottie}/welcome.svg'),
            Image.asset(
              '${AssetsPath.image}/welcome_v2.png',
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                width: widthDevice(context),
                padding:
                    const EdgeInsets.symmetric(vertical: sp24, horizontal: sp24)
                        .copyWith(top: sp54),
                color: whiteColor,
                child: Column(
                  children: [
                    Image.asset(
                      '${AssetsPath.image}/logo.png',
                      width: sp64,
                    ),
                    gapHeight(sp16),
                    Text(
                      'Xin chào!',
                      style: h4.copyWith(color: blackColor),
                    ),
                    gapHeight(sp8),
                    Text(
                      'Đăng nhập để sử dụng dịch vụ \n bán hàng của Pharmago',
                      style: p5.copyWith(
                        color: blackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Tiếp tục',
                        event: () => context.router.push(LoginRoute()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
