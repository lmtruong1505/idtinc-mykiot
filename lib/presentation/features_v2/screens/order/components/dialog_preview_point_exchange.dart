import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../base/cache_image.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../../shared/utils/event.dart';
import '../../../models/customer/v2/customer_point_item_model.dart';
import '../../../models/product/product_v2_model.dart';

class DialogPreviewPointExchange extends StatelessWidget {
  const DialogPreviewPointExchange({
    super.key,
    required this.point,
    required this.productsSelected,
    required this.productsFromPackage,
    required this.moneyExchange,
  });

  final num point;
  final List<ProductV2Model> productsSelected;
  final List<PointExchangePackageModel> productsFromPackage;
  final CustomerPointItemModel moneyExchange;

  static void show(
    BuildContext context, {
    required num point,
    required List<ProductV2Model> productsSelected,
    required List<PointExchangePackageModel> productsFromPackage,
    required CustomerPointItemModel moneyExchange,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      builder: (context) {
        return DialogPreviewPointExchange(
          point: point,
          productsSelected: productsSelected,
          productsFromPackage: productsFromPackage,
          moneyExchange: moneyExchange,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final num totalPointProductUsed = productsSelected.fold(
      0,
      (total, e) {
        return total += (e.quantity ?? 0) * (e.exchangePoint ?? 0);
      },
    );

    final num totalPointPackageUsed = productsFromPackage.fold(
      0,
      (total, e) {
        final listProductSelected =
            e.items?.where((e) => e.product?.isSelected == true) ?? [];
        if (listProductSelected.isNotEmpty) {
          total += e.point ?? 0;
        }
        return total;
      },
    );

    final num totalPointUsed = totalPointProductUsed +
        totalPointPackageUsed +
        (moneyExchange.point ?? 0);
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(
        bottom: sp48,
        left: sp32,
        right: sp32,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
        color: AppColors.bg_white,
      ),
      child: Column(
        children: [
          Container(
            width: sp48,
            height: sp4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp12),
              color: AppColors.border_tertiary,
            ),
          ),
          sp16.height,
          Text(
            'Quà tặng từ đổi điểm',
            style: s16w700.copyWith(color: AppColors.text_secondary),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: sp12,
                children: [
                  ...productsSelected.map((item) => ListTile(
                    contentPadding: const EdgeInsets.all(sp0),
                    leading: BaseCacheImage(
                      loadPharmagoLogo: true,
                      url: item.images?.firstOrNull?.url ?? '',
                      width: 50,
                      height: 50,
                      borderRadius: 4.radius,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyBsMedium.copyWith(
                        height: 1.5,
                        color: AppColors.text_primary,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          '${item.exchangePoint ?? 0}',
                          style:
                              s12w500.copyWith(color: AppColors.text_tertiary),
                        ),
                        sp8.width,
                        SvgPicture.asset('assets/svg/point.svg'),
                        const Spacer(),
                        Text(
                          'x${item.quantity}',
                          style: s10w400.copyWith(
                            color: AppColors.red50,
                          ),
                        ),
                      ],
                    ),
                  ),),
                  ...productsFromPackage.map((e) => _itemPackage(e)),
                ],
              ),
            ),
          ),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Đã sử dụng từ ',
                      style: s12w500.copyWith(color: AppColors.text_primary),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Giảm tiền',
                              style: s12w400.copyWith(
                                  color: AppColors.text_secondary),
                            ),
                            const Spacer(),
                            Text(
                              moneyExchange.point.formatCurrency,
                              style: s12w500.copyWith(
                                  color: AppColors.text_primary),
                            ),
                            sp4.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Đổi quà',
                              style: s12w400.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              totalPointProductUsed.formatCurrency,
                              style: s12w500.copyWith(
                                color: AppColors.text_primary,
                              ),
                            ),
                            sp4.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Đổi quà từ gói',
                              style: s12w400.copyWith(
                                  color: AppColors.text_secondary),
                            ),
                            const Spacer(),
                            Text(
                              totalPointPackageUsed.formatCurrency,
                              style: s12w500.copyWith(
                                color: AppColors.text_primary,
                              ),
                            ),
                            sp4.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sp4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Giảm từ điểm: ',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ),
                        Text(
                          '${moneyExchange.moneyExchange.formatCurrency}đ',
                          style:
                              s14w500.copyWith(color: AppColors.text_primary),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'Số điểm còn lại',
                            style: s12w400.copyWith(
                                color: AppColors.text_tertiary),
                          ),
                        ),
                        sp8.width,
                        Text(
                          (point - totalPointUsed).formatCurrency,
                          style:
                              s12w500.copyWith(color: AppColors.text_primary),
                        ),
                        sp4.width,
                        SvgPicture.asset('assets/svg/point.svg'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemPackage(PointExchangePackageModel item) {
    return Column(
      children: [
        Row(
          spacing: sp4,
          children: [
            SvgPicture.asset('assets/svg/point.svg'),
            Text(
              '${item.point.formatCurrency} điểm',
              style: s14w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            const Spacer(),
            Text(
              'Đổi từ',
              style: s12w400.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            Text(
              '${item.name}',
              style: s12w500.copyWith(
                color: AppColors.text_primary,
              ),
            ),
          ],
        ),
        ...(item.items ?? [])
            .where((e) => e.product?.isSelected == true)
            .map((e) {
          return Row(
            spacing: sp8,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(sp4),
                child: Image.network(
                  e.product?.images?.firstOrNull?.url ??
                      PrefKeys.imgProductDefault,
                  width: sp48,
                  height: sp48,
                  fit: BoxFit.cover,
                ),
              ),
              gapWidth(sp16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.product?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: s14w500.copyWith(color: AppColors.text_primary),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${FormatCurrency(e.unit?.sellPrice)} đ',
                          style: p5.copyWith(color: blackColor),
                        ),
                        Text(
                          '/${e.unit?.name}',
                          style: p5.copyWith(color: blackColor),
                        ),
                        const Spacer(),
                        Text(
                          '${FormatCurrency(e.quantity)} ${e.unit?.name}',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
