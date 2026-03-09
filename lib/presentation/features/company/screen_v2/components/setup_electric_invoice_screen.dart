import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/generated/assets.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/features/company/cubit/electric_invoice_bloc.dart';
import 'package:pharmago/presentation/features/company/data/models/electric_invoice_user_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/color_app.dart';

@RoutePage()
class SetupElectricInvoiceScreen extends StatefulWidget {
  const SetupElectricInvoiceScreen({
    super.key,
    required this.user,
  });

  @override
  State<SetupElectricInvoiceScreen> createState() =>
      _SetupElectricInvoiceScreenState();
  final ElectricInvoiceUserModel? user;
}

class _SetupElectricInvoiceScreenState
    extends State<SetupElectricInvoiceScreen> {
  final bloc = ElectricInvoiceBloc();
  final _key = GlobalKey<FormState>();

  late TextEditingController adminAccountCtrl;
  late TextEditingController adminPasswordCtrl;
  late TextEditingController serviceAccountCtrl;
  late TextEditingController servicePasswordCtrl;
  late TextEditingController linkCtrl;

  @override
  void initState() {
    super.initState();
    adminAccountCtrl =
        TextEditingController(text: widget.user?.data?.userAdmin);
    adminPasswordCtrl =
        TextEditingController(text: widget.user?.data?.passAdmin);
    serviceAccountCtrl =
        TextEditingController(text: widget.user?.data?.userService);
    servicePasswordCtrl =
        TextEditingController(text: widget.user?.data?.passService);
    linkCtrl = TextEditingController(text: widget.user?.data?.loginLink);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<ElectricInvoiceBloc, CubitState>(
        listener: (context, state) {
          if (state.status == BlocStatus.success) {
            final user = bloc.userResponse;
            DialogUtils.showInforDialog(
              barrierDismissible: true,
              context,
              data: BaseContainer(
                padding: 8.pading,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.notiIconNotiSuccess,
                          width: 18,
                          height: 18,
                        ),
                        4.width,
                        const Text(
                          'VNPT',
                          style: s18w500,
                        ),
                      ],
                    ),
                    8.height,
                    TextRow2(
                      title: 'Đơn vị cấp',
                      content: user?.ownCA ?? '',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleStyle: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                      contentStyle: s14w500,
                    ),
                    8.height,
                    TextRow2(
                      title: 'Tên chủ sở hữu',
                      content: user?.organizationCA ?? '',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleStyle: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                      contentStyle: s14w500,
                    ),
                    8.height,
                    TextRow2(
                      title: 'Serial chứng thư',
                      content: user?.serialNumber ?? '',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleStyle: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                      contentStyle: s14w500,
                    ),
                    8.height,
                    TextRow2(
                      title: 'Hiệu lực từ',
                      content: user?.validFrom ?? '',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleStyle: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                      contentStyle: s14w500,
                    ),
                    8.height,
                    TextRow2(
                      title: 'Hiệu lực đến',
                      content: user?.validTo ?? '',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleStyle: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                      contentStyle: s14w500,
                    ),
                  ],
                ),
              ),
              titleClose: 'Nhập lại',
              titleConfirm: 'Kết nối',
              close: () {
                context.router.pop();
                onClear();
              },
              accept: () {
                Navigator.pop(context);
                onConnect(context);
              },
            );
          } else if (state.status == BlocStatus.submitSuccess) {
            DialogUtils.showSuccessDialog(
              barrierDismissible: true,
              context,
              content: 'Kết nối thành công',
              titleClose: 'Nhập lại',
              titleConfirm: 'Kết nối',
              accept: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          } else if (state.status == BlocStatus.failure) {
            DialogUtils.showErrorDialog(
              context,
              content:
                  'Thông tin kết nối với Hóa đơn điện tử VNPT không hợp lệ. Vui lòng kiểm tra và nhập lại!',
              titleClose: 'Xác nhận',
              close: () => Navigator.pop(context),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const BaseAppBar(
              centerTitle: false,
              title: 'Trở về',
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconCustom(
                      icon: FaIcon(
                        iconCode: 'f1b2',
                        type: FaIconType.solid,
                        color: AppColors.bg_primary,
                      ),
                      color: AppColors.ultility_positive_60,
                    ),
                    const Text(
                      'Thiết lập Hóa đơn điện tử',
                      style: s24w700,
                    ),
                    24.height,
                    AppInputSupport(
                      controller: linkCtrl,
                      label: 'Link đăng nhập',
                      hintText: 'Nhập link đăng nhập',
                      backgroundColor: ColorApp.white,
                      borderColor: ColorApp.greyA7,
                      maxLines: 1,
                      required: true,
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập link đăng nhập';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    Row(
                      children: [
                        AppInputSupport(
                          label: 'Tài khoản admin',
                          hintText: 'Nhập tài khoản',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          maxLines: 1,
                          required: true,
                          controller: adminAccountCtrl,
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập tài khoản admin';
                            }
                            return null;
                          },
                        ).expanded(),
                        8.width,
                        AppInputSupport(
                          label: 'Mật khẩu TK admin',
                          hintText: 'Nhập mật khẩu',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          show: bloc.showPasswordAdmin,
                          maxLines: 1,
                          required: true,
                          controller: adminPasswordCtrl,
                          suffixIcon: InkWell(
                            onTap: bloc.showHidePasswordAdmin,
                            child: Icon(
                              bloc.showPasswordAdmin
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: borderColor_4,
                            ),
                          ),
                          onConfirm: (value) {},
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập mật khẩu admin';
                            }
                            return null;
                          },
                        ).expanded(),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        AppInputSupport(
                          label: 'Tài khoản service',
                          hintText: 'Nhập tài khoản',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          maxLines: 1,
                          required: true,
                          controller: serviceAccountCtrl,
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập tài khoản service';
                            }
                            return null;
                          },
                        ).expanded(),
                        8.width,
                        AppInputSupport(
                          label: 'Mật khẩu TK service',
                          hintText: 'Nhập mật khẩu',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          show: bloc.showPasswordServer,
                          maxLines: 1,
                          required: true,
                          controller: servicePasswordCtrl,
                          suffixIcon: InkWell(
                            onTap: bloc.showHidePasswordServer,
                            child: Icon(
                              bloc.showPasswordServer
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: borderColor_4,
                            ),
                          ),
                          onConfirm: (value) {},
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập mật khẩu service';
                            }
                            return null;
                          },
                        ).expanded(),
                      ],
                    ),
                    // 16.height,
                    // Visibility(
                    //   visible: !state.msg.isEmptyOrNull,
                    //   child: Text(
                    //     'Thông tin kết nối với Hóa đơn điện tử VNPT không hợp lệ. Vui lòng kiểm tra và nhập lại!',
                    //     style: s14w400.copyWith(color: AppColors.red60),
                    //   ),
                    // ),
                  ],
                ).padding(16.pading),
              ),
            ),
            bottomNavigationBar: BaseBottomBar(
              child: Row(
                children: [
                  DoubleButton(
                    confirmText: 'Kiểm tra',
                    onConfirm: () => onValid(context),
                  ).expanded(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void onValid(BuildContext context) {
    if (!_key.currentState!.validate()) return;
    bloc.validInfor(
      link: linkCtrl.text,
      passwordSer: servicePasswordCtrl.text,
      userSer: serviceAccountCtrl.text,
      context: context,
    );
  }

  void onConnect(BuildContext context) {
    bloc.onConnect(
      link: linkCtrl.text,
      passwordSer: servicePasswordCtrl.text,
      userSer: serviceAccountCtrl.text,
      adminUser: adminAccountCtrl.text,
      adminPassword: adminPasswordCtrl.text,
      context: context,
    );
  }

  void onClear() {
    linkCtrl.clear();
    servicePasswordCtrl.clear();
    serviceAccountCtrl.clear();
    adminAccountCtrl.clear();
    adminPasswordCtrl.clear();
    bloc.onClear();
  }
}
