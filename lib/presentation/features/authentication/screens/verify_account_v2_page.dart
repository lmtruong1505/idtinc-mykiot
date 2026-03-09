import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/style_text.dart';
import '../../../base/button.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/verify_account_cubit/verify_account_cubit.dart';
import '../widgets/pin_code_view.dart';

@RoutePage()
class VerifyAccountV2Page extends StatefulWidget {
  const VerifyAccountV2Page(
      {super.key,
      required this.phone,
      required this.name,
      required this.idVerify});

  final String name;
  final String phone;
  final int idVerify;

  @override
  State<VerifyAccountV2Page> createState() => _VerifyAccountV2PageState();
}

class _VerifyAccountV2PageState extends State<VerifyAccountV2Page> {

  final myBloc = getIt.get<VerifyAccountCubit>();

  int timeCount = kDebugMode ? 60 : 60;
  Timer? timerCount;
  var msgError = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    print('idVerify: ${widget.idVerify}');
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
    timeCount = kDebugMode ? 60 : 60;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => myBloc..init(widget.idVerify),
  lazy: false,
  child: BaseScaffold(
      padding: 16.pading + 64.padingTop,
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                  ),
                  8.width,
                  Text(
                    'Đăng ký',
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                ],
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
              style: AppStyle.headingLg.copyWith(
                color: AppColors.text_brand_primary_variant1,
              ),
            ),
            16.height,
            PinCodeView(
              onChanged: myBloc.codeChange,
              onCompleted: (value) {
                myBloc.codeChange(value);
                _verifyAccount();
              },
            ),
            _buildError(),
            16.height,
            ExtraButton(
              title: 'Gửi lại (${timeCount}s)',
              event: () {
                if (timeCount == 0) {
                  _resendCode();
                }
              },
              largeButton: false,
              borderRadius: 999,
              backgroundColor: timeCount == 0 ? ColorApp.main : AppColors.button_neutral_alpha_backgroundDisabled,
              titleColor: timeCount == 0 ? ColorApp.white : AppColors.button_neutral_alpha_textDisabled,
            ),
            16.height,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Đã có tài khoản? ',
                style: StyleApp.semibold(fontSize: 16),
                children: [
                  TextSpan(
                    text: 'Đăng nhập ngay',
                    recognizer: TapGestureRecognizer()..onTap = () => context.router.replaceAll([const LoginRoute()]),
                    style: StyleApp.semibold(fontSize: 16, color: ColorApp.main),
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


  _resendCode() {
    _setCountTimer();
    myBloc.resendCode(widget.phone).then(
          (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(sp16),
            backgroundColor: value == 200 ? green_1 : ColorApp.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            content: Text(
              value != 200
                  ? 'Gửi lại OTP không thành công'
                  : 'Đã gửi mã OTP mới đến tài khoản Zalo của số điện thoại: ${widget.phone}',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      },
    );
  }

  void _verifyAccount() {
    myBloc.verifyAccount().then((value) {
      if(value.code == 200){
        msgError.value = '';
        context.router.push(LoginSuccessRoute(name: widget.name, phone: widget.phone)).then((value) {
          if(value != null && value is bool && value){
            context.router.maybePop(true);
          }
        });
      }
      else{
        msgError.value = value.message ?? 'Mã OTP không chính xác';
      }
    });
  }

  Widget _buildError() {
    return ValueListenableBuilder(
      valueListenable: msgError,
      builder: (context, value, child) {
        if(value.toString().isEmpty) return const SizedBox();
        return Text(
          msgError.value.toString(),
          style: StyleApp.bold(color: ColorApp.red),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
