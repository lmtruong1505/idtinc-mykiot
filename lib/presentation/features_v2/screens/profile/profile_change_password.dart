import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/profile/components/noti_card.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/double_button.dart';
import '../../../../shared/utils/delay_callback.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/profile_bloc/profile_change_pass_bloc.dart';

@RoutePage()
class ProfileChangePasswordPage extends StatefulWidget {
  const ProfileChangePasswordPage({super.key});

  @override
  State<ProfileChangePasswordPage> createState() =>
      _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePasswordPage> {
  final myBloc = ProfileChangePassBloc();
  final key = GlobalKey<FormState>();
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  OverlayEntry? _overlayEntry;
  final DelayCallBack delayCallBack = DelayCallBack(delay: 1500.milliseconds);

  void _showOverlay(BuildContext context, String message, Color color) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: context.padding.bottom,
        left: 16,
        right: 16,
        child: Material(
          elevation: 5.0,
          color: Colors.white,
          borderRadius: 12.radius,
          child: NotiCard(
            title: message,
            icon: Container(
              padding: 4.pading,
              decoration: BoxDecoration(
                border: Border.all( color: color.withOpacity(0.05), width: 1),
                borderRadius: 999.radius,
              ),
              child: Container(
                padding: 4.pading,
                decoration: BoxDecoration(
                 border: Border.all( color: color.withOpacity(0.1), width: 2),
                  borderRadius: 999.radius,
                ),
                child: Icon(
                  Icons.key_outlined,
                  color: color,
                ),
              ),
            ),
            close: () {
              _removeOverlay();
            },
          ),
        ),
      ),
    );

    // Insert the overlay entry into the Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    myBloc.close();
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Thông tin cá nhân'),
      body: Form(
        key: key,
        child: Container(
          padding: 16.pading,
          child: BlocBuilder<ProfileChangePassBloc, CubitState>(
            bloc: myBloc,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IcSvg.asset('/key_v2.svg').container(
                      bgColor: AppColors.bg_brandPrimary_variant1,
                      radius: 999,
                    ),
                    16.height,
                    Text(
                      'Thay đổi mật khẩu cá nhân',
                      style: AppStyle.heading2xl,
                    ),
                    28.height,
                    AppInputSupport(
                      hintText: 'Nhập mật khẩu cũ',
                      label: 'Mật khẩu cũ',
                      required: true,
                      show: myBloc.showOldPass,
                      maxLines: 1,
                      controller: oldPassCtrl,
                      suffixIcon: InkWell(
                        onTap: myBloc.toggleOldPass,
                        child: Icon(
                          myBloc.showOldPass
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập mật khẩu cũ';
                        }
                        return null;
                      },
                    ),
                    4.height,
                    const Divider(),
                    AppInputSupport(
                      hintText: 'Nhập mật khẩu mới',
                      label: 'Mật khẩu mới',
                      required: true,
                      controller: newPassCtrl,
                      show: myBloc.showNewPass,
                      maxLines: 1,
                      suffixIcon: InkWell(
                        onTap: myBloc.toggleNewPass,
                        child: Icon(
                          myBloc.showNewPass
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }
                        if(!value.validatePassword) {
                          return 'Mật khẩu không đúng định dạng';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    AppInputSupport(
                      hintText: 'Nhập lại mật khẩu',
                      label: 'Xác nhận mật khẩu mới',
                      required: true,
                      show: myBloc.showConfirmPass,
                      maxLines: 1,
                      controller: confirmPassCtrl,
                      suffixIcon: InkWell(
                        onTap: myBloc.toggleConfirmPass,
                        child: Icon(
                          myBloc.showConfirmPass
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }
                        if (value != newPassCtrl.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    _buildNote(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  _buildNote() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 8.radius,
        color: AppColors.bg_secondary,
      ),
      padding: 12.pading,
      width: context.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Ghi chú:',
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          8.height,
          // _buildNoteItem(
          //   prefix: const Icon(
          //     Icons.tag,
          //     size: 16,
          //     color: AppColors.description_textDefault,
          //   ),
          //   content: '6 đến 12 ký tự',
          // ),
          // 2.height,
          _buildNoteItem(
            prefix: const Icon(
              Icons.emoji_symbols_sharp,
              size: 16,
              color: AppColors.description_textDefault,
            ),
            content: 'Có thể gồm: chữ, số và các ký tự đặc biệt (!, @, #, \$, %, ^, &, *,(, ), -,+, _,)',
          ),
          // 2.height,
          // _buildNoteItem(
          //   prefix: const Icon(
          //     Icons.font_download_outlined,
          //     size: 16,
          //     color: AppColors.description_textDefault,
          //   ),
          //   content: 'Tối thiểu 1 ký tự in HOA',
          // ),
        ],
      ),
    );
  }

  _buildNoteItem({
    required Widget prefix,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        prefix,
        8.width,
        Text(
          content,
          style: AppStyle.bodySmRegular.copyWith(
            color: AppColors.description_textDefault,
          ),
        ).expanded(),
      ],
    );
  }

  _buildBottom() {
    return Container(
      padding: 16.padingHor + 12.padingTop + 32.padingBottom,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.grey40,
          ),
        ),
      ),
      child: DoubleButton(
        onConfirm: _handleChangePass,
        onCancel: () {
          context.pop();
        },
      ),
    );
  }

  _handleChangePass() {
    if (!key.currentState!.validate()) return;
    DialogUtils.showLoadingDialog(context, 'Đang thay đổi mật khẩu...');
    myBloc
        .changePass(
      oldPass: oldPassCtrl.text,
      newPass: newPassCtrl.text,
    )
        .then((value) {
      delayCallBack.debounce(() {
        _removeOverlay();
      });
      context.pop();
      if (value.code == 200) {
        _showOverlay(context, 'Thành công', AppColors.fg_positive);
        context.pop();
      } else {
        _showOverlay(context, value.message ?? 'Lỗi không xác định',
            AppColors.fg_negative);
      }
    });
  }
}
