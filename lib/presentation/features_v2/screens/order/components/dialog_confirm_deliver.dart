import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class DialogConfirmDeliver extends StatelessWidget {
  const DialogConfirmDeliver({super.key, this.onConfirm});

  final Function? onConfirm;

  final _icon = '''
  <svg width="73" height="73" viewBox="0 0 73 73" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16 36.5C16 25.4543 24.9543 16.5 36 16.5C47.0457 16.5 56 25.4543 56 36.5C56 47.5457 47.0457 56.5 36 56.5C24.9543 56.5 16 47.5457 16 36.5Z" fill="#00AB56" fill-opacity="0.1"/>
<path d="M29.8594 26H35.25V32H25.5L27.8438 27.2656C28.2188 26.5156 29.0156 26 29.8594 26ZM36.75 26H42.0938C42.9375 26 43.7344 26.5156 44.1094 27.2656L46.5 32H36.75V26ZM25.5 33.5H46.5V44C46.5 45.6875 45.1406 47 43.5 47H28.5C26.8125 47 25.5 45.6875 25.5 44V33.5ZM41.2969 37.6719C41.7188 37.25 41.7188 36.5469 41.2969 36.125C40.8281 35.6562 40.125 35.6562 39.7031 36.125L34.5 41.3281L32.2969 39.125C31.8281 38.6562 31.125 38.6562 30.7031 39.125C30.2344 39.5469 30.2344 40.25 30.7031 40.6719L33.7031 43.6719C34.125 44.1406 34.8281 44.1406 35.2969 43.6719L41.2969 37.6719Z" fill="#00AB56"/>
<g opacity="0.1">
<path d="M8 36.5C8 21.036 20.536 8.5 36 8.5V8.5C51.464 8.5 64 21.036 64 36.5V36.5C64 51.964 51.464 64.5 36 64.5V64.5C20.536 64.5 8 51.964 8 36.5V36.5Z" stroke="#00AB56"/>
</g>
<g opacity="0.05">
<path d="M0 36.5C0 16.6177 16.1177 0.5 36 0.5V0.5C55.8823 0.5 72 16.6177 72 36.5V36.5C72 56.3823 55.8823 72.5 36 72.5V72.5C16.1177 72.5 0 56.3823 0 36.5V36.5Z" stroke="#00AB56"/>
</g>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: sp16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sp16),
        ),
        child: Container(
          width: widthDevice(context),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.string(_icon),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const CircleAvatar(
                      backgroundColor: greyFF4,
                      child: Icon(
                        Icons.close,
                        color: blackColor,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(sp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xác nhận giao hàng',
                      style: AppStyle.headingLg.copyWith(color: blackColor),
                    ),
                    8.height,
                    RichText(
                      text: TextSpan(
                        style:
                            AppStyle.bodyBsRegular.copyWith(color: blackColor),
                        children: [
                          TextSpan(
                            text: 'Tự kiểm tra',
                            style: AppStyle.bodyBsSemiBold
                                .copyWith(color: mainColor),
                          ),
                          const TextSpan(text: ' và'),
                          TextSpan(
                            text: ' yêu cầu khách hàng kiểm tra',
                            style: AppStyle.bodyBsSemiBold
                                .copyWith(color: mainColor),
                          ),
                          const TextSpan(
                            text:
                                ' đơn hàng trước khi giao - nhận.\nKiểm tra lại',
                          ),
                          TextSpan(
                            text: ' ghi chú hướng dẫn sử dụng',
                            style: AppStyle.bodyBsSemiBold
                                .copyWith(color: mainColor),
                          ),
                          const TextSpan(
                            text: ' (nếu có).',
                          ),
                        ],
                      ),
                    ),
                    24.height,
                    Row(
                      children: [
                        Expanded(
                          child: ExtraButton(
                            title: 'Hủy bỏ',
                            largeButton: false,
                            borderRadius: sp24,
                            backgroundColor: black5o,
                            event: () => context.pop(),
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: MainButton(
                            title: 'Xác nhận',
                            largeButton: false,
                            radius: sp24,
                            event: () {
                              context.pop();
                              onConfirm?.call();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
