import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/authentication/cubit/verify_account_cubit/verify_account_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../constants/typography.dart';
import '../../../shared/constants/enums/type_account_enum.dart';
import '../cubit/verify_account_cubit/verify_account_cubit.dart';
import '../widgets/pin_code_view.dart';

@RoutePage()
class VerifyAccountPage extends StatefulWidget {
  const VerifyAccountPage({
    super.key,
    required this.name,
    required this.phone,
    required this.idVerify,
    required this.accountTypeEnum,
  });

  final String name;
  final String phone;
  final int idVerify;
  final AccountTypeEnum accountTypeEnum;

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  final myBloc = getIt.get<VerifyAccountCubit>();

  int timeCount = kDebugMode ? 5 : 60;
  Timer? timerCount;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCountTimer();
    });
  }

  void _setCountTimer() {
    timeCount = kDebugMode ? 5 : 60;
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
  void dispose() {
    super.dispose();

    timerCount?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VerifyAccountCubit>(
      create: (context) => myBloc
        ..init(
          widget.idVerify,
        ),
      child: BlocBuilder<VerifyAccountCubit, VerifyAccountState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_4,
            body: Container(
              height: heightDevice(context),
              width: widthDevice(context),
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(sp16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.1),
                          blurRadius: sp4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                        gapHeight(sp24),
                        Image.asset(
                          '${AssetsPath.image}/logo.png',
                          width: sp64,
                        ),
                        gapHeight(sp24),
                        RichText(
                          text: TextSpan(
                            text: 'Tài khoản',
                            style: p3.copyWith(color: blackColor),
                            children: [
                              TextSpan(
                                text: ' ${widget.name} ',
                                style: const TextStyle(color: mainColor),
                              ),
                              const TextSpan(
                                text: 'đã được tạo!',
                              ),
                            ],
                          ),
                        ),
                        gapHeight(sp24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(sp16),
                          decoration: BoxDecoration(
                            color: bg_4,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Mã OTP đã được gửi tới tài khoản Zalo của số điện thoại:\n',
                                      style: p4.copyWith(color: blackColor),
                                    ),
                                    TextSpan(
                                      text: widget.phone,
                                      style: p3.copyWith(color: blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              gapHeight(sp4),
                              Text(
                                timeCount > 0
                                    ? 'OTP chỉ có hiệu lực trong $timeCount giây'
                                    : 'OTP đã hết hạn sử dụng',
                                style: StyleApp.normal(
                                  color: ColorApp.yellowDC,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        gapHeight(sp16),
                        PinCodeView(
                          onChanged: myBloc.codeChange,
                          onCompleted: (value) {
                            myBloc.codeChange(value);
                            _verifyAccount();
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: Row(
                            children: [
                              CustomOutlineBtn(
                                title:
                                    'Gửi lại ${timeCount > 0 ? '($timeCount)' : ''}',
                                onPressed: timeCount > 0 ? null : _resendCode,
                                backgroundColor: ColorApp.white,
                                radius: 4,
                                fixedSize: const Size(double.infinity, 48),
                                textStyle: StyleApp.semibold(
                                  color: timeCount > 0 ? ColorApp.greyD0 : null,
                                  fontSize: 16,
                                ),
                              ).expanded(),
                              16.width,
                              CustomBtn(
                                title: 'Xác nhận',
                                textStyle: StyleApp.semibold(
                                  color: ColorApp.white,
                                  fontSize: 16,
                                ),
                                onPressed: _verifyAccount,
                                radius: 4,
                                fixedSize: const Size(double.infinity, 48),
                              ).expanded(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    DialogUtils.showLoadingDialog(
      context,
      'Đang xác thực tài khoản, vui lòng đợi!',
    );

    myBloc.verifyAccount().then((value) {
      Navigator.of(context).pop();
      if (value.data ?? false) {
        if (widget.accountTypeEnum == AccountTypeEnum.admin) {
          context.router.push( LoginSuccessRoute(name: widget.name, phone: widget.phone)).then((value) {
            if(value != null && value is bool && value){
              context.router.maybePop(true);
            }
          });
        } else {
          DialogUtils.showSuccessDialog(
            context,
            barrierDismissible: false,
            content: 'Xác thực tài khoản thành công',
            titleConfirm: 'Đăng nhập',
            accept: () {
              context.router.popUntil(
                (route) => route.settings.name == 'WelcomeRoute',
              );
              context.router.push(
                TypeAccountRoute(
                  onNext: (p0) => context.router.push(const LoginRoute()),
                ),
              );
            },
          );
        }
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Xác thực tài khoản thất bại',
        );
      }
    });
  }
}
