import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/order_create_bloc.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/bts_choose_image.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';

class ConfirmOrderPrescription extends StatefulWidget {
  const ConfirmOrderPrescription({
    super.key,
    required this.bloc,
  });

  final OrderCreateBloc bloc;

  @override
  State<ConfirmOrderPrescription> createState() => _ConfirmOrderPrescriptionState();
}

class _ConfirmOrderPrescriptionState extends State<ConfirmOrderPrescription> {
  static const int _maxImage = 10;

  late final TextEditingController _prescriptionCodeController;
  late final List<File> _images;
  late bool _isAddedPrescription;

  @override
  void initState() {
    super.initState();
    _prescriptionCodeController = TextEditingController(
      text: widget.bloc.prescriptionCode,
    );
    _images = List<File>.from(widget.bloc.prescriptionImages);
    _isAddedPrescription =
        _prescriptionCodeController.text.trim().isNotEmpty || _images.isNotEmpty;
  }

  @override
  void dispose() {
    _prescriptionCodeController.dispose();
    super.dispose();
  }

  void _syncBloc() {
    widget.bloc.prescriptionCode = _prescriptionCodeController.text;
    widget.bloc.prescriptionImages = List<File>.from(_images);
  }

  Future<void> _pickImages({
    bool showGallery = true,
    bool showCamera = true,
  }) async {
    if (_images.length >= _maxImage) {
      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: 'Tối đa $_maxImage ảnh',
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_negative_60,
      );
      return;
    }

    final res = await BtsChooseImage.show(
      context,
      showGalary: showGallery,
      showCamera: showCamera,
      limit: _maxImage - _images.length,
    );

    if (res is! List<XFile> || res.isEmpty) return;

    setState(() {
      _images.addAll(
        res
            .take(_maxImage - _images.length)
            .map((e) => File(e.path))
            .toList(),
      );
    });
    _syncBloc();
  }

  void _removePrescription() {
    setState(() {
      _isAddedPrescription = false;
      _prescriptionCodeController.clear();
      _images.clear();
    });
    _syncBloc();
  }

  void _previewImage(File image) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: 16.pading,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: 12.radius,
                  color: AppColors.bg_primary,
                ),
                padding: 8.pading,
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: ClipRRect(
                    borderRadius: 12.radius,
                    child: Image.file(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.bg_disable,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.icon_iconSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAddedPrescription) {
      return Column(
        children: [
          24.height,
          Row(
            children: [
              Text(
                'Đơn thuốc',
                style: AppStyle.headingLg,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    _isAddedPrescription = true;
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.bg_secondary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 20,
                    color: AppColors.icon_iconSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.height,
        Row(
          children: [
            Text(
              'Đơn thuốc',
              style: AppStyle.headingLg,
            ),
            const Spacer(),
            InkWell(
              onTap: _removePrescription,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: AppColors.icon_iconSecondary,
                ),
              ),
            ),
          ],
        ),
        12.height,
        InputColumn(
          controller: _prescriptionCodeController,
          label: 'Mã đơn thuốc',
          padding: 0.pading,
          hintText: 'Nhập mã đơn thuốc',
          onChanged: (_) {
            _syncBloc();
          },
        ),
        12.height,
        Text(
          'Ảnh liên quan',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        8.height,
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: 12.radius,
            border: Border.all(color: AppColors.border_tertiary),
          ),
          padding: 12.pading,
          child: Column(
            children: [
              if (_images.isNotEmpty) ...[
                SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () => _previewImage(image),
                            child: ClipRRect(
                              borderRadius: 8.radius,
                              child: Image.file(
                                image,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                                _syncBloc();
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.bg_disable,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: AppColors.icon_iconSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, __) => 8.width,
                    itemCount: _images.length,
                  ),
                ),
                8.height,
              ] else ...[
                SvgPicture.asset(Assets.svgFileIcon),
                4.height,
              ],
              Text(
                '${_images.length}/$_maxImage',
                style: AppStyle.bodySmRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _pickImages(showCamera: false),
                    child: Text(
                      'Tải ảnh lên',
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.button_brand_ghost_textDefault,
                      ),
                    ),
                  ),
                  Text(
                    ' hoặc ',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => _pickImages(showGallery: false),
                    child: Text(
                      'chụp ảnh',
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.button_brand_ghost_textDefault,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
