import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/presentation/features_v2/blocs/auth/reset_pass_bloc.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/main_button.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../base/svg.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/colors.dart';
import '../../blocs/state/init_state.dart';

@RoutePage()
class NewPassPage extends StatefulWidget {
  final String phone;

  const NewPassPage({super.key, required this.phone});

  @override
  State<NewPassPage> createState() => _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
  final _formKey = GlobalKey<FormState>();

  final bloc = ResetPassBloc();

  final pass = TextEditingController();

  final passConfirm = TextEditingController();

  final StreamController<bool> _passwordStream = StreamController();
  final StreamController<bool> _confirmPasswordStream = StreamController();

  @override
  void initState() {
    _passwordStream.add(false);
    _confirmPasswordStream.add(false);
    super.initState();
  }

  @override
  void dispose() {
    _passwordStream.close();
    _confirmPasswordStream.close();
    super.dispose();
  }

  _handle() {
    if (_formKey.currentState!.validate()) {
      bloc.newPass(phone: widget.phone, password: pass.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPassBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            context.router.replaceAll([const SuccessPassRoute()]);
          },
        );
      },
      child: BaseScaffold(
        body: SingleChildScrollView(
          padding: 16.pading + 32.padingTop,
          child: Form(
            key: _formKey,
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
                          'Xác thực OTP',
                          style: AppStyle.bodyBsMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                44.height,
                IcSvg.asset('/key_v2.svg', width: 24, height: 24).container(
                  padding: 12.pading,
                  bgColor: Colors.green.withOpacity(0.1),
                  radius: 999,
                ),
                16.height,
                Text(
                  'Thiết lập mật khẩu mới',
                  style: AppStyle.heading2xl,
                ),
                32.height,
                StreamBuilder(
                  stream: _passwordStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AppInputSupport(
                        hintText: 'Nhập mật khẩu',
                        label: 'Mật khẩu',
                        backgroundColor: ColorApp.white,
                        borderColor: ColorApp.greyA7,
                        show: snapshot.data ?? false,
                        maxLines: 1,
                        required: true,
                        controller: pass,
                        suffixIcon: InkWell(
                          onTap: () {
                            _passwordStream.add(!(snapshot.data ?? false));
                          },
                          child: Icon(
                            snapshot.data ?? false
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            color: borderColor_4,
                          ),
                        ),
                        validate: (value) {
                          return value.validatorTextField(
                            type: TextInputType.visiblePassword,
                            textConfirm: passConfirm.text,
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
                // InputColumn(
                //   padding: EdgeInsets.zero,
                //   label: 'Mật khẩu mới',
                //   radius: 4,
                //   isRequired: true,
                //   textInputType: TextInputType.visiblePassword,
                //   controller: pass,
                //   isPassword: true,
                // ),
                16.height,
                StreamBuilder(
                  stream: _confirmPasswordStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AppInputSupport(
                        hintText: 'Nhập mật khẩu',
                        label: 'Xác nhận mật khẩu',
                        backgroundColor: ColorApp.white,
                        borderColor: ColorApp.greyA7,
                        show: snapshot.data ?? false,
                        maxLines: 1,
                        required: true,
                        controller: passConfirm,
                        suffixIcon: InkWell(
                          onTap: () {
                            _confirmPasswordStream
                                .add(!(snapshot.data ?? false));
                          },
                          child: Icon(
                            snapshot.data ?? false
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            color: borderColor_4,
                          ),
                        ),
                        validate: (value) {
                          return value.validatorTextField(
                            type: TextInputType.visiblePassword,
                            textConfirm: pass.text,
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
                // InputColumn(
                //   padding: EdgeInsets.zero,
                //   label: 'Xác nhận mật khẩu mới',
                //   radius: 4,
                //   isRequired: true,
                //   textInputType: TextInputType.visiblePassword,
                //   controller: passConfirm,
                //   isPassword: true,
                // ),
                24.height,
                MainButtonV2(
                  onTap: _handle,
                  title: 'Xác nhận',
                  radius: 99,
                  textStyle: StyleApp.semibold(
                    fontSize: 16,
                    color: ColorApp.white,
                  ),
                ).size(height: 48),
                16.height,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: AppStyle.bodyBsRegular
                        .copyWith(color: AppColors.text_secondary),
                    children: [
                      TextSpan(
                        text: 'Đăng nhập ngay',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              context.router.replaceAll([const LoginRoute()]),
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.button_brand_ghost_textDefault,
                        ),
                      ),
                    ],
                  ),
                ),
                (context.height * 0.1).height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
