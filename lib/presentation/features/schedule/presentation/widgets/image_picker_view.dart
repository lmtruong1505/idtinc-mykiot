import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../gen/assets.dart';
import '../../../../../shared/components/toast/toast_custom.dart';
import '../../../../../shared/components/widgets/bts_choose_image.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';

class ImagePickerView extends StatelessWidget {
  const ImagePickerView({
    super.key,
    required this.images,
    this.callBack,
    this.onDelete,
  });
  final List<File> images;
  final Function(List<XFile> images)? callBack;
  final Function(File image)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ảnh liên quan',
          style: s14w500.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        sp12.height,
        InkWell(
          onTap: () {
            chooseImages(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svgFileIcon,
              ),
              sp4.height,
              Text(
                '${images.length}/10',
                style: s12w400.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              sp8.height,
              RichText(
                text: TextSpan(
                  text: 'Tải ảnh lên',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.button_brand_ghost_textDefault,
                  ),
                  children: [
                    TextSpan(
                      text: ' hoặc ',
                      style: AppStyle.bodyBsRegular.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                    TextSpan(
                      text: 'chụp ảnh',
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.button_brand_ghost_textDefault,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).container(
            radius: 12,
            width: double.infinity,
            border: Border.all(color: AppColors.border_tertiary),
          ),
        ),
        if (images.isNotEmpty) ...[
          sp12.height,
          SizedBox(
            width: widthDevice(context),
            height: sp80,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final image = images[index];
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsetsGeometry.all(sp4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        border: Border.all(color: AppColors.border_primary),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(sp12),
                        child: Image.file(
                          image,
                          width: sp64,
                          height: sp64,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => onDelete?.call(image),
                        child: const CircleAvatar(
                          radius: sp12,
                          backgroundColor: AppColors.bg_disable,
                          child: Icon(
                            Icons.close_rounded,
                            size: sp20,
                            color: AppColors.icon_iconSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => sp8.width,
              itemCount: images.length,
            ),
          ),
        ],
      ],
    );
  }

  void chooseImages(
    BuildContext context, {
    bool showGalary = true,
    bool showCamera = true,
  }) {
    if (images.length >= 10) {
      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: 'Tối đa 10 ảnh',
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_negative_60,
      );
      return;
    }
    BtsChooseImage.show(
      context,
      showCamera: showCamera,
      showGalary: showGalary,
    ).then(
      (value) {
        if (value is List<XFile>) {
          callBack?.call(value);
        }
      },
    );
  }
}
