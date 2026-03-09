import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/base/app_text.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/wholesale_drug_market/widget/drug_product_widget.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

PromotionData? getPrmDataActive(DrugProductModel? prd) {
  //tìm chương trình khuyến mãi thoả mãn(dựa vào datetime)

  //tìm chương trình khuyến mãi tổng đang thoả mãn đk

  return getNearestPromotion(prd?.product?.promotions ?? []);
}

PromotionItem? getPrmActive(DrugProductModel? prd) {
  // tìm chương trình khuyến mãi thoả mãn(dựa vào datetime)
  final PromotionData? prmSelect = getPrmDataActive(prd);

  return prmSelect?.promotionItems?.lastWhereOrNull(
    (prm) => (prd?.quantity ?? 0) >= (prm.valueRange ?? 0),
  );
}

PromotionItem? getPrmSuggest(DrugProductModel? prd) {
  // tìm chương trình khuyến mãi thoả mãn(dựa vào datetime)
  final PromotionData? prmSelect = getPrmDataActive(prd);

  return prmSelect?.promotionItems?.firstWhereOrNull(
    (prm) => (prd?.quantity ?? 0) < (prm.valueRange ?? 0),
  );
}

class DrugCartPrdItem extends StatelessWidget {
  DrugCartPrdItem({
    super.key,
    this.prd,
    required this.bloc,
    this.isConfirmPage = false,
  });
  final DrugProductModel? prd;
  final DrugCartBloc bloc;
  final bool isConfirmPage; // thêm logic ở màn xác nhận đơn thì k hiển thị,
  final delay = DelayCallBack(delay: 1.seconds);
  @override
  Widget build(BuildContext context) {
    print('=====DrugCartPrdItem');
    final detailPrd = prd?.product;

    //tìm chương trình khuyến mãi thoả mãn(dựa vào datetime)
    PromotionData? prmSelect;

    if (detailPrd?.promotions?.isNotEmpty == true) {
      prmSelect = getNearestPromotion(prd?.product?.promotions ?? []);
    }
    //tìm chương trình khuyến mãi con thoả mãn
    final prmItem = prmSelect?.promotionItems?.lastWhereOrNull(
      (prm) => (prd?.quantity ?? 0) >= (prm.valueRange ?? 0),
    );

    //tìm khuyến mãi sắp thoả mãn điều kiện khi mua
    final prmSuggest = prmSelect?.promotionItems?.firstWhereOrNull(
      (prm) => (prd?.quantity ?? 0) < (prm.valueRange ?? 0),
    );

    final addPrd = (prmSuggest?.valueRange ?? 0) - (prd?.quantity ?? 0);

    //dựa vào chương trình khuyến mãi thoả mãn ,tính số lần được nhận khuyến mãi chương trình con
    final numberOfPrm =
        ((prd?.quantity ?? 0) / (prmItem?.valueRange ?? 1)).floor();

    return Column(
      children: [
        _suggestPromotionItem(prmSuggest, addPrd),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Visibility(
                  visible: !isConfirmPage,
                  child: Row(
                    children: [
                      BaseCheckbox2(
                        value: prd?.isSelect,
                        onChanged: (value) {
                          bloc.onSelectPrd(prd!);
                        },
                      ),
                      8.width,
                    ],
                  ),
                ),
                BaseCacheImage(
                  url: detailPrd?.image ?? '',
                  borderRadius: 8.radius,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      detailPrd?.title ?? '',
                      style: s12w500,
                      maxLines: 2,
                    ),
                    4.height,
                    Text(
                      detailPrd?.code ?? '',
                      style: s10w400.copyWith(
                        color: AppColors.text_quaternary,
                      ),
                    ),
                    4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (detailPrd?.price).formatVND,
                          style: s14w700.copyWith(
                            color: AppColors.brand,
                          ),
                        ),
                        // const Spacer(),
                        Visibility(
                          visible: isConfirmPage,
                          child: Text(
                            'x${(prd?.quantity ?? 0).formatNumber}',
                            style: s10w400.copyWith(
                              color: AppColors.red60,
                            ),
                          ),
                        ),
                        // ChipCustom(
                        //   title: (detailPrd?.price ?? 0).formatVND,
                        //   color: AppColors.red60,
                        // ),
                      ],
                    ),
                    4.height,
                    Visibility(
                      visible: !isConfirmPage,
                      child: Row(
                        children: [
                          BaseContainer(
                            borderRadius: 4,
                            padding: 2.padingVer + 4.padingHor,
                            color: AppColors.brand,
                            child: FaIcon(
                              iconCode: 'f543',
                              color: AppColors.white,
                              type: FaIconType.solid,
                              size: 18,
                            ),
                          ),
                          4.width,
                          Visibility(
                            visible: detailPrd?.promotions?.isNotEmpty == true,
                            child: Row(
                              children: [
                                BaseContainer(
                                  borderRadius: 4,
                                  padding: 2.padingVer + 4.padingHor,
                                  color: AppColors.red60,
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        iconCode: 'f02b',
                                        color: AppColors.white,
                                        type: FaIconType.solid,
                                        size: 18,
                                      ),
                                      4.width,
                                      Text(
                                        'Khuyến mãi',
                                        style: s10w700.copyWith(
                                          color: AppColors.white,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                4.width,
                              ],
                            ),
                          ),
                          BaseContainer(
                            borderRadius: 4,
                            padding: 6.padingVer + 4.padingHor,
                            color: AppColors.blue60,
                            child: Row(
                              children: [
                                Text(
                                  'Deal sắp hết hạn',
                                  style: s10w700.copyWith(
                                    color: AppColors.white,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).expanded(),
              ],
            ),
            8.height,
            Visibility(
              visible: !isConfirmPage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showDetelePrdDialog(context),
                    child: FaIcon(
                      iconCode: 'f2ed',
                      type: FaIconType.light,
                    ).padding(4.padingHor),
                  ),
                  BaseContainer(
                    padding: 8.padingHor,
                    height: 30,
                    borderRadius: 4,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if ((prd?.quantity ?? 0) > 1) {
                              bloc.onMinus(prd!);
                            } else {
                              _showDetelePrdDialog(context);
                            }
                          },
                          child: FaIcon(
                            iconCode: 'f068',
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: QuantityInput(
                            textAlign: TextAlign.center,
                            onUpdate: (value) {
                              delay.debounce(
                                () {
                                  final parseQuantity =
                                      int.tryParse(value.removeAllDot()) ?? 1;
                                  final updateQuantity =
                                      parseQuantity > 0 ? parseQuantity : 1;
                                  bloc.onInput(prd!, updateQuantity);
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                            quantity: prd?.quantity ?? 0,
                          ),
                        ),
                        InkWell(
                          onTap: () => bloc.onAdd(prd!),
                          child: FaIcon(
                            iconCode: '2b',
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _promotionActiveItem(prmSelect, prmItem, numberOfPrm),
      ],
    );
  }

  Widget _promotionActiveItem(
    PromotionData? prmSelect,
    PromotionItem? prmItem,
    int numberOfPrm,
  ) {
    return (prd?.product?.promotions?.isNotEmpty == true &&
            prd?.isSelect == true &&
            prmItem != null)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: !isConfirmPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: 8.padingVer,
                      child: BaseContainer(
                        color: AppColors.bg_warningPrimary,
                        padding: 8.pading,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prmSelect?.title ?? '',
                              style: s12w500.copyWith(
                                height: 1,
                                color: AppColors.yellow60,
                              ),
                              maxLines: 2,
                            ),
                            4.height,
                            Text(
                              'Mua ${prmItem.valueRange.formatNumber} tặng ${prmItem.bonusVariantInfor?.firstOrNull?.quantity.formatNumber}',
                              style: s10w500.copyWith(
                                color: AppColors.red60,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text('Sản phẩm tặng kèm', style: s12w700),
                    8.height,
                  ],
                ),
              ),
              ListView.separated(
                padding: 12.padingBottom,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final bonus = prmItem.bonusVariantInfor?[index];
                  final variant = bonus?.variant;
                  return Row(
                    children: [
                      BaseCacheImage(
                        url: variant?.image ?? '',
                        width: 50,
                        height: 50,
                      ),
                      12.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(variant?.title ?? '', style: s12w500),
                          4.height,
                          Row(
                            children: [
                              Text(
                                0.formatVND,
                                style: s14w700.copyWith(color: AppColors.brand),
                              ),
                              4.width,
                              Text(
                                variant?.price.formatVND ?? '',
                                style: s10w400.copyWith(
                                  color: AppColors.fg_tertiary_onBrand,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'x${((bonus?.quantity ?? 0) * numberOfPrm).formatCurrency}',
                                style: s10w400.copyWith(color: AppColors.red60),
                              ),
                            ],
                          ),
                        ],
                      ).expanded(),
                    ],
                  );
                },
                separatorBuilder: (context, index) => 12.height,
                itemCount: prmItem.bonusVariantInfor?.length ?? 0,
              ),
            ],
          ).padding(32.padingLeft)
        : const SizedBox.shrink();
  }

  Visibility _suggestPromotionItem(PromotionItem? prmSuggest, num addPrd) {
    return Visibility(
      visible: prmSuggest != null &&
          !isConfirmPage, // thêm logic ở màn xác nhận đơn thì k hiển thị
      child: Padding(
        padding: 8.padingVer,
        child: BaseContainer(
          borderColor: AppColors.red10,
          padding: 8.padingHor + 4.padingVer,
          borderRadius: 4,
          color: AppColors.red10,
          child: Row(
            children: [
              FaIcon(
                iconCode: 'f02b',
                color: AppColors.red60,
                type: FaIconType.light,
                size: 14,
              ),
              12.width,
              Text.rich(
                TextSpan(
                  text: 'Mua thêm ',
                  style: s10w400.copyWith(
                    color: AppColors.text_secondary,
                    height: 1,
                  ),
                  children: [
                    TextSpan(
                      text: addPrd.formatNumber,
                      style: s10w700.copyWith(
                        color: AppColors.red60,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: ' để được khuyến mãi ',
                      style: s10w400.copyWith(
                        color: AppColors.text_secondary,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Mua ${prmSuggest?.valueRange.formatNumber} tặng ${prmSuggest?.bonusVariantInfor?.firstOrNull?.quantity.formatNumber}',
                      style: s10w700.copyWith(
                        color: AppColors.brand,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetelePrdDialog(BuildContext context) {
    context.dialog(
      DialogConfirm(
        icon: IconDiaLog(
          color: AppColors.fg_warning.withOpacity(0.1),
          icon: FaIcon(
            iconCode: 'f071',
            color: AppColors.fg_warning,
            type: FaIconType.solid,
          ),
        ),
        title: 'Xác nhận',
        content: const AppText(
          'Bạn có chắc muốn xóa sản phẩm này ra khỏi giỏ hàng?',
          maxLines: 2,
          style: s14w400,
          textAlign: TextAlign.center,
        ),
        confirm: () {
          context.pop();
          bloc.deletePrds(deletePrds: [prd!]);
        },
      ),
    );
  }
}

PromotionData? getNearestPromotion(List<PromotionData>? promotions) {
  final now = DateTime.now();
  List.of(promotions ?? []).sort(
    (a, b) {
      final dateA = a.endDate ?? now;
      final dateB = b.endDate ?? now;
      return dateA.compareTo(dateB);
    },
  );
  return promotions?.firstOrNull;
}
