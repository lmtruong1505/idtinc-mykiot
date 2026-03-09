import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../../shared/constants/storage/shared_preference.dart';
import '../../../base/button.dart';
import '../../../base/dialog.dart';
import '../../../base/text_field.dart';
import '../../../constants/asset_path.dart';
import '../../../di/di.dart';
import '../../../services/local_auth.dart';
import '../cubit/login_cubit/login_cubit.dart';
import '../cubit/login_cubit/login_state.dart';

class LoginPopupView extends StatefulWidget {
  const LoginPopupView({super.key});

  @override
  State<LoginPopupView> createState() => _LoginPopupViewState();
}

class _LoginPopupViewState extends State<LoginPopupView> {
  final _myBloc = getIt.get<LoginCubit>();

  final _formKey = GlobalKey<FormState>();

  final _shared = AppSharedPreference.instance;

  late String? _username;
  late String? _fullName;

  late TextEditingController _passwordCtl;

  @override
  void initState() {
    super.initState();
    _fullName = _shared.getValue(PrefKeys.userFullName) as String?;
    _username = _shared.getValue(PrefKeys.username) as String?;

    _passwordCtl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _myBloc,
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: heightDevice(context) / 5,
          horizontal: sp16,
        ),
        child: Container(
          width: widthDevice(context) - sp32,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp16),
          ),
          padding: const EdgeInsets.all(sp16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  '${AssetsPath.image}/logo.png',
                  width: sp64,
                  height: sp64,
                ),
                gapHeight(sp16),
                Text(
                  'Xin chào!\nPhiên đăng nhập đã hết hạn',
                  style: p3.copyWith(color: blackColor),
                  textAlign: TextAlign.center,
                ),
                gapHeight(sp16),
                Text(
                  _fullName!,
                  style: h5.copyWith(color: blackColor),
                ),
                Text(
                  _username!,
                  style: p6.copyWith(color: greyColor),
                ),
                gapHeight(sp16),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (_passwordCtl.text != state.password) {
                      _passwordCtl.text = state.password;
                    }
                    return AppInput(
                      controller: _passwordCtl,
                      label: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      backgroundColor: bg_5,
                      borderColor: bg_5,
                      show: state.showPassword,
                      maxLines: 1,
                      required: true,
                      onChanged: (value) {
                        _myBloc.fieldChange(password: value);
                      },
                      suffixIcon: InkWell(
                        onTap: _myBloc.showPasswordChange,
                        child: Icon(
                          state.showPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          color: borderColor_4,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.private_connectivity_outlined,
                        size: sp20,
                        color: greyColor,
                      ),
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                      },
                    );
                  },
                ),
                gapHeight(sp16),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: MainButton(
                        title: 'Đăng nhập',
                        event: _loginEvent,
                      ),
                    ),
                    gapWidth(sp12),
                    InkWell(
                      onTap: _loginWithBiometrics,
                      child: Container(
                        width: sp54,
                        padding: const EdgeInsets.all(sp12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(sp12),
                          border: Border.all(color: borderColor_2),
                        ),
                        child: Image.asset(
                          '${AssetsPath.image}/login/img_face_id.png',
                        ),
                      ),
                    ),
                  ],
                ),
                gapHeight(sp16),
                InkWell(
                  onTap: () {
                    _shared.clear();
                    context.router.replaceAll([const LoginRoute()]);
                  },
                  child: Text(
                    'Đăng nhập với tài khoản khác',
                    style: p5.copyWith(color: mainColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginEvent() async {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }

    DialogUtils.showLoadingDialog(
      context,
      'Đang xác thực tài khoản, vui lòng đợi !',
    );

    _myBloc.login().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        Navigator.of(context).pop();
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Sai tên tài khoản hoặc mật khẩu',
        );
      }
    });
  }

  void _loginWithBiometrics() async {
    final shared = AppSharedPreference.instance;
    final biometrics = shared.getValue(PrefKeys.biometrics) as bool?;
    if (biometrics == null || biometrics == false) {
      DialogUtils.showErrorDialog(
        context,
        content:
            'Vui lòng đăng nhập -> Cài đặt -> Bật tính\nnăng đăng nhập với khuôn mặt/vân tay\nđể sử dụng tính năng',
      );
      return;
    }
    LocalAuthService.instance.authHandle().then((value) {
      if (value) {
        final pass = shared.getValue(PrefKeys.password) as String?;
        _myBloc.fieldChange(password: pass);
        setState(() {
          _passwordCtl.text = pass ?? '';
        });
        _loginEvent();
      }
    });
  }
}
