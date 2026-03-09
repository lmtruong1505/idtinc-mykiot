import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/v2/base_scafford.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/authentication/cubit/reset_password_cubit/reset_password_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../presentation/base/button.dart';
import '../../../../presentation/base/text_field.dart';
import '../../../../presentation/constants/colors.dart';
import '../../../../presentation/constants/spacing.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/typography.dart';
import '../../../shared/constants/enums/type_account_enum.dart';
import '../../../shared/utils/event.dart';
import '../cubit/register_cubit/register_cubit.dart';
import '../cubit/register_cubit/register_state.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.accountType,
    required this.phone,
  });

  final AccountTypeEnum accountType;
  final String phone;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final keyForm = GlobalKey<FormState>();
  final myBloc = getIt.get<RegisterCubit>();

  final shadow = <BoxShadow>[];
  late TextEditingController _phoneController;
  @override
  void initState() {
    _phoneController = TextEditingController(text: widget.phone);
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => myBloc
        ..accountTypeChange(
          widget.accountType,
        )
        ..formRegisterChange(phone: widget.phone),
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              // keyForm.currentState?.reset();
              FocusScope.of(context).unfocus();
            },
            child: BaseScaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: keyForm,
                  child: Padding(
                    padding: const EdgeInsets.all(sp24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: sp48),
                        Image.asset(
                          '${AssetsPath.image}/pharmago_v2.png',
                          width: sp64,
                        ),
                        const SizedBox(height: sp16),
                        Text(
                          'Đăng ký',
                          style: h2.copyWith(color: blackColor),
                        ),
                        const SizedBox(height: sp24),
                        AppInputSupport(
                          hintText: 'Nhập họ và tên',
                          label: 'Họ và tên',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          onChanged: (value) =>
                              myBloc.formRegisterChange(fullName: value),
                          required: true,
                          boxShadow: shadow,
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập họ tên';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: sp8),
                        AppInputSupport(
                          hintText: 'Nhập số điện thoại',
                          label: 'Số điện thoại',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          required: true,
                          controller: _phoneController,
                          textInputType: TextInputType.phone,
                          onChanged: (value) =>
                              myBloc.formRegisterChange(phone: value),
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập số điện thoại';
                            } else if (!isPhoneNumberValid(value ?? '')) {
                              return 'Sai định dạng số điện thoại.';
                            }
                            return null;
                          },
                          suffixIcon: SizedBox(
                            height: sp54,
                            width: sp54,
                            child: state.isCheckingPhone
                                ? const Center(child: BaseLoading())
                                : const SizedBox(),
                          ),
                          boxShadow: shadow,
                        ),
                        Visibility(
                          visible: state.statusCheck == TypeChecking.success,
                          child: Container(
                            margin: const EdgeInsets.all(sp12)
                                .copyWith(bottom: sp0),
                            child: Text(
                              'Số điện thoại đã tồn tại',
                              style: p7.copyWith(color: red_1),
                            ),
                          ),
                        ),
                        const SizedBox(height: sp8),
                        AppInputSupport(
                          hintText: 'Nhập mã giới thiệu',
                          label: 'Mã giới thiệu',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          //required: true,
                          textInputType: TextInputType.emailAddress,
                          onChanged: (value) =>
                              myBloc.formRegisterChange(code: value),

                          suffixIcon: SizedBox(
                            height: sp54,
                            width: sp54,
                            child: state.isCheckingEmail
                                ? const Center(child: BaseLoading())
                                : const SizedBox(),
                          ),
                          boxShadow: shadow,
                        ),
                        Visibility(
                          visible:
                              state.statusCheckEmail == TypeChecking.success,
                          child: Container(
                            margin: const EdgeInsets.all(sp12)
                                .copyWith(bottom: sp0),
                            child: Text(
                              'Email đã tồn tại',
                              style: p7.copyWith(color: red_1),
                            ),
                          ),
                        ),
                        const SizedBox(height: sp8),
                        AppInputSupport(
                          label: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          show: state.showPassword,
                          maxLines: 1,
                          required: true,
                          onChanged: (value) =>
                              myBloc.formRegisterChange(password: value),
                          suffixIcon: InkWell(
                            onTap: myBloc.showPassword,
                            child: Icon(
                              state.showPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: borderColor_4,
                            ),
                          ),
                          boxShadow: shadow,
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (!value.validatePassword) {
                              return 'Mật khẩu không đúng định dạng';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: sp8),
                        AppInputSupport(
                          hintText: 'Nhập xác nhận mật khẩu',
                          label: 'Xác nhận mật khẩu',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          required: true,
                          maxLines: 1,
                          show: state.showConfirmPassword,
                          onChanged: (value) => myBloc.formRegisterChange(
                            confirmPassword: value,
                          ),
                          suffixIcon: InkWell(
                            onTap: myBloc.showConfirmPassword,
                            child: Icon(
                              state.showConfirmPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: borderColor_4,
                            ),
                          ),
                          boxShadow: shadow,
                          validate: (value) {
                            if (state.password != value) {
                              return 'Vui lòng nhập giống với mật khẩu';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: sp8),
                        AppInputSupport(
                          hintText: 'Nhập email',
                          label: 'Email',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          //required: true,
                          textInputType: TextInputType.emailAddress,
                          onChanged: (value) =>
                              myBloc.formRegisterChange(email: value),

                          suffixIcon: SizedBox(
                            height: sp54,
                            width: sp54,
                            child: state.isCheckingEmail
                                ? const Center(child: BaseLoading())
                                : const SizedBox(),
                          ),
                          boxShadow: shadow,
                        ),
                        const SizedBox(height: sp24),
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            title: 'Tiếp tục',
                            event: () {
                              _singUpHandle(context);
                            },
                          ),
                        ),
                        // const SizedBox(height: sp24),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: Text(
                        //     'Hoặc tiếp tục với',
                        //     style: p6.copyWith(color: greyColor),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        const SizedBox(height: sp8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Đã có tài khoản?',
                              style: p6.copyWith(color: greyColor),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Đăng nhập ngay',
                                style: p5.copyWith(color: mainColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _singUpHandle(BuildContext context) async {
    final validate = keyForm.currentState?.validate();
    if (validate == false ||
        myBloc.state.statusCheck == TypeChecking.success ||
        myBloc.state.statusCheckEmail == TypeChecking.success) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang đăng ký vui lòng đợi!');
    myBloc.register().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        context.router
            .push(
          VerifyAccountV2Route(
            name: myBloc.state.fullName,
            idVerify: value.extra,
            phone: myBloc.state.phone,
          ),
        )
            .then((value) {
          if (value != null) {
            print('value: $value');
            context.router.maybePop(_phoneController.text);
          }
        });
        return;
      } else if (value.code == 40001) {
        DialogUtils.showErrorDialog(
          context,
          content: value.message ?? 'Đăng ký thất bại',
          titleClose: 'Trở về',
          titleConfirm: 'Đăng nhập ngay',
          close: () => Navigator.of(context).pop(),
          accept: () {
            context.pop();
            context.router.maybePop(_phoneController.text);
          },
        );
        return;
      } else {
        DialogUtils.showErrorDialog(context,
            content:
                'Đăng ký thất bại, vui lòng thử lại sau (code: ${value.code})',
            titleClose: '');
      }
    });
  }
}
