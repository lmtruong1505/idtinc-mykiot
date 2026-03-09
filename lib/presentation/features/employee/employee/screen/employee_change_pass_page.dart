import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/account/cubit/account_cubit.dart';

import '../../../../constants/colors.dart';

@RoutePage()
class EmployeeChangePassPage extends StatefulWidget {
  @override
  State<EmployeeChangePassPage> createState() => _EmployeeChangePassPageState();
}

class _EmployeeChangePassPageState extends State<EmployeeChangePassPage> {
  final myBloc = getIt.get<AccountCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Đổi mật khẩu'),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp20,
                horizontal: sp16,
              ),
              width: widthDevice(context),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp12),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    offset: const Offset(0, 0),
                    blurRadius: sp2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppInputSupport(
                    label: 'Mật khẩu mới',
                    required: true,
                    hintText: 'Nhập mật khẩu mới',
                    backgroundColor: whiteColor,
                    borderColor: borderColor_2,
                    boxShadow: [],
                  ),
                  gapHeight(sp12),
                  AppInputSupport(
                    label: 'Nhập lại mật khẩu mới',
                    required: true,
                    hintText: 'Nhập lại mật khẩu mới',
                    backgroundColor: whiteColor,
                    borderColor: borderColor_2,
                    boxShadow: [],
                  ),
                  gapHeight(sp12),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(sp16),
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.1),
              offset: const Offset(0, -1),
              blurRadius: sp4,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ExtraButton(
                title: 'Huỷ bỏ',
                largeButton: false,
                event: () => context.router.pop(),
                backgroundColor: bg_4,
                borderColor: borderColor_2,
              ),
            ),
            gapWidth(sp12),
            Expanded(
              child: MainButton(
                largeButton: false,
                title: 'Xác nhận',
                event: () => context.router.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
