import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/bts_choose_image.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../blocs/service/bloc_index.dart';

class TabImagesCreateService extends StatefulWidget {
  final CreateServiceV2Bloc bloc;
  const TabImagesCreateService({
    super.key,
    required this.bloc,
  });

  @override
  State<TabImagesCreateService> createState() => _TabImagesCreateServiceState();
}

class _TabImagesCreateServiceState extends State<TabImagesCreateService>
    with AutomaticKeepAliveClientMixin {
  List<MapEntry<int, XFile>> files = [];

  List<int> indexRemove = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    files = widget.bloc.images;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildChooseImage(),
          16.height,
          ...List.generate(
            files.length,
            (index) {
              final list =
                  files.mapIndexed((index, element) => element.value).toList();
              return ItemImage(
                index: index,
                files: list,
                onTap: () {
                  indexRemove.add(files[index].key);
                  files.removeAt(index);
                  widget.bloc.indexRemove = indexRemove;
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void chooseImages() {
    if (files.length >= 4) {
      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: 'Tối đa 4 ảnh đại diện',
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_negative_60,
      );
      return;
    }
    BtsChooseImage.show(
      context,
      limit: 4 - files.length,
    ).then(
      (value) {
        if (value is List<XFile>) {
          for (final element in value) {
            if (files.length < 4) {
              files.add(
                MapEntry(
                  -1,
                  element,
                ),
              );
            }
          }

          setState(() {});
          widget.bloc.images = files;
        }
      },
    );
  }

  // Widget ItemImage(int index) {
  //   return ItemImage(files: files);
  // }

  Widget _buildChooseImage() {
    return InkWell(
      onTap: chooseImages,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.svgFileIcon,
          ),
          12.height,
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
        height: 120,
        radius: 12,
        border: Border.all(color: AppColors.border_tertiary),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ItemImage extends StatelessWidget {
  const ItemImage({
    super.key,
    required this.files,
    required this.index,
    required this.onTap,
  });

  final List<XFile> files;
  final int index;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: 8.radius,
              child: files[index].path.startsWith('http')
                  ? BaseCacheImage(
                      url: files[index].path,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(files[index].path),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
            ),
            12.width,
            Row(
              children: [
                Text(
                  'Ảnh dịch vụ ${index + 1}',
                  style: AppStyle.bodyBsMedium.copyWith(
                    height: 1.5,
                  ),
                ).expanded(),
                12.width,
                IconBtn(
                  onTap: () => onTap?.call(),
                  size: const Size(24, 24),
                  padding: 4.pading,
                  icon: const Icon(
                    Icons.remove,
                    size: 15,
                    color: AppColors.button_neutral_alpha_iconDefault,
                  ),
                ),
              ],
            ).expanded(),
          ],
        ).container(
          padding: 12.pading,
          radius: 12,
          border: Border.all(color: AppColors.border_tertiary),
        ),
        Positioned(
          bottom: 5,
          right: 10,
          child: Text(
            '${index + 1}/4',
            textAlign: TextAlign.right,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_quaternary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
