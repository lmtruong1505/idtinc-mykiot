import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import '../../../../../../shared/style_app/init_style.dart';

Container buildInfor(EmployeeModel staff) {
  return Container(
    padding: Dimensions.sp16.pading,
    decoration: BoxDecoration(
      color: ColorApp.white,
      borderRadius: Dimensions.sp8.radius,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Thông tin nhân viên',
                style: StyleApp.medium(
                  color: ColorApp.grey79,
                ),
              ),
            ),
            if (staff.active == true)
              GestureDetector(
                onTap: () {
                  String phone = staff.username ?? '';
                  if (phone.isNotEmpty) {
                    LaunchUrl.phone(phone);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorApp.greenE6,
                    border: Border.all(
                      color: ColorApp.main,
                    ),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: ColorApp.main,
                  ),
                ),
              ),
          ],
        ),
        Dimensions.sp16.height,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  staff.fullName ?? '',
                  style: StyleApp.semibold(
                    fontSize: 16,
                  ),
                ),
                Dimensions.sp8.height,
                Text(
                  '#NV${staff.id}',
                  style: StyleApp.semibold(
                    fontSize: 12,
                    color: ColorApp.grey79,
                  ),
                ),
              ],
            ).expanded(),
            Text(
              staff.active == true ? 'Đang hoạt động' : 'Vô hiệu hoá',
              style: StyleApp.medium(
                color: staff.active == true ? ColorApp.main : ColorApp.red,
              ),
            ).container(
              bgColor: staff.active == true ? ColorApp.greenE6 : ColorApp.redFE,
            ),
          ],
        ),
      ],
    ),
  );
}
