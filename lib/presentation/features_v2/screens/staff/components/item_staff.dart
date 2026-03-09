import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../router/router.gr.dart';

class ItemStaff extends StatelessWidget {
  final EmployeeModel staff;
  final Function()? onTap;
  final bool isActive;

  const ItemStaff({
    super.key,
    required this.staff,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            context.pushRoute(
              DetailStaffRoute(id: staff.id ?? 0),
            );
          },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? ColorApp.main : ColorApp.greyE2,
          ),
          borderRadius: 8.radius,
          color: ColorApp.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      staff.fullName ?? '',
                      style: StyleApp.medium(fontSize: 16),
                    ),
                    sp8.height,
                    Text(
                      staff.username ?? '',
                      style: StyleApp.normal(),
                    ),
                  ],
                ).expanded(),
                Icon(
                  Icons.circle,
                  size: 10,
                  color: staff.active == true ? ColorApp.main : ColorApp.red,
                ),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(
                  Icons.check,
                  color: ColorApp.blue99,
                ),
                8.width,
                Text(
                  staff.roleName ?? "Bác sĩ",
                  style: StyleApp.medium(),
                ).expanded(),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(
                  Icons.check,
                  color: ColorApp.blue99,
                ),
                8.width,
                Text(
                  staff.companyName ?? getCompanyName ?? "",
                  style: StyleApp.medium(),
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
