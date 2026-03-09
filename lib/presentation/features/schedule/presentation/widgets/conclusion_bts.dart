import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import 'file_picker_view.dart';
import 'image_picker_view.dart';

class ConclusionBts extends StatefulWidget {
  const ConclusionBts({
    super.key,
    this.conclusion,
    this.note,
    this.callBack,
  });

  final String? conclusion;
  final String? note;
  final Function(
    String conclusion,
    String note,
    List<File> images,
    List<File> files,
  )? callBack;

  static void show(
    BuildContext context, {
    String? conclusion,
    String? note,
    Function(
      String conclusion,
      String note,
      List<File> images,
      List<File> files,
    )? callBack,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(sp16),
        ),
      ),
      builder: (context) {
        return ConclusionBts(
          callBack: callBack,
          conclusion: conclusion,
          note: note,
        );
      },
    );
  }

  @override
  State<ConclusionBts> createState() => _ConclusionBtsState();
}

class _ConclusionBtsState extends State<ConclusionBts> {
  String conclusion = '';
  String note = '';
  List<File> images = [];
  List<File> files = [];

  @override
  void initState() {
    super.initState();

    conclusion = widget.conclusion ?? '';
    note = widget.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(sp16).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: heightDevice(context) * 0.85,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: sp64,
                      height: sp4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp24),
                        color: AppColors.bg_disable,
                      ),
                    ),
                    sp16.height,
                    Text(
                      'Thêm kết luận chung cho phiếu khám',
                      style: s16w700.copyWith(
                        color: AppColors.text_primary,
                      ),
                    ),
                    sp16.height,
                    InputColumn(
                      initialValue: conclusion,
                      label: 'Kết luận chung',
                      hintText: 'Nhập kết luận chung',
                      minLines: 3,
                      padding: const EdgeInsets.all(sp0),
                      onChanged: (p0) {
                        conclusion = p0;
                      },
                    ),
                    sp16.height,
                    InputColumn(
                      initialValue: note,
                      label: 'Lời dặn của Bác sĩ',
                      hintText: 'Nhập lời dặn',
                      minLines: 3,
                      padding: const EdgeInsets.all(sp0),
                      onChanged: (p0) {
                        note = p0;
                      },
                    ),
                    sp16.height,
                    _imageView,
                    sp16.height,
                    _fileView,
                  ],
                ),
              ),
            ),
            const Divider(height: sp24),
            DoubleButton(
              cancelText: 'Huỷ bỏ',
              confirmText: 'Lưu lại',
              onCancel: () {
                context.pop();
              },
              onConfirm: () {
                context.pop();
                widget.callBack?.call(
                  conclusion,
                  note,
                  images,
                  files,
                );
              },
            ).size(height: 48),
            sp32.height,
          ],
        ),
      ),
    );
  }

  Widget get _imageView {
    return ImagePickerView(
      images: images,
      callBack: (imgs) {
        final imagesConvert = imgs.map((e) => File(e.path)).toList();
        setState(() {
          images.addAll(imagesConvert);
        });
      },
      onDelete: (image) {
        setState(() {
          images.removeWhere((e) => e.path == image.path);
        });
      },
    );
  }

  Widget get _fileView {
    return FilePickerView(
      files: files,
      callBack: (list) {
        setState(() {
          files.addAll(list);
        });
      },
      removeCallBack: (file) {
        setState(() {
          files.removeWhere((e) => e.path == file.path);
        });
      },
    );
  }
}
