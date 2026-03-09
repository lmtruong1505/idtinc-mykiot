import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import '../../../../shared/components/toast/toast_custom.dart';
import '../../../config/app_style/init_app_style.dart';
import '../enum/bloc_status.dart';
import 'cubit_state.dart';

class CheckStateBloc {
  static void show(
    BuildContext context,
    CubitState state, {
    Function()? success,
  }) {
    if (state.status == BlocStatus.loading) {
      DialogUtils.showLoadingDialog(
        context,
        'Đang tải...',
      );
    }
    if (state.status == BlocStatus.success) {
      Navigator.pop(context);
      success?.call();
    }
    if (state.status == BlocStatus.failure) {
      Navigator.pop(context);
      DialogUtils.showErrorDialog(
        context,
        content: state.msg,
      );
    }
  }

  static void check(
    BuildContext context,
    CubitState state, {
    String? msg,
    bool isShowMsg = true,
    bool isClose = false,
    String? successBtnText,
    Function()? success,
    Function()? failure,
    String? svgIconSuccess,
    PageRouteInfo? route,
    bool isRemove = false,
  }) {
    if (state.status == BlocStatus.loading) {
      DialogUtils.showLoadingDialog(
        context,
        'Đang tải...',
      );
    }
    if (state.status == BlocStatus.success) {
      Navigator.pop(context);

      if (isShowMsg) {
        ToastCustom.show(
          context,
          title: 'Thành công',
          msg: msg ?? state.msg,
          svgIcon: isRemove
              ? Assets.svgDelete
              : svgIconSuccess ?? Assets.iconsSuccess,
          color: isRemove
              ? AppColors.ultility_negative_60
              : AppColors.ultility_brand_60,
          timeClose: 3.seconds,
          route: route,
        );

        if (success != null) {
          success();
        }
      } else {
        DialogUtils.showSuccessDialog(
          context,
          content: msg ?? state.msg,
          titleConfirm: successBtnText,
          isClose: isClose,
          accept: () {
            if (success != null) {
              success();
            } else {
              context.pop();
            }
          },
          close: () {
            context.pop();
            context.pop(result: true);
          },
        );
      }
    }
    if (state.status == BlocStatus.failure) {
      Navigator.pop(context);
      if (failure != null) {
        failure();
      } else {
        if (isShowMsg) {
          ToastCustom.show(
            context,
            title: 'Thất bại',
            msg: state.msg,
            svgIcon: Assets.svgClose,
            color: AppColors.ultility_negative_60,
            timeClose: 3.seconds,
          );

          return;
        }
        DialogUtils.showErrorDialog(
          context,
          content: state.msg,
        );
      }
    }
  }

  static checkNoLoad(
    BuildContext context,
    CubitState state, {
    String? msg,
    bool isShowMsg = true,
    Function()? success,
    Function()? failure,
  }) {
    if (state.status == BlocStatus.success) {
      isShowMsg
          ? showSnackBar(
              context,
              msg ?? state.msg,
            )
          : null;
      if (success != null) {
        success();
      }
    }
    if (state.status == BlocStatus.failure) {
      if (failure != null) {
        failure();
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: state.msg,
        );
      }
    }
  }

  static showSnackBar(BuildContext context, String msg, {Color? colorBg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: StyleApp.medium(color: ColorApp.white),
        ),
        backgroundColor: colorBg ?? ColorApp.main,
      ),
    );
  }
}
