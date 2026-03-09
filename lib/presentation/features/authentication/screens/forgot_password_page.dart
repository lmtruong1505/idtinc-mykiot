import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/authentication/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../cubit/reset_password_cubit/reset_password_state.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final myBloc = getIt.get<ResetPasswordCubit>();
  final _key = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
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
                              'Quên mật khẩu',
                              style: h2.copyWith(color: blackColor),
                            ),
                            gapHeight(sp16),
                            Text(
                              'Ghi nhớ và điền địa chỉ email\ncủa bạn xuống bên dưới',
                              style: p4.copyWith(color: blackColor),
                              textAlign: TextAlign.center,
                            ),
                            gapHeight(sp24),
                            LottieBuilder.asset(
                              '${AssetsPath.lottie}/forgot_password.json',
                              width: widthDevice(context) / 2,
                            ),
                            gapHeight(sp24),
                            Form(
                              key: _key,
                              child: AppInput(
                                label: 'Địa chỉ Email',
                                hintText: 'Nhập địa chỉ email',
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  size: sp20,
                                ),
                                suffixIcon: SizedBox(
                                  width: 50,
                                  child: _statusCheck(state.status),
                                ),
                                backgroundColor: bg_5,
                                borderColor: bg_5,
                                onChanged: myBloc.phoneChange,
                                validate: (value) {
                                  if (state.status != TypeChecking.success) {
                                    return 'Địa chỉ Email chưa tồn tại';
                                  }
                                },
                              ),
                            ),
                            gapHeight(sp24),
                            SizedBox(
                              width: double.infinity,
                              child: MainButton(
                                title: 'Xác nhận email',
                                event: _confirmMailHandle,
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
      ),
    );
  }

  Widget _statusCheck(TypeChecking value) {
    switch (value) {
      case TypeChecking.isChecking:
        return const BaseLoading();
      case TypeChecking.success:
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: green_1,
        );
      case TypeChecking.notFound:
        return const Icon(
          Icons.warning_amber_rounded,
          color: yellow_1,
        );
      default:
        return const SizedBox();
    }
  }

  void _confirmMailHandle() {
    final validate = _key.currentState?.validate();
    if (!(validate ?? false)) {
      return;
    }
    myBloc.sendCode();
    context.navPush(VerifyCodeRoute(bloc: myBloc));
  }
}
