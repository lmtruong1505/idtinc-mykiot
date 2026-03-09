import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../constants/spacing.dart';

class FilePickerView extends StatelessWidget {
  const FilePickerView({
    super.key,
    required this.files,
    this.callBack,
    this.removeCallBack,
  });

  final List<File> files;
  final Function(List<File>)? callBack;
  final Function(File)? removeCallBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tài liệu liên quan (${files.length}/5)',
          style: s14w500.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        sp12.height,
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: _onTapHandler,
            child: ChipDashBorder(
              padding: const EdgeInsets.all(sp4),
              color: AppColors.fg_quaternary,
              title: 'Tải lên tài liệu liên quan',
              titleStyle: s14w500.copyWith(color: AppColors.text_secondary),
              suffixIcon: const Icon(
                Icons.file_upload_outlined,
                color: AppColors.icon_iconSecondary,
              ),
            ),
          ),
        ),
        ...files.map((e) {
          return Container(
            margin: const EdgeInsets.only(top: sp12),
            padding: const EdgeInsets.all(sp8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border_primary),
              borderRadius: BorderRadius.circular(sp12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.file_present_rounded,
                  size: sp20,
                  color: AppColors.blue60,
                ),
                sp4.width,
                Text(
                  e.path.split('/').last,
                  style: s14w400.copyWith(color: AppColors.text_secondary),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => removeCallBack?.call(e),
                  child: const Icon(
                    Icons.close_rounded,
                    size: sp20,
                    color: AppColors.icon_iconPrimary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _onTapHandler() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final List<File> files = result.paths.map((path) => File(path!)).toList();
      callBack?.call(files);
    }
  }
}
