import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../constants/spacing.dart';

class InvoiceAiExtractLoadingPopup extends StatelessWidget {
  const InvoiceAiExtractLoadingPopup({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const InvoiceAiExtractLoadingPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(sp16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sp16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(sp16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const CircularProgressIndicator(),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      radius: sp16,
                      backgroundColor: black5o,
                      child: FaIcon(iconCode: 'f00d'),
                    ),
                  ),
                ],
              ),
              sp16.height,
              Text(
                'Nhận diện hóa đơn',
                style: s18w500.copyWith(color: AppColors.text_primary),
              ),
              sp4.height,
              Text(
                'Đang xử lý ảnh - vui lòng chờ trong giây lát.... Tốc độ xử lý phụ thuộc vào số lượng ảnh và lưu lượng truy cập hệ thống.',
                style: s14w400.copyWith(color: AppColors.text_secondary),
              ),
              sp24.height,
              Align(
                alignment: Alignment.center,
                child: SupportButton(
                  title: 'Huỷ bỏ',
                  event: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor:
                      AppColors.button_neutral_alpha_backgroundDefault,
                  radius: sp48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
