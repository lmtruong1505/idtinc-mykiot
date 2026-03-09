import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../button/action_btn.dart';

class BtsChooseImage {
  static Future show(
    BuildContext context, {
    int? limit,
    bool showCamera = true,
    bool showGalary = true,
  }) async {
    final picker = ImagePicker();
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoTheme(
          data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              primaryColor: AppColors.bg_primary,
            ),
            barBackgroundColor: AppColors.bg_primary,
          ),
          child: CupertinoActionSheet(
            cancelButton: ActionBtn(
              color: null,
              onTap: () => context.pop(),
              title: 'Huỷ bỏ',
            ),
            actions: [
              Visibility(
                visible: false,
                child: ActionBtn(
                  title: 'Tải ảnh dịch vụ',
                  onTap: () {},
                  style: AppStyle.bodyBsSemiBold.copyWith(
                    color: AppColors.text_quaternary,
                  ),
                ),
              ),
              Visibility(
                visible: showCamera,
                child: ActionBtn(
                  title: 'Chụp ảnh',
                  onTap: () async {
                    final res = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    context.pop(result: res != null ? [res] : null);
                  },
                ),
              ),
              Visibility(
                visible: showGalary,
                child: ActionBtn(
                  title: 'Chọn ảnh từ thư viện',
                  onTap: () async {
                    // context.pop();
                    if (limit == 1) {
                      final res = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      context.pop(result: res != null ? [res] : null);
                      return;
                    }
                    final res = await picker.pickMultiImage(
                      limit: limit,
                    );

                    context.pop(result: res);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
