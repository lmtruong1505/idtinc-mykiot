import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/features_v2/blocs/order/order_detail_v2_bloc.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/bts_choose_image.dart';

import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../constants/typography.dart';
import '../../../../models/order/order_detail_v2_model.dart';

class BtsOrderPrescription extends StatefulWidget {
  const BtsOrderPrescription({
    super.key,
    required this.orderId,
    required this.bloc,
    this.prescriptionCode,
    this.prescriptionImages,
    this.callBack,
  });

  final int orderId;
  final String? prescriptionCode;
  final List<PrescriptionImageV2Model>? prescriptionImages;
  final Function()? callBack;

  static Future<void> show(
    BuildContext context, {
    required int orderId,
    String? prescriptionCode,
    List<PrescriptionImageV2Model>? prescriptionImages,
    required OrderDetailV2Bloc bloc,
    Function()? callBack,
  }) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BtsOrderPrescription(
          orderId: orderId,
          prescriptionCode: prescriptionCode,
          prescriptionImages: prescriptionImages,
          bloc: bloc,
          callBack: callBack,
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
    );
  }

  final OrderDetailV2Bloc bloc;

  @override
  State<BtsOrderPrescription> createState() => _BtsOrderPrescriptionState();
}

class _BtsOrderPrescriptionState extends State<BtsOrderPrescription> {
  static const int _maxImage = 10;

  late final TextEditingController _prescriptionCodeController;
  late final List<PrescriptionImageV2Model> _prescriptionImages;
  final List<File> _imagesAdd = [];
  bool _isSubmitting = false;

  int get _totalImage => _prescriptionImages.length + _imagesAdd.length;

  @override
  void initState() {
    super.initState();
    _prescriptionCodeController = TextEditingController(
      text: widget.prescriptionCode ?? '',
    );
    _prescriptionImages =
        List<PrescriptionImageV2Model>.from(widget.prescriptionImages ?? []);
  }

  @override
  void dispose() {
    _prescriptionCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages({
    bool showGallery = true,
    bool showCamera = true,
  }) async {
    if (_totalImage >= _maxImage) {
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
      limit: _maxImage - _totalImage,
    );

    if (res is! List<XFile> || res.isEmpty) return;

    setState(() {
      _imagesAdd.addAll(
        res.take(_maxImage - _totalImage).map((e) => File(e.path)).toList(),
      );
    });
  }

  Future<void> _save() async {
    if (_isSubmitting) return;
    if (_prescriptionCodeController.text.trim().isEmpty) {
      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: 'Vui lòng nhập mã đơn thuốc',
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_negative_60,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final res = await widget.bloc.updatePrescription(
      orderId: widget.orderId,
      prescriptionCode: _prescriptionCodeController.text.trim(),
      prescriptionImages: _prescriptionImages,
      prescriptionImagesAdd: _imagesAdd,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (res.code == 200) {
      ToastCustom.show(
        context,
        title: 'Thành công',
        msg: res.message ?? 'Cập nhật đơn thuốc thành công',
        svgIcon: Assets.iconsSuccess,
        color: AppColors.ultility_brand_60,
      );
      widget.callBack?.call();
      context.router.maybePop();
      return;
    }

    ToastCustom.show(
      context,
      title: 'Thông báo',
      msg: res.message ?? 'Cập nhật đơn thuốc thất bại',
      svgIcon: Assets.svgWarningOutline,
      color: AppColors.ultility_negative_60,
    );
  }

  Widget _itemOldImage(PrescriptionImageV2Model image) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(sp8),
          child: Image.network(
            image.url ?? '',
            width: sp56,
            height: sp56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                width: sp56,
                height: sp56,
                color: AppColors.bg_disable,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.icon_iconSecondary,
                  size: sp16,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _prescriptionImages.remove(image);
              });
            },
            child: Container(
              width: sp20,
              height: sp20,
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
  }

  Widget _itemNewImage(File image) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(sp8),
          child: Image.file(
            image,
            width: sp56,
            height: sp56,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _imagesAdd.remove(image);
              });
            },
            child: Container(
              width: sp20,
              height: sp20,
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .72,
      padding: const EdgeInsets.all(sp16).copyWith(top: sp8),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp24),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: sp40,
                      height: sp4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        color: greyFF3,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => context.router.maybePop(),
                      child: const CircleAvatar(
                        radius: sp20,
                        backgroundColor: greyFF3,
                        child: Icon(
                          Icons.close_rounded,
                          color: blackColor,
                          size: sp16,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Thông tin đơn thuốc',
                    style: p1.copyWith(color: greyTextColor),
                    textAlign: TextAlign.center,
                  ),
                  gapHeight(sp20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Mã đơn thuốc',
                          style: p5.copyWith(color: greyTextColor),
                        ),
                        TextSpan(
                          text: '*',
                          style: p5.copyWith(color: red_1),
                        ),
                      ],
                    ),
                  ),
                  gapHeight(sp8),
                  TextField(
                    controller: _prescriptionCodeController,
                    decoration: InputDecoration(
                      hintText: 'Nhập mã đơn thuốc',
                      hintStyle: p5.copyWith(color: greyColor),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: sp12,
                        vertical: sp12,
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(sp12),
                        borderSide: const BorderSide(color: borderColor_2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(sp12),
                        borderSide: const BorderSide(color: borderColor_2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(sp12),
                        borderSide: const BorderSide(color: borderColor_2),
                      ),
                    ),
                  ),
                  gapHeight(sp16),
                  Text(
                    'Ảnh liên quan',
                    style: p5.copyWith(color: greyTextColor),
                  ),
                  gapHeight(sp8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      border: Border.all(color: borderColor_2),
                    ),
                    padding: const EdgeInsets.all(sp12),
                    child: Column(
                      children: [
                        if (_totalImage > 0) ...[
                          SizedBox(
                            height: sp56,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index < _prescriptionImages.length) {
                                  return _itemOldImage(
                                    _prescriptionImages[index],
                                  );
                                }
                                return _itemNewImage(
                                  _imagesAdd[index - _prescriptionImages.length],
                                );
                              },
                              separatorBuilder: (_, __) => gapWidth(sp8),
                              itemCount: _totalImage,
                            ),
                          ),
                          gapHeight(sp8),
                        ] else ...[
                          SvgPicture.asset(Assets.svgFileIcon),
                          gapHeight(sp4),
                        ],
                        Text(
                          '$_totalImage/$_maxImage',
                          style: p5.copyWith(color: greyColor),
                        ),
                        gapHeight(sp8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => _pickImages(showCamera: false),
                              child: Text(
                                'Tải ảnh lên',
                                style: p5.copyWith(color: mainColor),
                              ),
                            ),
                            Text(
                              ' hoặc ',
                              style: p5.copyWith(color: greyTextColor),
                            ),
                            InkWell(
                              onTap: () => _pickImages(showGallery: false),
                              child: Text(
                                'chụp ảnh',
                                style: p5.copyWith(color: mainColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.callBack != null) ...{
            const Divider(height: sp24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : () => context.router.maybePop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: greyFF3,
                      disabledBackgroundColor: greyFF3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sp24),
                      ),
                      minimumSize: const Size.fromHeight(sp40),
                    ),
                    child: Text(
                      'Hủy bỏ',
                      style: p4.copyWith(color: greyTextColor),
                    ),
                  ),
                ),
                gapWidth(sp16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _save,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: mainColor,
                      disabledBackgroundColor: mainColor.withOpacity(.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sp24),
                      ),
                      minimumSize: const Size.fromHeight(sp40),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: sp16,
                            height: sp16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: whiteColor,
                            ),
                          )
                        : Text(
                            'Lưu lại',
                            style: p4.copyWith(color: whiteColor),
                          ),
                  ),
                ),
              ],
            ),
            gapHeight(MediaQuery.of(context).padding.bottom),
          },
        ],
      ),
    );
  }
}
