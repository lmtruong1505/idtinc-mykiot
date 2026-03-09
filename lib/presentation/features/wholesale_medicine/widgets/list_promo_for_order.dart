import 'package:flutter/material.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../base/row_item.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../domain/entities/order_wm_payload_entity.dart';


class ListPromoForOrder extends StatelessWidget {
  const ListPromoForOrder({
    super.key,
    required this.listPromo,
  });

  final List<OrderWmItemPayload> listPromo;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = listPromo[index];
        return Container(
          padding: const EdgeInsets.all(sp16),
          color: yellow_2,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  sp12,
                ),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: BaseCacheImage(
                    url: item.variantData?.image ?? PrefKeys.imgProductDefault,
                  ),
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variantData?.title ?? '',
                      style: p5,
                    ),
                    const SizedBox(height: sp8),
                    RowItem(
                      titleColor: greyColor,
                      title: 'Số lượng:',
                      content: item.quantity.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemCount: listPromo.length,
    );
  }
}
