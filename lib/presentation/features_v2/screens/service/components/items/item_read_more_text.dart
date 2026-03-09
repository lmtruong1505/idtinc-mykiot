import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:readmore/readmore.dart';

import '../../../../../config/app_style/init_app_style.dart';

class ItemReadMoreText extends StatefulWidget {
  final String title;
  final String? description;
  const ItemReadMoreText({
    super.key,
    required this.title,
    this.description,
  });

  @override
  State<ItemReadMoreText> createState() => _ItemReadMoreTextState();
}

class _ItemReadMoreTextState extends State<ItemReadMoreText> {
  final isHide = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        InkWell(
          onTap: () {
            isHide.value = true;
          },
          child: ReadMoreText(
            widget.description.isEmptyOrNull
                ? 'Chưa có thông tin'
                : widget.description!,
            //'Siro Datadu Kingphar thích hợp sử dụng cho người bị cảm lạnh với các biểu hiện: Đau đầu, sốt, hắt hơi, ngạt mũi, chảy nước mũi, họ nhiều, ho có đờm, đau rát họng do cảm lạnh, do thay đổi thời tiết. Dùng được cho phụ nữ có thai',
            trimMode: TrimMode.Line,
            trimLines: 1,
            textAlign: TextAlign.justify,
            isExpandable: true,
            trimCollapsedText: ' Xem thêm',
            trimExpandedText: '',
            isCollapsed: isHide,
            colorClickableText: AppColors.button_brand_ghost_textDefault,
            style: widget.description.isEmptyOrNull
                ? AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_disable,
                    height: 1.5,
                  )
                : AppStyle.bodyBsMedium.copyWith(
                    height: 1.5,
                  ),
          ),
        ),
      ],
    );
  }
}
