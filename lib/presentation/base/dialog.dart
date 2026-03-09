import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/calendar.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/popup_noti.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../shared/constants/pref_key.dart';

// ignore: constant_identifier_names
enum StatusNoti { OK, Cancel, Error, SUCCESS, WARNING, ERROR, LOADING }

class DialogUtils {
  static Future<StatusNoti?> showDialogApp(
    BuildContext context,
    Widget dialog,
  ) async =>
      showDialog<StatusNoti>(
        context: context,
        barrierDismissible: true, // user not tap button for close dialog!
        builder: (BuildContext context) => dialog,
      );

  static Future<StatusNoti?> showDialogApp2(
    BuildContext context,
    Widget dialog,
  ) async =>
      showDialog<StatusNoti>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) => dialog,
      );

  static Future<void> showBottomDialog(
    BuildContext context,
    Widget dialog,
  ) async =>
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        isDismissible: true,
        builder: (BuildContext context) => dialog,
      );

  static Future<StatusNoti?> showBottomDialogText(
    BuildContext context,
    Widget dialog,
  ) async =>
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => dialog,
        backgroundColor: Colors.white,
      );

  static Future<StatusNoti?> showLoadingDialog(
    BuildContext context,
    String content, {
    String? title,
  }) {
    return showDialogApp2(
      context,
      Dialog(
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(sp16)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp16),
          ),
          width: widthDevice(context) - sp32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BaseLoading(),
              const SizedBox(height: sp24),
              Text(title ?? 'Thông báo', style: h3),
              const SizedBox(height: sp12),
              Text(
                content,
                style: p4.copyWith(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<StatusNoti?> showSuccessDialog(
    BuildContext context, {
    required String content,
    VoidCallback? accept,
    VoidCallback? close,
    String? titleConfirm,
    String? titleClose,
    bool? barrierDismissible = false,
    bool isClose = true,
  }) =>
      showDialog(
        barrierDismissible: barrierDismissible ?? true,
        context: context,
        builder: (context) {
          return BasePopupNoti(
            click: accept,
            close: close,
            content: content,
            status: StatusNoti.SUCCESS,
            titleConfirm: titleConfirm,
            titleClose: titleClose,
            isClose: isClose,
          );
        },
      );

  static Future<StatusNoti?> showDialogWithTitleAndOptionButton(
    BuildContext context,
    String content,
    VoidCallback okButton,
  ) =>
      showDialogApp(
        context,
        Dialog(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(sp16),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: sp24,
              horizontal: sp16,
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(sp16),
            ),
            width: widthDevice(context) - sp32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BaseLoading(),
                const SizedBox(height: sp24),
                const Text('Thông báo', style: h3),
                const SizedBox(height: 12),
                Text(content),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        okButton();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  static Future<StatusNoti?> showErrorDialog(
    BuildContext context, {
    required String content,
    VoidCallback? accept,
    VoidCallback? close,
    String? titleConfirm,
    String? titleClose,
    String? header,
    bool isClose = true,
    StatusNoti status = StatusNoti.ERROR,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return BasePopupNoti(
          click: accept,
          close: close,
          content: content,
          header: header,
          status: status,
          titleConfirm: titleConfirm,
          titleClose: titleClose,
          isClose: isClose,
        );
      },
    );
  }

  static Future<StatusNoti?> showWarningDialog(
    BuildContext context, {
    required String content,
    VoidCallback? accept,
    VoidCallback? close,
    String? titleConfirm,
    String? titleClose,
    String? header,
    StatusNoti status = StatusNoti.WARNING,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return BasePopupNoti(
          click: accept,
          close: close,
          content: content,
          header: header,
          status: status,
          titleConfirm: titleConfirm,
          titleClose: titleClose,
        );
      },
    );
  }

  static Future<void> showCalendarDialog(
    BuildContext context, {
    required List<DateTime?> selectedDate,
    Function(List<DateTime?>)? onConfirm,
    DateRangePickerSelectionMode selectionMode =
        DateRangePickerSelectionMode.range,
  }) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        reverseTransitionDuration: const Duration(milliseconds: 0),
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (_, __, ___) {
          return Material(
            elevation: 0,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Listener(
                    onPointerDown: (_) {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.black26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: sp12),
                  child: Material(
                    elevation: 1,
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp8),
                    child: Container(
                      padding: const EdgeInsets.all(sp12),
                      child: CalendarPicker(
                        selectionMode: selectionMode,
                        selectedDate: selectedDate,
                        onConfirm: (value) {
                          onConfirm?.call(value);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Future<List<DateTime?>?> showCalendarDatePicker(
    BuildContext context, {
    bool calendarDouble = false,
  }) async =>
      showCalendarDatePicker2Dialog(
        dialogBackgroundColor: whiteColor,
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: calendarDouble
              ? CalendarDatePicker2Type.range
              : CalendarDatePicker2Type.single,
          calendarViewMode: DatePickerMode.day,
          selectedDayHighlightColor: mainColor,
        ),
        dialogSize: Size(widthDevice(context) - sp32, 450),
      );

  static Future<void> showLogoutDialog({
    required BuildContext context,
    VoidCallback? confirm,
    VoidCallback? close,
    bool barrierDismissible = false,
  }) async {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return BasePopupNotiV2(
          title: 'Đăng xuất',
          content: 'Bạn có muốn đăng xuất khỏi hệ thống?',
          titleClose: 'Quay lại',
          titleConfirm: 'Xác nhận',
          leftIcon: GestureDetector(
            onTap: () => context.pop(),
            child: IcSvg.asset('/logout_v2.svg'),
          ),
          confirm: () async {
            final shared = AppSharedPreference.instance;

            await shared.remove(PrefKeys.token);
            await shared.remove(PrefKeys.tokenRefresh);
            context.router.replaceAll([const LoginRoute()]);
            confirm?.call();
          },
          close: () {
            context.pop();
            close?.call();
          },
        );
      },
    );
  }

  static Future<StatusNoti?> showInforDialog(
    BuildContext context, {
    String? content,
    VoidCallback? accept,
    VoidCallback? close,
    String? titleConfirm,
    String? titleClose,
    bool? barrierDismissible = false,
    bool isClose = true,
    StatusNoti? status = StatusNoti.SUCCESS,
    String? header,
    Widget? data,
  }) =>
      showDialog(
        barrierDismissible: barrierDismissible ?? true,
        context: context,
        builder: (context) {
          return Center(
            child: Card(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(sp16),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp16,
                ),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(sp16),
                ),
                width: max(widthDevice(context) - sp32, 343),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: status == StatusNoti.SUCCESS
                          ? green_2
                          : status == StatusNoti.WARNING
                              ? yellow_2
                              : red_2,
                      child: IcSvg.asset(
                        status == StatusNoti.SUCCESS
                            ? '/noti/icon_noti_success.svg'
                            : status == StatusNoti.WARNING
                                ? '/noti/warning.svg'
                                : '/noti/icon_noti_err.svg',
                      ),
                    ),
                    const SizedBox(height: sp24),
                    Text(
                      header ??
                          (status == StatusNoti.SUCCESS
                              ? 'Thành công'
                              : 'Cảnh báo'),
                      style: h3.copyWith(color: blackColor),
                    ),
                    const SizedBox(height: sp12),
                    if (content != null)
                      Text(
                        content,
                        style: p4.copyWith(color: greyColor),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    16.height,
                    if (data != null) data,
                    16.height,
                    if (status != StatusNoti.LOADING)
                      const SizedBox(height: sp24),
                    if (status != StatusNoti.LOADING)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: ExtraButton(
                              borderRadius: 999,
                              title: titleClose ?? 'Quay lại',
                              event: () {
                                close?.call();
                              },
                              borderColor: borderColor_2,
                              largeButton: false,
                              icon: null,
                            ),
                          ),
                          const SizedBox(width: sp16),
                          Expanded(
                            flex: 1,
                            child: supportButton(
                              borderRadius: 999,
                              title: titleConfirm ?? 'Xác nhận',
                              event: () {
                                accept?.call();
                              },
                              largeButton: false,
                              icon: null,
                              backgroundColor: mainColor,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
