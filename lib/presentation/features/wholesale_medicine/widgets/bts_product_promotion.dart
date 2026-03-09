import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../base/check_box.dart';
import '../../../base/loading.dart';
import '../../../base/row_item.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../cubit/promotion_select_cubit/promotion_select_cubit.dart';
import '../cubit/promotion_select_cubit/promotion_select_state.dart';
import '../domain/entities/promotion_detail_wm_entity.dart';

class BtsProductPromotionView extends StatefulWidget {
  const BtsProductPromotionView({
    super.key,
    required this.promotionApplyOrderCubit,
    required this.idPromo,
  });

  final PromotionSelectCubit promotionApplyOrderCubit;
  final int idPromo;

  @override
  State<BtsProductPromotionView> createState() =>
      _BtsProductPromotionViewState();
}

class _BtsProductPromotionViewState extends State<BtsProductPromotionView> {
  late PromotionDetailEntity? promotion;

  @override
  void initState() {
    super.initState();
    promotion =
        widget.promotionApplyOrderCubit.state.promotionDetail?.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked:(didPop) => false,
      child: Stack(
        children: [
          BlocBuilder<PromotionSelectCubit, PromotionSelectState>(
            bloc: widget.promotionApplyOrderCubit,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(sp16).copyWith(
                  top: sp48 + sp16,
                ),
                decoration: const BoxDecoration(
                  color: bg_4,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(sp12),
                  ),
                ),
                width: double.infinity,
                height: heightDevice(context) * 0.9,
                child: state.isLoadingBts
                    ? const BaseLoading()
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final item =
                              state.promotionDetail?.promotionItemData?[index];
                          return Container(
                            padding: const EdgeInsets.all(sp16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp12),
                              border: Border.all(color: borderColor_2),
                              color: whiteColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.promotionApplyOrderCubit.state
                                              .typePromotion ==
                                          TypePromotion.product
                                      ? 'Từ ${item?.valueMin?.round()} sản phẩm'
                                      : 'Từ ${FormatCurrency(item?.valueMin?.round())} VNĐ',
                                  style: h6.copyWith(color: blackColor),
                                ),
                                const SizedBox(height: sp16),
                                (item?.groupVariantData.isEmpty ?? false)
                                    ? item?.typeDiscount == null
                                        ? _promotionVariantView(item!)
                                        : _promotionGroupDiscountView(item!)
                                    : _promotionGroupVariantView(
                                        item?.groupVariantData ?? [],
                                        item?.id ?? 0,
                                      ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: sp16,
                        ),
                        itemCount:
                            state.promotionDetail?.promotionItemData?.length ??
                                0,
                      ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: sp12, horizontal: sp16),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          widget.promotionApplyOrderCubit
                              .cancelBSTChangeQuantitySelected(promotion);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Huỷ',
                          style: p5.copyWith(color: blackColor),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (!widget.promotionApplyOrderCubit
                              .validateQuantity()) {
                            return;
                          }
                          widget.promotionApplyOrderCubit
                              .confirmProductForPromotion();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Xác nhận',
                          style: p5.copyWith(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<PromotionSelectCubit,
                      PromotionSelectState>(
                    bloc: widget.promotionApplyOrderCubit,
                    builder: (context, state) {
                      return Visibility(
                        visible: state.messageErr != null,
                        child: Column(
                          children: [
                            const SizedBox(height: sp12),
                            Text(
                              state.messageErr ?? '',
                              style: p5.copyWith(color: red_1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promotionGroupVariantView(
    List<GroupVariantItemEntity> value,
    int idPromoItem,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = value[index];
        final amountTec = TextEditingController(
          text: item.amount.toString(),
        );
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: item.amount != 0 ? mainColor : borderColor_2,
            ),
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  color: bg_4.withOpacity(0.75),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(sp12),
                  ),
                ),
                child: Row(
                  children: [
                    BaseCheckbox(
                      value: item.amount != 0,
                      onChanged: (value) {},
                    ),
                    const SizedBox(width: sp16),
                    Text(
                      'Gói quà tặng $index',
                      style: h6.copyWith(color: blackColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(sp16).copyWith(bottom: sp0),
                child: Column(
                  children: (item.variantValue ?? []).map((e) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: sp16),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(sp12),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: BaseCacheImage(
                                  url: e.variant?.image ??
                                      PrefKeys.imgProductDefault,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              e.variant?.title ?? '',
                              style: p5.copyWith(
                                color: blackColor,
                              ),
                            ),
                            subtitle: Text(
                              e.variant?.code ?? '',
                              style: p6.copyWith(
                                color: blackColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: sp8),
                          RowItem(
                            title: 'Số lượng',
                            content: e.quantity.toString(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  color: accentColor_4.withOpacity(0.5),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(sp12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Số lượng áp dụng',
                      style: p6.copyWith(color: blackColor),
                    ),
                    const SizedBox(width: 70),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          AppInput(
                            controller: amountTec,
                            textInputType: TextInputType.number,
                            hintText: 'Nhập số lượng',
                            validate: (value) {},
                            textAlign: TextAlign.center,
                            onChanged: (value) {},
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                6,
                              ),
                            ],
                            backgroundColor: whiteColor,
                            //  widget.promotionApplyOrderCubit
                            //             .state.promotionDetail?.manyTime ==
                            //         true
                            //     ? whiteColor
                            //     : bg_4,
                            readOnly: true,
                          ),
                          Positioned(
                            bottom: sp16,
                            left: sp16,
                            child: InkWell(
                              onTap: () {
                                widget.promotionApplyOrderCubit
                                    .changeAmountApply(
                                  idPromoItem: idPromoItem,
                                  quantity: item.amount - 1,
                                  idGroupVariantItem: item.id,
                                );
                              },
                              child: const Icon(
                                Icons.remove,
                                size: sp16,
                                color: borderColor_4,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: sp16,
                            right: sp16,
                            child: InkWell(
                              onTap: () {
                                widget.promotionApplyOrderCubit
                                    .changeAmountApply(
                                  idPromoItem: idPromoItem,
                                  quantity: widget
                                              .promotionApplyOrderCubit
                                              .state
                                              .promotionDetail
                                              ?.manyTime ==
                                          false
                                      ? 1
                                      : item.amount + 1,
                                  idGroupVariantItem: item.id,
                                );
                              },
                              child: const Icon(
                                Icons.add,
                                size: sp16,
                                color: borderColor_4,
                              ),
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
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: sp16),
      itemCount: value.length,
    );
  }

  Widget _promotionGroupDiscountView(
    PromotionItemDataEntity value,
  ) {
    final amountTec = TextEditingController(
      text: value.quantitySelected.toString(),
    );
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: bg_4.withOpacity(0.75),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(sp12),
            ),
          ),
          child: RowItem(
            title: 'Giá trị khuyến mãi',
            content:
                '${FormatCurrency(value.discountValue)}${value.typeDiscount == 1 ? 'đ' : '%'}',
          ),
        ),
        Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: accentColor_4.withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(sp12),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Số lượng áp dụng',
                style: p6.copyWith(color: blackColor),
              ),
              const SizedBox(width: 70),
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    AppInput(
                      controller: amountTec,
                      textInputType: TextInputType.number,
                      hintText: 'Nhập số lượng',
                      validate: (value) {},
                      textAlign: TextAlign.center,
                      onChanged: (value) {},
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          6,
                        ),
                      ],
                      backgroundColor: whiteColor,
                      //  widget.promotionApplyOrderCubit
                      //             .state.promotionDetail?.manyTime ==
                      //         true
                      //     ? whiteColor
                      //     : bg_4,
                      readOnly: true,
                    ),
                    Positioned(
                      bottom: sp16,
                      left: sp16,
                      child: InkWell(
                        onTap: () {
                          widget.promotionApplyOrderCubit.changeAmountApply(
                            idPromoItem: value.id ?? 0,
                            quantity: value.quantitySelected - 1,
                          );
                        },
                        child: const Icon(
                          Icons.remove,
                          size: sp16,
                          color: borderColor_4,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: sp16,
                      right: sp16,
                      child: InkWell(
                        onTap: () {
                          widget.promotionApplyOrderCubit.changeAmountApply(
                            idPromoItem: value.id ?? 0,
                            quantity: widget.promotionApplyOrderCubit.state
                                        .promotionDetail?.manyTime ==
                                    false
                                ? 1
                                : value.quantitySelected + 1,
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          size: sp16,
                          color: borderColor_4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _promotionVariantView(
    PromotionItemDataEntity item,
  ) {
    final amountTec = TextEditingController(
      text: item.quantitySelected.toString(),
    );
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(sp16),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final ele = item.variantValueData?[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(sp12),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: BaseCacheImage(
                            url: ele?.image ?? PrefKeys.imgProductDefault,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: sp16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ele?.title ?? '',
                              style: p5.copyWith(
                                color: blackColor,
                              ),
                            ),
                            const SizedBox(height: sp12),
                            Text(
                              '${FormatCurrency((ele?.priceSell?.round() ?? 0))}đ',
                              style: p5.copyWith(
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: sp12),
                  RowItem(
                    title: 'Số lượng',
                    titleColor: greyColor,
                    content: '${ele?.quantity ?? 0}',
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: item.variantValueData?.length ?? 0,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(sp16),
          color: yellow_2.withOpacity(0.5),
          child: Row(
            children: [
              Text(
                'Số lượng áp dụng',
                style: p6.copyWith(color: blackColor),
              ),
              const SizedBox(width: 70),
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    AppInput(
                      controller: amountTec,
                      textInputType: TextInputType.number,
                      hintText: 'Nhập số lượng',
                      validate: (value) {},
                      textAlign: TextAlign.center,
                      onChanged: (value) {},
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          6,
                        ),
                      ],
                      backgroundColor: bg_4,
                      readOnly: true,
                    ),
                    Positioned(
                      bottom: sp16,
                      left: sp16,
                      child: InkWell(
                        onTap: () {
                          widget.promotionApplyOrderCubit.changeAmountApply(
                            idPromoItem: item.id ?? 0,
                            quantity: item.quantitySelected - 1,
                          );
                        },
                        child: const Icon(
                          Icons.remove,
                          size: sp16,
                          color: borderColor_4,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: sp16,
                      right: sp16,
                      child: InkWell(
                        onTap: () {
                          widget.promotionApplyOrderCubit.changeAmountApply(
                            idPromoItem: item.id ?? 0,
                            quantity: widget.promotionApplyOrderCubit.state
                                        .promotionDetail?.manyTime ==
                                    false
                                ? 1
                                : item.quantitySelected + 1,
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          size: sp16,
                          color: borderColor_4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
