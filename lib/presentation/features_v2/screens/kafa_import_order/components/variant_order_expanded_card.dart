import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/svg.dart';
import '../../../../shared/utils/event.dart';
import '../../../models/variant_kafa/promotion_kafa_model.dart';
import '../../../models/variant_kafa/variant_kafa_model.dart';
import 'text_in_container.dart';

class VariantOrderExpandedCard extends StatefulWidget {
  const VariantOrderExpandedCard({super.key, required this.variant});

  final VariantKafaModel variant;

  @override
  State<VariantOrderExpandedCard> createState() =>
      _VariantOrderExpandedCardState();
}

class _VariantOrderExpandedCardState extends State<VariantOrderExpandedCard> {
  late ExpandableController controller;

  List<PromotionDetailModel> listPromo = [];

  @override
  void initState() {
    controller = ExpandableController(initialExpanded: false)
      ..addListener(() => setState(() {}));
    listPromo = filterPromo(widget.variant.promotionDetail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: controller,
      theme: const ExpandableThemeData(hasIcon: false),
      header: Row(
        children: [
          const Divider(
            thickness: 1,
          ).expanded(),
          4.width,
          Text(
            'CTKM cho dịch vụ',
            style: StyleApp.bold(color: ColorApp.grey79),
          ),
          AnimatedRotation(
            turns: !controller.expanded ? 0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: ColorApp.grey79,
            ),
          ),
          const Divider(
            thickness: 1,
          ).expanded(),
        ],
      ),
      collapsed: Container(),
      expanded: Column(
        children: List.generate(listPromo.length, (i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IcSvg.asset('/ic_badge_per_v2.svg'),
                  4.width,
                  Text('CTKM: ${listPromo[i].title.validator}', style: StyleApp.semibold(),),
                ],
              ),
              ...List.generate(
                  listPromo[i].promotionItemData?.length ?? 0, (j) {
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
      ).padding(8.padingLeft),
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
          children: [
            TextInContainer('Tặng kèm', ColorApp.yellowD2),
            4.width,
            Text(
              '${listPromo[i].promotionItemData?[j].variantValueData?[0].variantData?.title.validator}',
              style: StyleApp.normal(
                fontSize: 12,
                color: ColorApp.grey79,
              ),
            )
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




}
