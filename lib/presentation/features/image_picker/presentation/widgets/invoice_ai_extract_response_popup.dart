import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../domain/entities/image_receipt_entity.dart';
import 'invoice_ai_instruct_popup.dart';

class InvoiceAiExtractResponsePopup extends StatelessWidget {
  const InvoiceAiExtractResponsePopup({
    super.key,
    required this.images,
    this.callBack,
  });

  final List<ImageReceiptEntity> images;
  final Function? callBack;

  static void show(
    BuildContext context, {
    required List<ImageReceiptEntity> images,
    Function? callBack,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return InvoiceAiExtractResponsePopup(
          images: images,
          callBack: callBack,
        );
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
                  FaIcon(
                    iconCode: 'f00c',
                    color: mainColor,
                  ),
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
              Text(
                'Nhận diện sản phẩm',
                style: s18w500.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              sp4.height,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nhận diện thành công ',
                      style: s14w400.copyWith(color: AppColors.text_secondary),
                    ),
                    TextSpan(
                      text: '$_totalProduct sản phẩm!',
                      style: s14w700.copyWith(color: AppColors.text_secondary),
                    ),
                  ],
                ),
              ),
              sp8.height,
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: heightDevice(context) * 2 / 3,
                  minHeight: 0,
                ),
                child: SingleChildScrollView(
                  child: Scrollbar(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final image = images[index];
                        return BaseContainer(
                          padding: const EdgeInsets.all(sp12),
                          borderRadius: sp12,
                          border: Border.all(
                            color: image.statusAi != 200
                                ? AppColors.red50
                                : AppColors.border_secondary,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(sp0),
                            leading: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(sp12),
                                  child: Image.file(
                                    File(
                                      image.path!,
                                    ),
                                    width: sp48,
                                    height: sp48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: sp8,
                                      backgroundColor: image.statusAi != 200
                                            ? AppColors.red50
                                            : AppColors.green50,
                                      child: FaIcon(
                                        iconCode:
                                            image.statusAi != 200 ? 'f00d' : 'f00c',
                                        color: AppColors.white,
                                        size: sp8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              'Ảnh hoá đơn ${index + 1}',
                              style: s12w500.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                            subtitle: image.statusAi != 200
                                ? _subtitleErrView(context)
                                : _subtitleView(image),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => sp8.height,
                      itemCount: images.length,
                    ),
                  ),
                ),
              ),
              sp4.height,
              Text(
                'Lưu ý: Hệ thống có thể nhận diện sai một số thông tin. Hãy kiểm tra lại kỹ sản phẩm và số lượng trước khi nhập kho.',
                style: s12w400.copyWith(color: AppColors.text_secondary),
              ),
              sp24.height,
              Align(
                alignment: Alignment.center,
                child: ExtraButton(
                  title: 'Hoàn thành',
                  event: () {
                    callBack?.call();
                    Navigator.of(context).pop();
                  },
                  backgroundColor:
                      AppColors.button_neutral_solid_backgroundDefault,
                  borderRadius: sp48,
                  titleColor: AppColors.button_neutral_solid_textDefault,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _totalProduct {
    return images.fold(
      0,
      (total, e) {
        return total += e.count ?? 0;
      },
    );
  }

  Widget _subtitleErrView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Không nhận diện được hình ảnh hãy chụp lại hoặc sử dụng ảnh khác',
          style: s12w400.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        InkWell(
          onTap: () {
            InvoiceAiInstructPopup.show(context);
          },
          child: Text(
            'Hướng dẫn chụp ảnh',
            style: s12w700.copyWith(
              color: AppColors.blue50,
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _subtitleView(ImageReceiptEntity image) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Nhận diện thành công ',
            style: s12w400.copyWith(color: AppColors.text_secondary),
          ),
          TextSpan(
            text: '${image.count ?? 0} sản phẩm!',
            style: s12w500.copyWith(color: AppColors.text_secondary),
          ),
        ],
      ),
    );
  }
}
