import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/color_app.dart';

import '../../../../../shared/style_app/style_text.dart';

class OverlayProductItem extends StatelessWidget {
  const OverlayProductItem({super.key, required this.item, this.onTap});

  final VariantEntity item;
  final Function(VariantEntity)? onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onTap?.call(item);
      },
      padding: 12.pading,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseCacheImage(url: item.media ?? '').size(height: 48, width: 48),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name ?? '',
                style: StyleApp.medium(fontSize: 12),
              ),
              4.height,
              Text(
                '${FormatCurrency(item.priceSell.validator)}đ',
                style: StyleApp.bold(fontSize: 12, color: ColorApp.main),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
