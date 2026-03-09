import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/svg.dart';
import '../../../models/variant_kafa/promotion_kafa_model.dart';
import 'text_in_container.dart';

class VariantOrderConfirmCard extends StatefulWidget {
  const VariantOrderConfirmCard({super.key, required this.variant});

  final VariantKafaModel variant;

  @override
  State<VariantOrderConfirmCard> createState() =>
      _VariantOrderConfirmCardState();
}

class _VariantOrderConfirmCardState extends State<VariantOrderConfirmCard> {
  List<PromotionDetailModel> listPromo = [];

  @override
  void initState() {
    listPromo = filterPromo(widget.variant.promotionDetail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 16.pading,
      margin: 8.padingBottom,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 16.radius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _basicInfo(),
              8.height,
              _buildDetailPromo(),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  _basicInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseCacheImage(url: widget.variant.image ?? '', width: 64, height: 64),
        8.width,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.variant.title ?? '',
                  style: StyleApp.bold(color: ColorApp.black),
                  maxLines: 2,
                ),
                4.height,
                Row(
                  children: [
                    Text('SL: $quantity',
                            style: StyleApp.bold(color: ColorApp.grey79))
                        .expanded(),
                    Text(
                      '${FormatCurrency(quantity * widget.variant.price.validator)}đ',
                      style: StyleApp.bold(color: ColorApp.main),
                    )
                  ],
                ),
                // Text(
                //   'Còn 1000',
                //   style: StyleApp.bold(color: ColorApp.black),
                //   maxLines: 2,
                // ),
              ],
            ).expanded(),
          ],
        ).expanded(),
      ],
    );
  }

  List<PromotionDetailModel> filterPromo(List<PromotionDetailModel> list) {
    return list.where((e) {
      bool haveQuantity = false;
      e.promotionItemData?.forEach((element) {
        if (element.quantitySelected > 0) {
          haveQuantity = true;
        }
      });
      return haveQuantity;
    }).toList();
  }

  Widget _buildSPTK(int i, int j) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInContainer('Tặng kèm', ColorApp.yellowD2),
            4.width,
            Text(
              '${listPromo[i].promotionItemData?[j].variantValueData?[0].variantData?.title.validator}',
              style: StyleApp.normal(
                fontSize: 12,
                color: ColorApp.grey79,
              ),
            ).expanded()
          ],
        ),
        4.height,
        Text(
          'SL: ${(listPromo[i].promotionItemData?[j].variantValueData?[0].quantity ?? 1) * (listPromo[i].promotionItemData?[j].quantitySelected ?? 1)}',
          style: StyleApp.semibold(
            fontSize: 12,
            color: ColorApp.grey79,
          ),
        ),
        8.height,
      ],
    ).padding(24.padingLeft + 4.padingBottom);
  }

  int get quantity {
    return (widget.variant.amount) +
        widget.variant.promotionDetail.fold(0, (total, promo) {
          final totalInPromo =
              promo.promotionItemData?.fold(0, (total_2, variantPromo) {
            return total_2 +
                (variantPromo.quantitySelected) *
                    (variantPromo.valueMin?.toInt() ?? 0);
          });
          return total + (totalInPromo ?? 0);
        });
  }

  _buildDetailPromo() {
    return Column(
      children: List.generate(listPromo.length, (i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IcSvg.asset('/ic_badge_per_v2.svg'),
                4.width,
                Text(
                  'CTKM: ${listPromo[i].title.validator}',
                  style: StyleApp.semibold(),
                ),
              ],
            ),
            ...List.generate(listPromo[i].promotionItemData?.length ?? 0, (j) {
              if (listPromo[i].promotionItemData?[j].quantitySelected == 0) {
                return Container();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  Text(
                    'Mua ${listPromo[i].promotionItemData?[j].valueMin?.round()} tặng ${listPromo[i].promotionItemData?[j].variantValueData?[0].quantity} ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.height,
                  RichText(
                    text: TextSpan(
                      text: 'Đơn giá: ',
                      style:
                          StyleApp.normal(fontSize: 12, color: ColorApp.grey79),
                      children: [
                        TextSpan(
                          text: '${FormatCurrency(widget.variant.price)} đ',
                          style: StyleApp.bold(color: ColorApp.main),
                        ),
                      ],
                    ),
                  ),
                  4.height,
                  _buildSPTK(i, j),
                ],
              );
            }),
          ],
        );
      }),
    ).padding(64.padingLeft);
  }
}
