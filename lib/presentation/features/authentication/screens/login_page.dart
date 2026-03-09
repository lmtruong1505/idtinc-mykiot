import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/presentation/check_version/check_vesion.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/auth/user_bloc.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/validate.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../base/button.dart';
import '../../../base/check_box.dart';
import '../../../base/text_field.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';

import '../../../shared/constants/enums/type_account_enum.dart';
import '../cubit/login_cubit/login_cubit.dart';
import '../cubit/login_cubit/login_state.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _myBloc = getIt.get<LoginCubit>();

  final _formKey = GlobalKey<FormState>();

  final _shared = AppSharedPreference.instance;

  late String? _username;
  late String? _fullName;

  final _passwordCtl = TextEditingController();
  final _phoneCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _shared.remove(PrefKeys.token);
    _fullName = _shared.getValue(PrefKeys.userFullName) as String?;
    _username = _shared.getValue(PrefKeys.username) as String?;
    final passwordStore = _shared.getValue(PrefKeys.password) as String?;
    final rememberPassword =
        _shared.getValue(PrefKeys.rememberPassword) as bool?;
    _passwordCtl.text = passwordStore ?? '';

    _myBloc.fieldChange(
      username: _username,
      password: passwordStore,
      rememberPassword: rememberPassword,
    );
  }

  @override
  void dispose() {
    _passwordCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => _myBloc,
      child: UpdateWidget(
        child: BaseScaffold(
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: widthDevice(context),
                height: heightDevice(context),
                padding: const EdgeInsets.symmetric(
                  horizontal: sp24,
                  vertical: sp32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Image.asset(
                        '${AssetsPath.image}/pharmago_v2.png',
                        width: sp64,
                      ),
                      gapHeight(sp16),
                      haveAcc() ? headerNoAcc() : headerHaveAcc(),
                      gapHeight(sp32),
                      if (!haveAcc())
                        AppInputSupport(
                          label: 'Số điện thoại',
                          hintText: 'Nhập số điện thoại của bạn',
                          controller: _phoneCtl,
                          textInputType: TextInputType.phone,
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          required: true,
                          onChanged: (value) =>
                              _myBloc.fieldChange(username: value),
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập số điện thoại';
                            } else if (!isPhoneNumberValid(value ?? '')) {
                              return 'Sai định dạng số điện thoại.';
                            }
                            return null;
                          },
                        ),
                      gapHeight(sp8),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return AppInputSupport(
                            controller: _passwordCtl,
                            label: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu',
                            backgroundColor: ColorApp.white,
                            borderColor: ColorApp.greyA7,
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
                            onConfirm: (value) {
                              _loginEvent();
                            },
                            validate: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      gapHeight(sp24),
                      Row(
                        children: [
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              return BaseCheckbox(
                                value: state.rememberPassword,
                                onChanged: (value) {
                                  _myBloc.rememberPasswordHandle(value);
                                },
                              );
                            },
                          ),
                          gapWidth(sp12),
                          Text(
                            'Ghi nhớ tài khoản',
                            style: AppStyle.bodyBsRegular.copyWith(
                              color: AppColors.text_secondary,
                            ),
                          ).expanded(),
                          InkWell(
                            onTap: () => context
                                .pushRoute(
                              OtpResetPassRoute(
                                phone: _myBloc.state.username,
                              ),
                            )
                                .then((value) {
                              if (value != null && value is String) {
                                print('value: $value');
                                _phoneCtl.text = value;
                                _myBloc.fieldChange(username: value);
                              }
                            }),
                            child: SizedBox(
                              child: Text(
                                'Quên mật khẩu?',
                                style: AppStyle.bodyBsMedium.copyWith(
                                  color: AppColors
                                      .button_neutral_ghost_textDefault,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      gapHeight(sp16),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: MainButton(
                              title: 'Đăng nhập',
                              event: _loginEvent,
                              radius: 999,
                            ),
                          ),
                        ],
                      ).padding(12.padingVer),
                      !haveAcc()
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Bạn chưa có tài khoản?',
                                  style: AppStyle.bodyBsRegular.copyWith(
                                    color: AppColors.text_tertiary,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    context.router
                                        .push(
                                      RegisterRoute(
                                        accountType: AccountTypeEnum.admin,
                                        phone: _phoneCtl.text,
                                      ),
                                    )
                                        .then((value) {
                                      if (value != null && value is String) {
                                        _phoneCtl.text = value;
                                        _myBloc.fieldChange(username: value);
                                      }
                                    });
                                  },
                                  child: Text(
                                    ' Đăng ký ngay',
                                    style: AppStyle.bodyBsMedium.copyWith(
                                      color: AppColors
                                          .button_brand_ghost_textDefault,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    const Divider().expanded(),
                                    Text(
                                      'Hoặc',
                                      style: AppStyle.bodyBsRegular.copyWith(
                                        color: AppColors.text_quaternary,
                                      ),
                                    ),
                                    const Divider().expanded(),
                                  ],
                                ),
                                12.height,
                                ExtraButton(
                                  title: 'Đăng nhập với tài khoản khác',
                                  borderRadius: 999,
                                  borderColor: AppColors
                                      .button_neutral_outlined_borderDefault,
                                  event: () {
                                    //_shared.clear();
                                    _phoneCtl.clear();
                                    _passwordCtl.clear();
                                    _myBloc.rememberPasswordHandle(false);
                                    setState(() {
                                      _fullName = null;
                                      _username = null;
                                    });
                                  },
                                ).size(width: double.infinity),
                              ],
                            ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
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
        context.read<UserBloc>().getData();
        context.router.replaceAll(
          //[const WorkSpaceRoute()],
          [const ListWorkspaceRoute()],
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: value.message ?? 'Sai tên tài khoản hoặc mật khẩu',
        );
      }
    });
  }

  Widget headerHaveAcc() {
    return Column(
      children: [
        Text(
          'Chào mừng bạn',
          style: AppStyle.headingDisplay,
        ),
        gapHeight(sp6),
        Text(
          'Vui lòng đăng nhập để sử dụng dịch vụ',
          textAlign: TextAlign.center,
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
      ],
    );
  }

  Widget headerNoAcc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào!',
          style: AppStyle.bodyMdMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        gapHeight(sp16),
        Text(
          _username!,
          style: AppStyle.headingDisplay,
        ),
      ],
    );
  }

  bool haveAcc() {
    return _username != null && _fullName != null;
  }
}
