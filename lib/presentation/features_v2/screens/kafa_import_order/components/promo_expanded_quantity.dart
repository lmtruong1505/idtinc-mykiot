import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/components/text_in_container.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/color_app.dart';
import '../../../../../shared/style_app/style_text.dart';
import '../../../models/variant_kafa/promotion_kafa_model.dart';
import 'input_quantity_promotion.dart';

class PromoExpandedQuantity extends StatefulWidget {
  const PromoExpandedQuantity({
    super.key,
    required this.variantPromo,
    required this.variant,
    this.customerPromo,
    this.onChange,
  });

  final VariantKafaModel variant;
  final ConsumerDataModel? customerPromo;
  final PromotionItemDataModel variantPromo;
  final Function(PromotionItemDataModel, int)? onChange;

  @override
  State<PromoExpandedQuantity> createState() => _PromoExpandedQuantityState();
}

class _PromoExpandedQuantityState extends State<PromoExpandedQuantity> {
  late ExpandableController controller;
  final TextEditingController amountTec = TextEditingController();
  late PromotionItemDataModel _variantPromo;

  @override
  void initState() {
    amountTec.text = widget.variantPromo.quantitySelected.toString();
    _variantPromo = widget.variantPromo;
    controller = ExpandableController(initialExpanded: false)
      ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: controller,
      theme: const ExpandableThemeData(hasIcon: false),
      header: Container(
        padding: const EdgeInsets.all(16).copyWith(right: 0, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(8),
            bottom: Radius.circular(controller.expanded ? 0 : 8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.expanded
                ? IcSvg.asset('/minus_circle.svg').padding(2.padingTop)
                : IcSvg.asset('/add_circle.svg').padding(2.padingTop),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mua ${widget.variantPromo.valueMin?.round()} tặng ${widget.variantPromo.variantValueData?[0].quantity} ${widget.variantPromo.variantValueData?[0].variantData?.title.validator}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                )
              ],
            ).expanded(flex: 4),
            InputQuantityPromotion(
              amountTec: amountTec,
              item: _variantPromo,
              focusNode: FocusNode(),
              changeAmount: (variant, amount) {
                setState(() {
                  _variantPromo = variant.copyWith(quantitySelected: amount);
                  amountTec.text = amount.toString();
                  widget.onChange?.call(_variantPromo, _variantPromo.quantitySelected);
                });
              },
            ).expanded(flex: 2)
          ],
        ),
      ),
      collapsed: Container(),
      expanded: _buildSPTK(),
    );
  }

  // san pham tang kem
  Widget _buildSPTK() {
    // final totalVariantNotIncludePromoForConsumer =
    //     (widget.variantPromo.valueMin ?? 0) +
    //         widget.variantPromo.variantValueData!.fold(
    //           0,
    //           (previousValue, e) =>
    //               e.variantData?.id.validator == widget.variant.id
    //                   ? previousValue + e.quantity!
    //                   : previousValue,
    //         );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextInContainer('Tặng kèm', ColorApp.yellowD2),
            4.width,
            Text(
              '${widget.variantPromo.variantValueData?[0].variantData?.title.validator}',
              style: StyleApp.normal(
                fontSize: 12,
                color: ColorApp.grey79,
              ),
            )
          ],
        ),
        4.height,
        Text(
          'SL: ${widget.variantPromo.variantValueData?[0].quantity}',
          style: StyleApp.semibold(
            fontSize: 12,
            color: ColorApp.grey79,
          ),
        ),
        8.height,
        // if (widget.customerPromo?.id != null)
        //   Row(
        //     children: [
        //       _textInContainer('Khuyến mãi', ColorApp.redD7),
        //       4.width,
        //       Text(
        //         '${widget.customerPromo?.variantData?.title.validator}',
        //         style: StyleApp.normal(
        //           fontSize: 12,
        //           color: ColorApp.grey79,
        //         ),
        //       )
        //     ],
        //   ),
        // if (widget.customerPromo?.id != null)
        //   Text(
        //     'SL: ${totalVariantNotIncludePromoForConsumer ~/ (widget.customerPromo?.quantityBuy ?? 1) * (widget.customerPromo?.quantityBonus ?? 1)}',
        //     style: StyleApp.semibold(
        //       fontSize: 12,
        //       color: ColorApp.grey79,
        //     ),
        //   ),
      ],
    ).padding(36.padingLeft + 4.padingBottom);
  }


}
