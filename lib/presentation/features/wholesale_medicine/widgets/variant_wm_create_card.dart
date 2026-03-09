import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/variant_wm_entity.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../base/check_box.dart';
import '../../../base/row_item.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';
import '../domain/entities/promotion_detail_wm_entity.dart';

class VariantWmCreateCard extends StatefulWidget {
  const VariantWmCreateCard({
    super.key,
    required this.variant,
    this.quantityChange,
    this.quantityGiftChange,
    this.toggleCheckbox,
    this.priceSellChange,
    this.onConfirmPromo,
    this.onDeletePromo,
    this.onSelect,
    this.onDelete,
    this.onPromoItemChangeQuantity,
    this.typeCreate = TypeCreateOrder.byProduct,
    this.canEdit = true,
  });

  final VariantWmEntity variant;
  final Function(VariantWmEntity variant, int value)? quantityChange;
  final Function(VariantWmEntity variant, int value)? quantityGiftChange;
  final Function(VariantWmEntity variant, String value)? priceSellChange;
  final Function(bool? value)? toggleCheckbox;
  final Function(List<PromotionDetailEntity>? value)? onConfirmPromo;
  final Function(int idPromo)? onDeletePromo;
  final Function(int variantId)? onSelect;
  final Function(int variantId)? onDelete;
  final Function(
    BuildContext context, {
    required int idVariant,
    required int idPromo,
    required int idPromoItem,
    required bool isPlus,
  })? onPromoItemChangeQuantity;
  final TypeCreateOrder typeCreate;
  final bool canEdit;

  @override
  State<VariantWmCreateCard> createState() => _VariantWmCreateCardState();
}

class _VariantWmCreateCardState extends State<VariantWmCreateCard> {
  late TextEditingController amountTec;
  late TextEditingController amountGiftTec;
  late TextEditingController priceSellTec;
  late FocusNode amountFn;
  late ExpandableController _expandableController;
  late ExpandableController _expandable2Controller;
  // int _timeApplyPromo = 0;

  @override
  void initState() {
    super.initState();
    amountTec = TextEditingController(
      text: (widget.variant.amountRetail).toString(),
    );
    amountGiftTec = TextEditingController(
      text: widget.variant.amountRetail.toString(),
    );
    priceSellTec = TextEditingController(
      text: widget.variant.priceSell.toString(),
    );
    amountFn = FocusNode()
      ..addListener(() {
        if (!amountFn.hasFocus && amountTec.text.isEmpty) {
          widget.quantityChange?.call(
            widget.variant,
            1,
          );
          setState(() {
            amountTec.text = '1';
          });
        }
      });

    _expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    _expandable2Controller = ExpandableController(initialExpanded: false)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant.amountRetail != int.parse(amountTec.text) ||
        widget.variant.amount != int.parse(amountTec.text)) {
      setState(() {
        amountTec.text = (widget.variant.amountRetail).toString();
      });
    }

    if (widget.variant.amountGift != int.parse(amountGiftTec.text)) {
      setState(() {
        amountGiftTec.text = widget.variant.amountGift.toString();
      });
    }

    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(
          color: widget.variant.isChoose ? mainColor : whiteColor,
        ),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Visibility(
                visible: widget.typeCreate == TypeCreateOrder.byPromotion,
                child: Container(
                  margin: const EdgeInsets.only(right: sp16),
                  child: BaseCheckbox(
                    value: widget.variant.isChoose,
                    // onChanged:(value) {
                    //   widget.toggleCheckbox?.call(value);

                    // },
                    onChanged: (value) {
                      if (widget.variant.id == null) return;
                      widget.onSelect?.call(widget.variant.id!);
                      _expandableController.expanded = value ?? false;
                      setState(() {});
                    },
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp8),
                  border: Border.all(color: borderColor_2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sp8),
                  child: BaseCacheImage(
                    url: widget.variant.image ?? PrefKeys.imgProductDefault,
                  ),
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.variant.title,
                            style: p5.copyWith(color: blackColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: sp12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${FormatCurrency(widget.variant.priceSellUnit)}đ',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: sp16),
              Visibility(
                visible: widget.typeCreate == TypeCreateOrder.byProduct &&
                    widget.onDelete != null,
                child: InkWell(
                  onTap: () => widget.onDelete?.call(widget.variant.id!),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: red_1,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: widget.variant.isChoose,
            child: Column(
              children: [
                const SizedBox(
                  height: sp16,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Mua lẻ',
                        style: p5.copyWith(color: blackColor),
                      ),
                    ),
                    // -------- input quantity ---------
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          AppInput(
                            controller: amountTec,
                            textInputType: TextInputType.number,
                            hintText: 'Nhập số lượng',
                            validate: (value) {},
                            textAlign: TextAlign.center,
                            onChanged: (value) => widget.quantityChange?.call(
                              widget.variant,
                              int.parse(value),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            backgroundColor: bg_4,
                            borderColor: bg_4,
                            // padding: const EdgeInsets.all(sp4),
                            // radius: sp32,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () {
                                if (widget.variant.amountRetail == 0) return;
                                widget.quantityChange?.call(
                                  widget.variant,
                                  widget.variant.amountRetail - 1,
                                );
                                amountTec.text =
                                    '${widget.variant.amountRetail - 1}';
                                context.unFocus();
                              },
                              child: const SizedBox(
                                height: 46,
                                width: 46,
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    size: sp16,
                                    color: borderColor_4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                widget.quantityChange?.call(
                                  widget.variant,
                                  widget.variant.amountRetail + 1,
                                );
                                amountTec.text =
                                    '${widget.variant.amountRetail + 1}';
                                context.unFocus();
                              },
                              child: const SizedBox(
                                height: 46,
                                width: 46,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    size: sp16,
                                    color: borderColor_4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.variant.promotionDetailEntity != null &&
                widget.variant.isChoose,
            child: const Divider(
              height: sp24,
            ),
          ),
          Visibility(
            visible: widget.variant.promotionDetailEntity != null &&
                widget.variant.isChoose,
            child: ExpandablePanel(
              controller: _expandableController,
              theme: const ExpandableThemeData(hasIcon: false),
              header: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: sp16,
                  vertical: sp12,
                ),
                decoration: BoxDecoration(
                  color: bg_4,
                  borderRadius: BorderRadius.circular(sp8),
                ),
                margin: const EdgeInsets.only(bottom: sp4),
                child: Row(
                  children: [
                    Text(
                      'Chương trình khuyến mãi',
                      style: p6.copyWith(color: pink_1),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: _expandableController.expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              collapsed: const SizedBox(),
              expanded: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final promo = widget.variant.promotionDetailEntity?[index];
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variantPromo = promo?.promotionItemData?[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: pink_2,
                          borderRadius: BorderRadius.circular(sp8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(sp12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Khuyến mãi sản phẩm mua ${variantPromo?.valueMin?.round()} tặng ${variantPromo?.variantValueData?[0].quantity} ${variantPromo?.variantValueData?[0].variant != widget.variant.id ? (variantPromo?.variantValueData?[0].title) : ''}',
                                    style: p7.copyWith(
                                      color: pink_1,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: sp8),
                                  Row(
                                    children: [
                                      Text(
                                        'Đơn giá: ',
                                        style: p6.copyWith(
                                          color: blackColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${FormatCurrency(widget.variant.priceSellUnit)}đ',
                                          style: h6.copyWith(
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            AppInput(
                                              controller: TextEditingController(
                                                text: variantPromo
                                                    ?.quantitySelected
                                                    .toString(),
                                              ),
                                              textInputType:
                                                  TextInputType.number,
                                              hintText: 'Nhập số lượng',
                                              validate: (value) {},
                                              textAlign: TextAlign.center,
                                              readOnly: true,
                                              onChanged: (value) =>
                                                  widget.quantityChange?.call(
                                                widget.variant,
                                                int.parse(value),
                                              ),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                  6,
                                                ),
                                              ],
                                              backgroundColor: whiteColor,
                                              borderColor: whiteColor,
                                              // padding: const EdgeInsets.all(
                                              //   sp4,
                                              // ),
                                              // radius: sp32,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  widget
                                                      .onPromoItemChangeQuantity!(
                                                    context,
                                                    idVariant:
                                                        widget.variant.id ?? 0,
                                                    idPromo: promo?.id ?? 0,
                                                    idPromoItem:
                                                        variantPromo?.id ?? 0,
                                                    isPlus: false,
                                                  );
                                                  context.unFocus();
                                                },
                                                child: const SizedBox(
                                                  height: 46,
                                                  width: 46,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: sp16,
                                                      color: borderColor_4,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  widget
                                                      .onPromoItemChangeQuantity!(
                                                    context,
                                                    idVariant:
                                                        widget.variant.id ?? 0,
                                                    idPromo: promo?.id ?? 0,
                                                    idPromoItem:
                                                        variantPromo?.id ?? 0,
                                                    isPlus: true,
                                                  );
                                                  context.unFocus();
                                                },
                                                child: const SizedBox(
                                                  height: 46,
                                                  width: 46,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      size: sp16,
                                                      color: borderColor_4,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: whiteColor,
                              height: 1,
                              thickness: 1,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final variant =
                                    variantPromo?.variantValueData?[index];
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(sp8),
                                    child: SizedBox(
                                      height: sp48,
                                      width: sp48,
                                      child: BaseCacheImage(
                                        url: variant?.image ??
                                            PrefKeys.imgProductDefault,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    variant?.title ?? 'Chưa có thông tin',
                                    style: p5.copyWith(color: blackColor),
                                  ),
                                  subtitle: Text(
                                    variant?.code ?? '',
                                    style: p7.copyWith(color: greyColor),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: whiteColor,
                                  height: sp24,
                                );
                              },
                              itemCount:
                                  variantPromo?.variantValueData?.length ?? 0,
                            ),
                            const Divider(
                              color: whiteColor,
                              height: 1,
                              thickness: 1,
                            ),
                            Visibility(
                              visible: promo?.consumerData?.id != null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: sp12,
                                ),
                                margin: const EdgeInsets.only(
                                  top: sp12,
                                  bottom: sp12,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'KM người tiêu dùng: ',
                                    style: p7.copyWith(
                                      color: pink_1,
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${variantPromo?.gifForOneApply} sản phẩm ',
                                        style: p8.copyWith(
                                          color: mainColor,
                                          height: 1.4,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${promo?.consumerData?.variantTitle}',
                                        style: p9.copyWith(
                                          color: greyColor,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: sp4),
                    itemCount: promo?.promotionItemData?.length ?? 0,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: sp4),
                itemCount: widget.variant.promotionDetailEntity?.length ?? 0,
              ),
            ),
          ),
          Visibility(
            visible: widget.variant.promotionDetailEntity != null &&
                widget.variant.isChoose,
            child: ExpandablePanel(
              controller: _expandable2Controller,
              theme: const ExpandableThemeData(hasIcon: false),
              header: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: sp16,
                  vertical: sp12,
                ),
                margin: const EdgeInsets.only(top: sp8),
                decoration: BoxDecoration(
                  color: bg_4,
                  borderRadius: BorderRadius.circular(sp12),
                ),
                child: Row(
                  children: [
                    Text(
                      'Sản phẩm tặng kèm',
                      style: p6.copyWith(color: pink_1),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: _expandable2Controller.expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              collapsed: const SizedBox(),
              expanded: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final promo =
                          widget.variant.promotionDetailEntity?[index];
                      return Container(
                        margin: EdgeInsets.only(top: index == 0 ? sp16 : sp0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    promo?.title ?? '',
                                    style: h6.copyWith(color: blackColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: sp8),
                            Visibility(
                              visible: promo?.consumerData?.id != null,
                              child: RowItem(
                                titleStyle: p9.copyWith(
                                  color: greyColor,
                                  height: 1.4,
                                ),
                                title:
                                    'KM người tiêu dùng:\n${promo?.consumerData?.variantTitle}',
                                content:
                                    '${(promo?.consumerData?.quantityBonus ?? 0) * (promo?.consumerData?.numOfApplications ?? 0)}',
                                contetnStyle: p3.copyWith(color: mainColor),
                              ),
                            ),
                            Visibility(
                              visible: promo?.consumerData?.id != null,
                              child: const SizedBox(height: sp24),
                            ),
                            //body
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final variantPromo =
                                    promo?.promotionItemData?[index];
                                return Visibility(
                                  visible: variantPromo?.quantitySelected != 0,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final varianData = variantPromo
                                          ?.variantValueData?[index];
                                      return Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(sp12),
                                            child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: BaseCacheImage(
                                                url: varianData?.image ??
                                                    PrefKeys.imgProductDefault,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: sp16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  varianData?.title ?? '',
                                                  style: p5.copyWith(
                                                    color: blackColor,
                                                  ),
                                                ),
                                                const SizedBox(height: sp8),
                                                Text(
                                                  'Chương trình từ: ${variantPromo?.valueMin?.round()} sản phẩm',
                                                  style: p7.copyWith(
                                                    color: yellow_1,
                                                  ),
                                                ),
                                                const SizedBox(height: sp8),
                                                RowItem(
                                                  titleStyle: p7.copyWith(
                                                    color: greyColor,
                                                  ),
                                                  title: 'Số lượng',
                                                  content:
                                                      '${(variantPromo?.quantitySelected ?? 0) * (varianData?.quantity ?? 0)}',
                                                  contetnStyle: p3.copyWith(
                                                    color: mainColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: sp16),
                                    itemCount: variantPromo
                                            ?.variantValueData?.length ??
                                        0,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                final variantPromo =
                                    promo?.promotionItemData?[index + 1];
                                return Visibility(
                                  visible: variantPromo?.quantitySelected != 0,
                                  child: const Divider(
                                    height: sp32,
                                  ),
                                );
                              },
                              itemCount: promo?.promotionItemData?.length ?? 0,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: sp32,
                    ),
                    itemCount:
                        widget.variant.promotionDetailEntity?.length ?? 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
