import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../base/dialog.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/spacing.dart';
import '../../../shared/constants/enums/type_account_enum.dart';
import '../../blocs/auth/reset_pass_bloc.dart';

@RoutePage()
class OtpResetPassPage extends StatefulWidget {
  final String phone;
  const OtpResetPassPage({required this.phone});
  @override
  State<OtpResetPassPage> createState() => _OtpResetPassPageState();
}

class _OtpResetPassPageState extends State<OtpResetPassPage> {
  final _formKey = GlobalKey<FormState>();

  final phone = TextEditingController();

  final bloc = ResetPassBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phone.text = widget.phone;
  }

  _handleBtn() {
    if (_formKey.currentState?.validate() == true) {
      bloc.sendOtp(phone.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPassBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.success) {
          context.pushRoute(VerifyOtpRoute(phone: phone.text));
        }
        if (state.status == BlocStatus.failure) {
          DialogUtils.showErrorDialog(
            context,
            content: state.msg,
            titleClose: 'Trở về',
            titleConfirm: 'Đăng ký ngay',
            header: 'Chưa tồn tại hoặc chưa đăng ký',
            status: StatusNoti.WARNING,
            close: () {
              context.pop();
            },
            accept: () {
              context.router.replaceAll([
                const LoginRoute(),
                RegisterRoute(
                  accountType: AccountTypeEnum.admin,
                  phone: phone.text,
                ),
              ]);
            },
          );
        }
      },
      child: BaseScaffold(
        body: SingleChildScrollView(
          padding: 16.pading,
          child: Form(
            key: _formKey,
            onChanged: () {
              _formKey.currentState?.validate();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                context.padding.top.height,
                (context.height * 0.1).height,
                Center(
                  child: Image.asset(
                    '${AssetsPath.image}/logo.png',
                    width: sp64,
                  ),
                ),
                gapHeight(sp16),
                Text(
                  'Quên mật khẩu',
                  textAlign: TextAlign.center,
                  style: AppStyle.heading2xl,
                ),
                gapHeight(24),
                AppInputSupport(
                  hintText: 'Nhập số điện thoại',
                  controller: phone,
                  label: 'Số điện thoại',
                  required: true,
                  textInputType: TextInputType.phone,
                  radius: 8,
                  prefixIcon: const Icon(Icons.phone),
                ),
                24.height,
                MainButtonV2(
                  onTap: _handleBtn,
                  title: 'Gửi yêu cầu',
                  radius: 99,
                  textStyle: StyleApp.semibold(
                    fontSize: 16,
                    color: ColorApp.white,
                  ),
                ).size(height: 48),
                28.height,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: StyleApp.semibold(fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Đăng nhập ngay',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.pop(result: phone.text),
                        style: StyleApp.semibold(
                          fontSize: 16,
                          color: ColorApp.main,
                        ),
                      ),
                    ],
                  ),
                ),
                context.padding.bottom.height,
                (context.height * 0.1).height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
