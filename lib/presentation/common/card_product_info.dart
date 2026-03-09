import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';

import '../../../../shared/constants/pref_key.dart';
import '../base/cache_image.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class CardProductInfo extends StatelessWidget {
  const CardProductInfo({
    super.key,
    required this.product,
    this.onDelete,
  });

  final ProductEntity product;
  final Function(ProductEntity value)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: SizedBox(
              height: sp48,
              width: sp48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(sp8),
                child: BaseCacheImage(
                  url: (product.image?.isNotEmpty ?? false)
                      ? product.image![0]
                      : PrefKeys.imgProductDefault,
                ),
              ),
            ),
            title: Text(
              product.name ?? 'Chưa có dữ liệu',
              style: p5.copyWith(color: blackColor),
            ),
            subtitle: Text(
              product.code ?? 'Chưa có dữ liệu',
              style: p6.copyWith(color: greyColor),
            ),
            trailing: IconButton(
              onPressed: () => onDelete?.call(product),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: red_1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
