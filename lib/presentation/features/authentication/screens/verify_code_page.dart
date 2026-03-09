import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmago/presentation/features/authentication/widgets/pin_code_view.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../base/button.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/reset_password_cubit/reset_password_cubit.dart';
import '../cubit/reset_password_cubit/reset_password_state.dart';

@RoutePage()
class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key, required this.bloc});

  final ResetPasswordCubit bloc;

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {

  int seccond = 60;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seccond >= 1) {
        setState(() {
          seccond -= 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: whiteColor,
            body: Container(
              padding: const EdgeInsets.all(sp24),
              width: widthDevice(context),
              height: heightDevice(context),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.router.pop(),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nhập mã code',
                            style: h2.copyWith(color: blackColor),
                          ),
                          gapHeight(sp16),
                          Text(
                            'Chúng tôi đã gửi mã về địa chỉ email\ncủa bạn',
                            style: p4.copyWith(color: greyColor),
                            textAlign: TextAlign.center,
                          ),
                          gapHeight(sp24),
                          LottieBuilder.asset(
                            '${AssetsPath.lottie}/check_otp.json',
                            width: widthDevice(context) / 2,
                          ),
                          gapHeight(sp24),
                          PinCodeView(
                            shape: PinCodeFieldShape.underline,
                            onChanged: widget.bloc.codeChange,
                            onCompleted: (_) {
                              _verifyCodeHandle();
                            },
                          ),
                          gapHeight(sp24),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Code hết hạn trong: ',
                                  style: p5.copyWith(color: greyColor),
                                ),
                                TextSpan(
                                  text: ' 00 : $seccond',
                                  style: h6.copyWith(color: blue_1),
                                ),
                              ],
                            ),
                          ),
                          gapHeight(sp8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Không nhận được mã? ',
                                  style: p5.copyWith(color: greyColor),
                                ),
                                TextSpan(
                                  text: ' Gửi lại code',
                                  style: h6.copyWith(color: blue_1),
                                ),
                              ],
                            ),
                          ),
                          gapHeight(sp24),
                          SizedBox(
                            width: double.infinity,
                            child: MainButton(
                              title: 'Xác nhận email',
                              event: _verifyCodeHandle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _verifyCodeHandle() {
    widget.bloc.verifyCode().then((value) {
      if (value?.code == 200) {
        context.navPush(ChangePasswordRoute(bloc: widget.bloc));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: sp24)
                .copyWith(bottom: sp12),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Mã code không hợp lệ',
              style: p5.copyWith(color: whiteColor),
            ),
            backgroundColor: red_1,
          ),
        );
      }
    });
  }
}
