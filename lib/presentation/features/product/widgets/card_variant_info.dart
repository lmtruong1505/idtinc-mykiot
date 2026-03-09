import 'package:flutter/material.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../domain/entities/variant_entity.dart';

class CardVariantInfo extends StatelessWidget {
  const CardVariantInfo({
    super.key,
    required this.variant,
    this.onDelete,
  });

  final VariantEntity variant;
  final Function(VariantEntity value)? onDelete;

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
                  url: variant.media ?? PrefKeys.imgProductDefault,
                ),
              ),
            ),
            title: Text(
              variant.name ?? 'Chưa có dữ liệu',
              style: p5.copyWith(color: blackColor),
            ),
            subtitle: Text(
              variant.code ?? 'Chưa có dữ liệu',
              style: p6.copyWith(color: greyColor),
            ),
            trailing: IconButton(
              onPressed: () => onDelete?.call(variant),
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
