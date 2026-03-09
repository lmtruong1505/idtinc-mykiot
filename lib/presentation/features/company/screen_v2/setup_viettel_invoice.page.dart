import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/double_button.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../../shared/components/widgets/icon_custom.dart';
import '../../../../shared/style_app/color_app.dart';
import '../../../base/app_bar.dart';
import '../../../base/base_buttom_bar.dart';
import '../../../base/text_field.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../cubit/e_invoice_cubit/e_invoice_cubit.dart';
import '../cubit/e_invoice_cubit/e_invoice_state.dart';

@RoutePage()
class SetupViettelInvoicePage extends StatefulWidget {
  const SetupViettelInvoicePage({
    super.key,
    required this.workspaceId,
  });

  final int workspaceId;

  @override
  State<SetupViettelInvoicePage> createState() =>
      _SetupViettelInvoicePageState();
}

class _SetupViettelInvoicePageState extends State<SetupViettelInvoicePage> {
  final _key = GlobalKey<FormState>();
  final _eInvoiceCubit = getIt.get<EInvoiceCubit>();
  late TextEditingController _usernameCtrl;
  late TextEditingController _passwordCtrl;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EInvoiceCubit>(
      create: (context) => _eInvoiceCubit,
      child: BlocListener<EInvoiceCubit, EInvoiceState>(
        listener: (context, state) {
          if (state.status == null) return;
          if (state.status == 200) {
            DialogUtils.showSuccessDialog(
              context,
              content: 'Kết nối với tài khoản Viettel thành công',
              barrierDismissible: true,
            ).then((_) {
              Navigator.of(context).pop<bool>(true);
            });
          }
        },
        child: Scaffold(
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
                    'VIETTEL\nThiết lập Hóa đơn điện tử',
                    style: s24w700,
                  ),
                  24.height,
                  AppInputSupport(
                    controller: _usernameCtrl,
                    label: 'Tài khoản',
                    hintText: 'Nhập tài khoản',
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
                  AppInputSupport(
                    controller: _passwordCtrl,
                    label: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    backgroundColor: ColorApp.white,
                    borderColor: ColorApp.greyA7,
                    maxLines: 1,
                    required: true,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  BlocBuilder<EInvoiceCubit, EInvoiceState>(
                    builder: (context, state) {
                      if (state.errMsg == null ||
                          state.status == 200 ||
                          state.status == null) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        'Thông tin kết nối với Hóa đơn điện tử Viettel không hợp lệ. Vui lòng kiểm tra và nhập lại!',
                        style: s14w400.copyWith(color: AppColors.red60),
                      );
                    },
                  ),
                ],
              ).padding(16.pading),
            ),
          ),
          bottomNavigationBar: BaseBottomBar(
            child: Row(
              children: [
                DoubleButton(
                  confirmText: 'Kết nối',
                  onConfirm: _connectHandle,
                ).expanded(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _connectHandle() async {
    final validate = _key.currentState?.validate() ?? false;
    if (!validate) return;

    DialogUtils.showLoadingDialog(
      context,
      'Đang kết nối đến hệ thống của Viettel',
    );

    _eInvoiceCubit
        .createViettelAccountHandle(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
      workspaceId: widget.workspaceId,
    )
        .then((_) {
      Navigator.of(context).pop();
    });
  }
}
