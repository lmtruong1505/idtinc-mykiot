import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../localization/app_localizations.dart';
import '../../presentation/config/app_style/init_app_style.dart';
import '../components/dialog/dialog_message.dart';

extension extContext on BuildContext {
  Size get sizeOf => MediaQuery.of(this).size;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  EdgeInsets get padding => MediaQuery.of(this).padding.copyWith(
        bottom: Platform.isIOS ? null : 16,
      );

  permissionError() {
    this.dialog(
      const DialogMessage(
        title: 'Cảnh báo',
        content: 'Bạn không có quyền truy cập',
        icon: IconDiaLog(
          color: AppColors.ultility_carrot_10,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.ultility_carrot_60,
          ),
        ),
      ),
    );
  }

  void requestFocus({FocusNode? focus}) {
    FocusScope.of(this).requestFocus(focus);
  }

  void unFocus({FocusNode? focus}) {
    if (focus != null) {
      focus.unfocus();
    } else {
      FocusScope.of(this).unfocus();
    }
  }

  Future push(
    Widget page, {
    bool isNewTask = false,
    bool login = false,
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  }) async {
    //Widget child = login ? ScreenLogin() : page;
    final Widget child = page;
    if (isNewTask) {
      return await Navigator.of(this).pushAndRemoveUntil(
        _router(
          child,
          duration: duration,
          pageRouteAnimation: pageRouteAnimation,
        ),
        (route) => false,
      );
    } else {
      return await Navigator.of(this).push(
        _router(
          child,
          duration: duration,
          pageRouteAnimation: pageRouteAnimation,
        ),
      );
    }
  }

  Future bottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) async {
    return showModalBottomSheet(
      context: this,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: child,
      ),
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,

      //shape: RoundedRectangleBorder(borderRadius: 20.radiusTop),
    );
  }

  Future dialog(
    Widget child, {
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async {
    return await showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
      barrierColor: barrierColor,
    );
  }

  dynamic Function() permissionDenied() {
    return () async {
      await showDialog(
        context: this,
        builder: (context) => const DialogMessage(
          title: 'Cảnh báo',
          content: 'Bạn không có quyền thực hiện chức năng này',
          icon: IconDiaLog(
            color: AppColors.ultility_carrot_10,
            icon: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.ultility_carrot_60,
            ),
          ),
        ),
      );
    };
  }

  void pop({dynamic result}) async {
    Navigator.pop(this, result);
  }

  PageRoute _router(
    Widget child, {
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  }) {
    if (pageRouteAnimation != null) {
      if (pageRouteAnimation == PageRouteAnimation.Fade) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return RotationTransition(
              turns: ReverseAnimation(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return ScaleTransition(scale: anim, child: child);
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      }
    }
    return MaterialPageRoute(builder: (_) => child);
  }

//login ? const ScreenLogin() : page
}

extension LocalizationsExt on BuildContext {
  AppLocalizations get appLocalized =>
      AppLocalizations.of(this) ??
      lookupAppLocalizations(const Locale('vi'));
}

enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }
