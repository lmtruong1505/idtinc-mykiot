import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/promotion_kafa_model.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/components/custom_icon.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/components/input_quantity.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/svg.dart';
import 'promo_expanded_quantity.dart';

class BtsQuantityVariant extends StatefulWidget {
  const BtsQuantityVariant({super.key, required this.variant, this.onConfirm});

  final VariantKafaModel variant;
  final Function(VariantKafaModel)? onConfirm;

  @override
  State<BtsQuantityVariant> createState() => _BtsQuantityVariantState();
}

class _BtsQuantityVariantState extends State<BtsQuantityVariant> {
  late VariantKafaModel _variant;

  final TextEditingController amountTec = TextEditingController();

  @override
  void initState() {
    _variant = widget.variant;
    amountTec.text = _variant.amount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightDevice(context) / 1.5,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 32.radiusTop,
      ),
      padding: 16.padingHor + 24.padingVer,
      child: Scaffold(
        backgroundColor: ColorApp.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRetailInfo(),
              8.height,
              _buildDivider(),
              8.height,
              ...List.generate(_variant.promotionDetail.length, (index) {
                return _buldPromotion(
                  _variant.promotionDetail[index],
                  index,
                ).padding(4.padingBottom);
              }),
            ],
          ),
        ),
        bottomNavigationBar: MainButton(
          title: 'Xác nhận',
          event: () {
            widget.onConfirm?.call(_variant);
            Navigator.pop(context);
          },
          radius: 999,
        ),
      ),
    );
  }

  _buildRetailInfo() {
    return Row(
      children: [
        customIcon(icon: const Icon(Icons.shopping_cart_checkout)),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mua lẻ',
              style: StyleApp.semibold(
                color: ColorApp.grey79,
                fontSize: 12,
              ),
            ),
            Text(
              '${FormatCurrency(widget.variant.price)} đ',
              style: StyleApp.bold(
                color: ColorApp.main,
                fontSize: 12,
              ),
            ),
          ],
        ).expanded(flex: 3),
        InputQuantity(
          amountTec: amountTec,
          item: _variant,
          focusNode: FocusNode(),
          changeAmount: (variant, amount) {
            setState(() {
              _variant = variant.copyWith(amount: amount);
              amountTec.text = amount.toString();
            });
          },
        ).flexible(flex: 2),
      ],
    );
  }

  _buildDivider() {
    return Row(
      children: [
        const Divider().expanded(),
        8.width,
        Text(
          'CTKM cho sản phẩm',
          style: StyleApp.semibold(
            fontSize: 12,
            color: ColorApp.grey79,
          ),
        ),
        8.width,
        const Divider().expanded(),
      ],
    );
  }

  Widget _buldPromotion(PromotionDetailModel promo, int idxPromo) {
    return Column(
      children: [
        Row(
          children: [
            IcSvg.asset("/ic_badge_per_v2.svg"),
            4.width,
            Text('CTKM: ${promo.title.validator}', style: StyleApp.semibold(),),
          ],
        ),
        ...List.generate(promo.promotionItemData?.length ?? 0, (idxVariantPromo) {
          return PromoExpandedQuantity(
            variant: _variant,
            customerPromo: promo.consumerData,
            variantPromo: promo.promotionItemData![idxVariantPromo],
            onChange: (variantPromo, amount) {
              updateQuantityPromotion(idxPromo, idxVariantPromo, amount);
            },
          );
        }),
      ],
    );
  }

  void updateQuantityPromotion(int idxPromo, int idxVariantPromo, int quantity){
    final listPromo = List<PromotionDetailModel>.from(_variant.promotionDetail);
    var promo = listPromo[idxPromo];
    final listVariantPromo = List<PromotionItemDataModel>.from(promo.promotionItemData!);
    var variantPromo = listVariantPromo[idxVariantPromo];
    variantPromo = variantPromo.copyWith(quantitySelected: quantity);
    listVariantPromo[idxVariantPromo] = variantPromo;
    promo = promo.copyWith(promotionItemData: listVariantPromo);
    listPromo[idxPromo] = promo;
    setState(() {
      _variant = _variant.copyWith(promotionDetail: listPromo);
    });
  }
}
