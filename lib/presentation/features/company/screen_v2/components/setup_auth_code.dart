import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../constants/spacing.dart';
import '../../../authentication/widgets/pin_code_view.dart';
import '../../cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import '../../domain/entities/auth_ws_entity.dart';

class SetupAuthCode extends StatelessWidget {
  const SetupAuthCode({
    super.key,
    required this.id,
    required this.authWscubit,
  });

  final int id;
  final AuthWsManagerCubit authWscubit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthWsManagerCubit, AuthWsManagerState, AuthWsEntity?>(
      bloc: authWscubit,
      selector: (state) {
        return state.authWs;
      },
      builder: (context, authWs) {
        if (authWs == null) {
          return _emptyView(context);
        }
        return _view(context, authWs);
      },
    );
  }

  Widget _view(BuildContext context, AuthWsEntity authWs) {
    final isExpired = authWs.status != 'Còn hạn';
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(sp16),
        padding: const EdgeInsets.symmetric(
          vertical: sp12,
          horizontal: sp16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp12),
          border: Border.all(color: AppColors.border_secondary),
          color: isExpired ? AppColors.bg_secondary : AppColors.bg_white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                FaIcon(
                  iconCode: 'f013',
                  color: AppColors.brand,
                ),
                sp8.width,
                Text(
                  'Mã xác thực',
                  style: s18w500.copyWith(
                    color: AppColors.text_black,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _updateHandle(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: sp4,
                      horizontal: sp8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      border: Border.all(color: AppColors.border_primary),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          iconCode: 'f013',
                          size: sp12,
                        ),
                        sp4.width,
                        Text(
                          'Thiết lập',
                          style: s14w400.copyWith(
                            color: AppColors.text_black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            sp12.height,
            RowItem(
              title: 'Mã xác thực',
              content: authWs.decryptedPassword ?? '',
            ),
            sp4.height,
            RowItem(
              title: 'Tạo từ',
              content: authWs.createdAt.fomatCustom(),
            ),
            sp4.height,
            RowItem(
              title: 'Hiệu lực đến',
              content: authWs.endDate.fomatCustom(),
            ),
            Visibility(visible: !isExpired, child: sp4.height),
            Visibility(
              visible: !isExpired,
              child: RowItem(
                title: '',
                content:
                    'Còn ${authWs.endDate!.difference(authWs.createdAt!).inDays} ngày',
                contetnStyle: s14w400.copyWith(
                  color: AppColors.text_disable,
                ),
              ),
            ),
            sp4.height,
            RowItem(
              title: 'Trạng thái',
              content: authWs.status ?? '',
              contetnStyle: s14w500.copyWith(
                color: !isExpired ? AppColors.brand : AppColors.red60,
              ),
            ),
            Visibility(
              visible: isExpired,
              child: Row(
                children: [
                  Image.asset(
                    '${AssetsPath.image}/warning.png',
                  ),
                  sp4.width,
                  Text(
                    'Vui lòng thiết lập lại',
                    style: s12w500.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(sp16),
        padding: const EdgeInsets.symmetric(
          vertical: sp12,
          horizontal: sp16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp12),
          border: Border.all(color: AppColors.border_secondary),
          color: AppColors.bg_white,
        ),
        child: Row(
          children: [
            FaIcon(
              iconCode: 'f013',
            ),
            sp8.width,
            Text(
              'Mã xác thực',
              style: s18w500.copyWith(
                color: AppColors.text_black,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => _setupHandle(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp4,
                  horizontal: sp8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  border: Border.all(color: AppColors.border_primary),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      iconCode: 'f013',
                      size: sp12,
                    ),
                    sp4.width,
                    Text(
                      'Thiết lập',
                      style: s14w400.copyWith(
                        color: AppColors.text_black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setupHandle(BuildContext context) {
    AuthWsInputDialog.show(
      context,
      callBack: (value) async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          'Đang thiết lập mã xác thực',
        );
        final res = await authWscubit.createAuthWs(id, value);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        if (res != null) {
          DialogUtils.showSuccessDialog(
            context,
            content: 'Thiết lập mã xác thực thành công',
            barrierDismissible: true,
          );
        } else {
          DialogUtils.showSuccessDialog(
            context,
            content: 'Thiết lập mã xác thực thất bại',
            barrierDismissible: true,
          );
        }
      },
    );
  }

  void _updateHandle(BuildContext context) {
    AuthWsInputDialog.show(
      context,
      callBack: (value) async {
        DialogUtils.showLoadingDialog(
          context,
          'Đang cập nhật mã xác thực',
        );
        final res = await authWscubit.updateAuthWs(id, value);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        if (res != null) {
          DialogUtils.showSuccessDialog(
            context,
            content: 'Cập nhật mã xác thực thành công',
            barrierDismissible: true,
          );
        } else {
          DialogUtils.showSuccessDialog(
            context,
            content: 'Cập nhật mã xác thực thất bại',
            barrierDismissible: true,
          );
        }
      },
    );
  }
}

class AuthWsInputDialog extends StatelessWidget {
  const AuthWsInputDialog({
    super.key,
    this.callBack,
    this.title,
  });

  final Function(String)? callBack;
  final String? title;

  static Future<void> show(
    BuildContext context, {
    Function(String)? callBack,
    String? title,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(sp16).copyWith(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(sp24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(sp16),
                child: AuthWsInputDialog(
                  callBack: callBack,
                  title: title,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              radius: sp12,
              backgroundColor: black5o,
              child: FaIcon(
                iconCode: 'f00d',
              ),
            ),
          ),
        ),
        Image.asset(
          '${AssetsPath.image}/setting.png',
        ),
        Text(
          title ?? 'Thiết lập mã xác thực',
          style: s20w700,
          textAlign: TextAlign.center,
        ),
        sp16.height,
        PinCodeView(
          onCompleted: (value) {
            callBack?.call(value);
          },
        ),
        // sp16.height,
        // Row(
        //   children: [
        //     MainButton(
        //       title: 'Thiết lập',
        //     ).expanded(),
        //   ],
        // ),
      ],
    );
  }
}
