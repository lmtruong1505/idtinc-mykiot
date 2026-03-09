import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';

import '../../../constants/colors.dart';
import '../../../constants/typography.dart';
import '../../../shared/constants/enums/type_account_enum.dart';

@RoutePage()
class TypeAccountPage extends StatefulWidget {
  const TypeAccountPage({
    super.key,
    this.onNext,
  });

  final Function(AccountTypeEnum value)? onNext;

  @override
  State<TypeAccountPage> createState() => _TypeAccountPageState();
}

class _TypeAccountPageState extends State<TypeAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const BaseAppBar(title: 'Lựa chọn chức vụ'),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(sp16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp12),
                color: bg_4,
              ),
              child: InkWell(
                onTap: () => widget.onNext?.call(AccountTypeEnum.admin),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(sp0),
                  leading: IcSvg.asset('/type_account/ic_admin.svg'),
                  title: Text(
                    'Tôi là chủ cửa hàng',
                    style: p5.copyWith(color: blackColor),
                  ),
                  subtitle: Text(
                    'Cung cấp cho tôi những tính năng để quản lý cửa hàng của mình',
                    style: p9.copyWith(color: borderColor_4),
                  ),
                  trailing: const Icon(
                    Icons.arrow_right_rounded,
                  ),
                ),
              ),
            ),
            gapHeight(sp16),
            Container(
              padding: const EdgeInsets.all(sp16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp12),
                color: bg_4,
              ),
              child: InkWell(
                onTap: () => widget.onNext?.call(AccountTypeEnum.employee),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(sp0),
                  leading: IcSvg.asset('/type_account/ic_employee.svg'),
                  title: Text(
                    'Tôi là nhân viên',
                    style: p5.copyWith(color: blackColor),
                  ),
                  subtitle: Text(
                    'Tôi tham gia với vai trò là nhân viên của cửa hàng.',
                    style: p9.copyWith(color: borderColor_4),
                  ),
                  trailing: const Icon(
                    Icons.arrow_right_rounded,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
