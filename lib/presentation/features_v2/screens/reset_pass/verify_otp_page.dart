import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../base/button.dart';
import '../../../base/svg.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../features/authentication/widgets/pin_code_view.dart';
import '../../blocs/auth/reset_pass_bloc.dart';

@RoutePage()
class VerifyOtpPage extends StatefulWidget {
  final String phone;

  const VerifyOtpPage({super.key, required this.phone});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final bloc = ResetPassBloc();

  int timeCount = kDebugMode ? 10 : 60;
  Timer? timerCount;
  String code = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCountTimer();
    });
  }

  @override
  void dispose() {
    timerCount?.cancel();
    super.dispose();
  }

  void _setCountTimer() {
    isVerify = false;
    timeCount = kDebugMode ? 10 : 60;
    timerCount?.cancel();
    timerCount = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeCount > 0) {
        timeCount--;
      } else {
        timerCount?.cancel();
      }
      setState(() {});
    });
  }

  _resend() {
    _setCountTimer();
    bloc.sendOtp(widget.phone);
  }

  bool isVerify = false;

  _verify() {
    if (code.length == 6) {
      isVerify = true;
      bloc.verifyOtp(otp: code, phone: widget.phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPassBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        if(state.status == BlocStatus.success && isVerify) {
          context.pushRoute(NewPassRoute(phone: widget.phone));
        }
      },
      child: BaseScaffold(
        body: SingleChildScrollView(
          padding: 16.pading + 32.padingTop,
          child: Column(
            children: [
              16.height,
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                      8.width,
                      Text(
                        'Quên mật khẩu',
                        style: AppStyle.bodyBsMedium,
                      ),
                    ],
                  ),
                ),
              ),
              44.height,
              IcSvg.asset("/ic_shield_v2.svg", width: 24, height: 24).container(
                padding: 12.pading,
                bgColor: Colors.green.withOpacity(0.1),
                radius: 999,
              ),
              16.height,
              Text(
                "Xác thực OTP",
                style: AppStyle.heading2xl,
              ),
              32.height,
              Text(
                'Mã OTP đã được gửi tới số',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              8.height,
              Text(
                widget.phone,
                style: AppStyle.headingXl,
              ),
              16.height,
              PinCodeView(
                onChanged: (p0) {
                  code = p0;
                },
                onCompleted: (p0) => _verify(),
              ),
              _buildError(),
              ExtraButton(
                title: 'Gửi lại (${timeCount}s)',
                event: () {
                  if (timeCount == 0) {
                    _resend();
                  }
                },
                largeButton: false,
                borderRadius: 999,
                backgroundColor: timeCount == 0 ? ColorApp.main : AppColors.button_neutral_alpha_backgroundDisabled,
                titleColor: timeCount == 0 ? ColorApp.white : AppColors.button_neutral_alpha_textDisabled,
              ),
              // SizedBox(
              //   height: 48,
              //   child: Row(
              //     children: [
              //       CustomOutlineBtn(
              //         title: 'Gửi lại ${timeCount > 0 ? '($timeCount)' : ''}',
              //         onPressed: timeCount > 0 ? null : _resend,
              //         backgroundColor: ColorApp.white,
              //         radius: 4,
              //         fixedSize: const Size(double.infinity, 48),
              //         textStyle: StyleApp.semibold(
              //           color: timeCount > 0 ? ColorApp.greyD0 : null,
              //           fontSize: 16,
              //         ),
              //       ).expanded(),
              //       16.width,
              //       CustomBtn(
              //         title: 'Xác nhận',
              //         textStyle: StyleApp.semibold(
              //           color: ColorApp.white,
              //           fontSize: 16,
              //         ),
              //         onPressed: _verify,
              //         radius: 4,
              //         fixedSize: const Size(double.infinity, 48),
              //       ).expanded(),
              //     ],
              //   ),
              // ),
              16.height,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Đã có tài khoản? ',
                  style: StyleApp.semibold(fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Đăng nhập ngay',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            context.router.replaceAll([const LoginRoute()]),
                      style:
                          StyleApp.semibold(fontSize: 16, color: ColorApp.main),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return BlocBuilder<ResetPassBloc, CubitState>(
      bloc: bloc,
      builder: (BuildContext context, CubitState<dynamic> state) {
        if(state.status == BlocStatus.failure) {
          return Transform(
            transform: Matrix4.translationValues(0, -4, 0),
            child: Text(
              state.msg,
              style: AppStyle.bodySmRegular.copyWith(
                color: AppColors.text_negative,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
