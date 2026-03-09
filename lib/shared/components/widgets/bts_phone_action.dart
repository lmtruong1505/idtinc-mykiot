import 'package:flutter/cupertino.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import '../button/action_btn.dart';

class BtsPhoneAction {
  static show(
    BuildContext context, {
    required String phoneNumber,
    required String fullname,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          cancelButton: ActionBtn(
            color: null,
            onTap: () => context.pop(),
            title: 'Huỷ bỏ',
          ),
          actions: [
            ActionBtn(
              title: 'Gọi $phoneNumber',
              onTap: () {
                Navigator.pop(context);
                LaunchUrl.phone(phoneNumber);
              },
            ),
            ActionBtn(
              title: 'Gọi Zalo',
              onTap: () {
                Navigator.pop(context);
                LaunchUrl.openZalo(phoneNumber);
              },
            ),
            // ActionBtn(
            //   title: 'Thêm danh bạ',
            //   onTap: () async {
            //     if (await FlutterContacts.requestPermission()) {
            //       final newContact = Contact()
            //         ..name.last = fullname
            //         ..phones = [Phone(phoneNumber)];
            //       final result = await newContact.insert();
            //       if (result.name.last.isNotEmpty) {
            //         ToastCustom.show(
            //           context,
            //           title: 'Thành công',
            //           msg: 'Thêm số điện thoại vào danh bạ thành công',
            //           svgIcon: Assets.svgSuccess,
            //           color: AppColors.ultility_brand_60,
            //         );
            //       }
            //     }
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        );
      },
    );
  }
}
