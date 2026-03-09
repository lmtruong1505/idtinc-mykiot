import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/auth/auth_repository.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/ext_context.dart';

class AuthCubit extends Cubit<CubitState> {
  AuthCubit() : super(CubitState());
  final _repo = AuthRepositoryV2();

  void deleteAccount(BuildContext context) async {
    DialogUtils.showLoadingDialog(context, 'Đang xoá tài khoản');

    final id = getCompanyId;
    try {
      final res = await _repo.deleteAccount(id);
      context.pop();
      if (res.code == 200) {
        emit(state.copyWith(status: BlocStatus.success, msg: null));

        final shared = AppSharedPreference.instance;

        shared
          ..remove(PrefKeys.token)
          ..remove(PrefKeys.tokenRefresh)
          ..remove(PrefKeys.rememberPassword)
          ..remove(PrefKeys.userFullName)
          ..remove(PrefKeys.userCode)
          ..remove(PrefKeys.user)
          ..remove(PrefKeys.password)
          ..remove(PrefKeys.username);
        context.router.replaceAll([const LoginRoute()]);
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failure,
            msg: res.message ?? 'Xoá tài khoản thất bại',
          ),
        );
      }
    } catch (e) {
      context.pop();
      DialogUtils.showErrorDialog(context,
          content: 'Xoá tài khoản thất bại, ${e.toString()}');
    }
  }
}
