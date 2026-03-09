import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../features_v2/models/product/image_model.dart';
import '../../data/models/diagnosis_model.dart';
import 'file_picker_view.dart';

class ServiceConclusionBts extends StatefulWidget {
  const ServiceConclusionBts({
    super.key,
    required this.service,
    this.conclusion,
    this.callBack,
  });

  final AppointmentService service;
  final String? conclusion;
  final Function(int id, String conclusion, List<File>? files, List<ImageModel> filesNetWork)? callBack;

  static void show(
    BuildContext context, {
    required AppointmentService service,
    String? conclusion,
    Function(int id, String conclusion, List<File>? files, List<ImageModel>? filesNetWork)? callBack,
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
        return ServiceConclusionBts(
          service: service,
          callBack: callBack,
        );
      },
    );
  }

  @override
  State<ServiceConclusionBts> createState() => _ServiceConclusionBtsState();
}

class _ServiceConclusionBtsState extends State<ServiceConclusionBts> {
  String conclusion = '';
  String note = '';
  List<File> images = [];
  List<File> files = [];
  List<ImageModel> filesNetWork = [];

  @override
  void initState() {
    super.initState();

    conclusion = widget.conclusion ?? '';
    if (widget.service.medicalBillData?.isNotEmpty ?? false) {
      conclusion = widget.service.medicalBillData!.first.conclusion!;
      filesNetWork = widget.service.medicalBillData!.first.files!;
    }
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
                      'Thêm kết luận cho dịch vụ',
                      style: s16w700.copyWith(
                        color: AppColors.text_primary,
                      ),
                    ),
                    sp16.height,
                    Column(
                      children: [
                        Text(
                          '${widget.service.serviceData?.serviceName}',
                          style: s14w500.copyWith(
                            color: AppColors.text_primary,
                          ),
                        ),
                        sp4.height,
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Người thực hiện',
                                  style: s12w400.copyWith(
                                      color: AppColors.text_tertiary),
                                ),
                                Text(
                                  widget.service.employeeName ?? '',
                                  style: s12w500.copyWith(
                                      color: AppColors.text_primary),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Số lượng',
                                  style: s12w400.copyWith(
                                      color: AppColors.text_tertiary),
                                ),
                                Text(
                                  '1',
                                  style: s12w500.copyWith(
                                      color: AppColors.text_primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    sp16.height,
                    InputColumn(
                      initialValue: conclusion,
                      label: 'Kết luận sau thực hiện',
                      hintText: 'Nhập kết luận',
                      minLines: 3,
                      padding: const EdgeInsets.all(sp0),
                      onChanged: (p0) {
                        conclusion = p0;
                      },
                    ),
                    sp16.height,
                    _fileNewWorkView,
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
                  widget.service.id!,
                  conclusion,
                  files,
                  filesNetWork,
                );
              },
            ).size(height: 48),
            sp32.height,
          ],
        ),
      ),
    );
  }

  Widget get _fileNewWorkView {
    if (filesNetWork.isEmpty) return const SizedBox.shrink();
    return Column(
      children: filesNetWork.map((e) {
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
                e.fileName ?? '',
                style: s14w400.copyWith(color: AppColors.text_secondary),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    filesNetWork.removeWhere((ei) => ei.url == e.url);
                  });
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: sp20,
                  color: AppColors.icon_iconPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
