import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmago/presentation/base/text_field.dart';

import '../../../base/button.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/reset_password_cubit/reset_password_cubit.dart';
import '../cubit/reset_password_cubit/reset_password_state.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key,
    required this.bloc,
  });

  final ResetPasswordCubit bloc;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nhập mật khẩu mới',
                              style: h2.copyWith(color: blackColor),
                            ),
                            gapHeight(sp16),
                            Text(
                              'Nhập mật khẩu mới của bạn\nvà thử đăng nhập lại',
                              style: p4.copyWith(color: greyColor),
                              textAlign: TextAlign.center,
                            ),
                            gapHeight(sp24),
                            LottieBuilder.asset(
                              '${AssetsPath.lottie}/reset_password.json',
                              width: widthDevice(context) / 2,
                            ),
                            gapHeight(sp24),
                            AppInput(
                              label: 'Mật khẩu',
                              hintText: 'Nhập mật khẩu mới',
                              backgroundColor: bg_5,
                              borderColor: bg_5,
                              required: true,
                              show: state.showPassword,
                              suffixIcon: InkWell(
                                onTap: widget.bloc.showPasswordChange,
                                child: Icon(
                                  state.showPassword
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye_rounded,
                                ),
                              ),
                              onChanged: (value) =>
                                  widget.bloc.passwordChange(password: value),
                            ),
                            gapHeight(sp12),
                            AppInput(
                              label: 'Xác nhận mật khẩu',
                              hintText: 'Nhập lại mật khẩu',
                              backgroundColor: bg_5,
                              borderColor: bg_5,
                              required: true,
                              show: state.showPassword,
                              onChanged: (value) => widget.bloc
                                  .passwordChange(confirmPassword: value),
                            ),
                            gapHeight(sp24),
                            SizedBox(
                              width: double.infinity,
                              child: MainButton(
                                title: 'Đổi mật khẩu',
                                event: _changePasswordHandle,
                              ),
                            ),
                          ],
                        ),
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

  void _changePasswordHandle() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (widget.bloc.state.password != widget.bloc.state.confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin:
              const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16).copyWith(bottom: sp16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sp12),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: yellow_1,
          content: Text(
            'Mật khẩu xác nhận không hợp lệ',
            style: p5.copyWith(color: whiteColor),
          ),
        ),
      );
      return;
    }
    widget.bloc.changePassword().then((value) {
      if (value.code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: const EdgeInsets.symmetric(horizontal: sp24)
                .copyWith(bottom: sp16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: green_1,
            content: Text(
              'Đổi mật khẩu thành công',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
        context.router.popUntil(
          (route) => route.settings.name == 'LoginRoute',
        );
      }
    });
  }
}
