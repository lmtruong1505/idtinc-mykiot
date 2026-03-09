import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/cache_image.dart';
import '../../../../shared/utils/event.dart';

class OverlayServiceItem extends StatelessWidget {
  const OverlayServiceItem({super.key, required this.item, this.onTap});

  final ServiceEntity item;
  final Function(ServiceEntity)? onTap;

  @override
  Widget build(BuildContext context) {
    final image = item.images?.isNotEmpty == true ? item.images?.first : '';
    return MaterialButton(
      onPressed: () {
        onTap?.call(item);
      },
      padding: 12.pading,
      child: Row(
        children: [
          BaseCacheImage(url: image ?? '').size(height: 48, width: 48),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
             
              Text(
                item.title ?? '',
                style: StyleApp.medium(fontSize: 12),
              ),
              4.height,
              Text(
                '${FormatCurrency(item.price.validator)}đ',
                style: StyleApp.bold(fontSize: 12, color: ColorApp.main),
              ),
              
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
