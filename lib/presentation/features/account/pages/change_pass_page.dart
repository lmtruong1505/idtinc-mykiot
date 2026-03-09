import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/account/cubit/account_cubit.dart';

import '../../../constants/colors.dart';

@RoutePage()
class ChangePassPage extends StatefulWidget {
  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final myBloc = getIt.get<AccountCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: 'Đổi mật khẩu'),
        body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            padding: const EdgeInsets.symmetric(
              vertical: sp24,
              horizontal: sp16,
            ),
            child: ListView(children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: sp20, horizontal: sp16),
                  width: widthDevice(context),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(sp12),
                      boxShadow: [
                        BoxShadow(
                            color: blackColor.withOpacity(0.1),
                            offset: const Offset(1, 1),
                            blurRadius: 1)
                      ]),
                  child: Column(children: [
                    AppInputSupport(
                      label: 'Mật khẩu hiện tại',
                      hintText: 'Nhập mật khẩu hiện tại',
                    ),
                    gapHeight(sp12),
                    AppInputSupport(
                      label: 'Mật khẩu mới',
                      hintText: 'Nhập mật khẩu mới',
                    ),
                    gapHeight(sp12),
                    AppInputSupport(
                      label: 'Nhập lại mật khẩu mới',
                      hintText: 'Nhập lại mật khẩu mới',
                    ),
                    gapHeight(sp12),
                  ])),
            ])),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.all(sp16),
            decoration: BoxDecoration(color: whiteColor, boxShadow: [
              BoxShadow(
                  color: blackColor.withOpacity(0.1),
                  offset: const Offset(0, -1),
                  blurRadius: sp4)
            ]),
            child: Row(children: [
              Expanded(
                  child: ExtraButton(
                      title: 'Huỷ bỏ',
                      largeButton: false,
                      event: () => context.router.pop(),
                      backgroundColor: bg_4,
                      borderColor: borderColor_2)),
              SizedBox(width: 10),
              Expanded(
                  child: MainButton(
                      largeButton: false,
                      title: 'Lưu lại',
                      event: () => context.router.pop()))
            ])));
  }
}
