import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/features/account/domain/usecase/account_use_case.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import 'account_state.dart';

@injectable
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._useCase) : super(AccountState());

  final AccountUseCase _useCase;

  Future<void> getDetail() async {
    final account = await _useCase.getDetail();
    emit(state.copyWith(account: account));
  }

  Future<void> inactive(BuildContext context) async {
    DialogUtils.showErrorDialog(
      context,
      content:
          'Bạn có chắc chắn vô hiệu hóa tài khoản?\nThao tác này không thể hoàn tác.',
      titleClose: 'Huỷ',
      titleConfirm: 'Xác nhận',
      close: () => Navigator.of(context).pop(),
      accept: () async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          'Đang vô hiệu hóa tài khoản vui lòng đợi!',
        );
        final res = await _useCase.inactive();
        Navigator.of(context).pop();
        if (res.code == 200) {
          await DialogUtils.showSuccessDialog(context,
              content: 'Vô hiệu hóa tài khoản thành công', barrierDismissible: true);
          context.router.replaceAll([const LoginRoute()]);
        } else {
          await DialogUtils.showErrorDialog(context,
              content: 'Vô hiệu hóa tài khoản thất bại');
        }
      },
    );
  }
}
