import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../constants/spacing.dart';
import '../domain/entities/service_entity.dart';

class ItemService extends StatelessWidget {
  final bool isActive;
  final ServiceEntity item;
  const ItemService({
    super.key,
    this.isActive = false,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        border: Border.all(
          color: isActive ? ColorApp.main : ColorApp.greyE2,
        ),
        borderRadius: 8.radius,
        color: ColorApp.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseCacheImage(
            url: item.image ?? PrefKeys.imgProductDefault,
            borderRadius: 8.radius,
            width: 52,
            height: 52,
          ),
          sp16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.title ?? "",
                style: StyleApp.medium(fontSize: 16),
              ),
              8.height,
              Text(
                '${item.price.formatPrice(type: 'đ')}/${item.unit ?? "lần"}',
                style: StyleApp.normal(color: ColorApp.main),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
