import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_bar.dart';
import '../../../base/check_box.dart';
import '../../../base/dialog.dart';
import '../../../base/popup_noti.dart';
import '../../../base/row_item.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_cubit.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';
import '../domain/entities/variant_wm_entity.dart';

@RoutePage()
class OrderWmCreatePreviewPage extends StatelessWidget {
  const OrderWmCreatePreviewPage({
    super.key,
    required this.cubit,
    this.onConfirm,
  });

  final OrderWmCreateCubit cubit;
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bg_5,
          appBar: const BaseAppBar(title: 'Xác nhận đơn hàng'),
          body: Container(
            height: heightDevice(context),
            width: widthDevice(context),
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(sp16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      color: whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowItem(
                          title: 'Tổng tiền',
                          titleStyle: p5.copyWith(color: borderColor_4),
                          content: '${FormatCurrency(state.totalPrice)} đ',
                        ),
                        const SizedBox(height: sp12),
                        RowItem(
                          title: 'Giá trị CTKM',
                          titleStyle: p5.copyWith(color: borderColor_4),
                          content: '${FormatCurrency(state.totalPricePromo)} đ',
                        ),
                        const Divider(height: sp32),
                        RowItem(
                          title: 'Khách phải trả',
                          titleStyle: p5.copyWith(color: borderColor_4),
                          content:
                              '${FormatCurrency(state.totalPrice - state.totalPriceDiscount)} đ',
                          contetnStyle: p1.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: sp16),
                  Container(
                    padding: const EdgeInsets.all(sp16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      color: whiteColor,
                    ),
                    child: Row(
                      children: [
                        BaseCheckbox(
                          value: state.selectedOrderRed,
                          onChanged: (value) => cubit.selectedOrderRedChange(),
                        ),
                        const SizedBox(width: sp12),
                        Text(
                          'Hoá đơn đỏ',
                          style: p5.copyWith(color: blackColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: sp24),
                  AppInput(
                    label: 'Ghi chú đơn hàng',
                    hintText: 'Nhập ghi chú',
                    validate: (value) {},
                    maxLines: 5,
                    backgroundColor: whiteColor,
                    onChanged: (value) => cubit.noteChange(value),
                  ),
                  const SizedBox(height: sp24),
                  Text(
                    'Danh sách sản phẩm (${state.listVariantSelect.where((e) => e.isChoose).toList().length})',
                    style: p3.copyWith(color: blackColor),
                  ),
                  const SizedBox(height: sp16),
                  const RowItemCardProductConfirmOrder(
                    title: 'Sản phẩm',
                    amount: 'Số lượng',
                    total: 'Thành tiền',
                    style: p6,
                    color: borderColor_4,
                  ),
                  const SizedBox(height: sp24),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variant = state.listVariantSelect
                          .where((e) => e.isChoose)
                          .toList()[index];
                      return CardProductConfirmOrder(variant: variant);
                      // VariantCreateOrderConfirmCard(
                      //   variant: variant,
                      //   canEdit: false,
                      // );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(height: sp24),
                    itemCount: state.listVariantSelect
                        .where((e) => e.isChoose)
                        .toList()
                        .length,
                  ),
                  const Divider(height: sp32),
                  Text(
                    'Sản phẩm tặng kèm (khuyến mãi đơn hàng)',
                    style: p6.copyWith(color: borderColor_4),
                  ),
                  const SizedBox(height: sp12),
                  // Promo
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = cubit.convertPromotionForOrder[index];
                      // Promo Item
                      return RowItemCardProductConfirmOrder(
                        title: item.variantData?.title ?? '',
                        amount: '${item.quantity}',
                        total: '0đ',
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: sp12,
                    ),
                    itemCount: cubit.convertPromotionForOrder.length,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variant = state.listVariantSelect
                          .where((e) => e.amountGift != 0)
                          .toList()[index];
                      return RowItemCardProductConfirmOrder(
                        title: variant.title,
                        amount: variant.amountGift.toString(),
                        total: '0đ',
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: sp12,
                    ),
                    itemCount: state.listVariantSelect
                        .where((e) => e.amountGift != 0)
                        .toList()
                        .length,
                  ),

                  // PromoItem for Customer (CTKM người tiêu dùng)
                  const Divider(height: sp32),
                  Text(
                    'Sản phẩm tặng cho người tiêu dùng',
                    style: p6.copyWith(color: borderColor_4),
                  ),
                  const SizedBox(height: sp12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variant = state.listVariantSelect
                          .where((e) => e.isChoose && e.amount != 0)
                          .toList()[index];
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final promo = variant.promotionDetailEntity
                              ?.where(
                                (e) => e.consumerData?.numOfApplications > 0,
                              )
                              .toList()[index];
                          return Visibility(
                            visible: promo?.consumerData?.id != null,
                            child: RowItemCardProductConfirmOrder(
                              title: promo?.consumerData?.variantTitle ?? '',
                              amount: ((promo?.consumerData
                                              ?.numOfApplications ??
                                          0) *
                                      (promo?.consumerData?.quantityBonus ?? 0))
                                  .toString(),
                              total: '0đ',
                              style: p5,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(height: sp24),
                        itemCount: variant.promotionDetailEntity
                                ?.where(
                                  (e) => e.consumerData?.numOfApplications > 0,
                                )
                                .toList()
                                .length ??
                            0,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(height: sp24),
                    itemCount: state.listVariantSelect
                        .where((e) => e.isChoose && e.amount != 0)
                        .toList()
                        .length,
                  ),

                  // PromoItem for Customer (CTKM người tiêu dùng)
                  const Divider(height: sp32),
                  Text(
                    'Giảm giá đơn hàng',
                    style: p6.copyWith(color: borderColor_4),
                  ),
                  const SizedBox(height: sp12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final promo = cubit.promoOrderDiscount[index];
                      return RowItemCardProductConfirmOrder(
                        title:
                            'Giá trị tối thiểu ${FormatCurrency(promo.minValueAplly)}đ',
                        amount: promo.timesApplyPromotion.toString(),
                        total: promo.typeDiscount == 1
                            ? '${FormatCurrency((promo.timesApplyPromotion ?? 0) * promo.discount)}đ'
                            : '${(promo.timesApplyPromotion ?? 0) * promo.discount}%',
                        style: p5,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: sp12,
                    ),
                    itemCount: cubit.promoOrderDiscount.length,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.symmetric(
        vertical: sp24,
        horizontal: sp16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng tiền đơn hàng',
                style: p6.copyWith(color: greyColor),
              ),
              BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
                bloc: cubit,
                builder: (context, state) {
                  return Text(
                    '${FormatCurrency(state.totalPrice)}đ',
                    style: p5.copyWith(color: mainColor),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: sp12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giảm giá CTKM đơn hàng',
                style: p6.copyWith(color: greyColor),
              ),
              BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
                bloc: cubit,
                builder: (context, state) {
                  return Text(
                    '${FormatCurrency(state.totalPriceDiscount)}đ',
                    style: p5.copyWith(color: mainColor),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: sp24),
          ClipRRect(
            borderRadius: BorderRadius.circular(sp12),
            child: Container(
              color: mainColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(sp12),
                      color: bg_4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khách phải trả',
                            style: p7.copyWith(
                              color: borderColor_4,
                            ),
                          ),
                          const SizedBox(height: sp4),
                          BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
                            bloc: cubit,
                            builder: (context, state) {
                              return Text(
                                '${FormatCurrency(state.totalPrice - state.totalPriceDiscount)}đ',
                                style: p3.copyWith(
                                  color: mainColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _createOrderEvent(
                        context,
                        TypePayment.cash,
                      ).then((value) {
                        onConfirm?.call();
                      });
                    },
                    child: const SizedBox(
                      width: sp48 + sp12,
                      child: Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: whiteColor,
                          size: sp20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// create order by post API
  Future<void> _createOrderEvent(
    BuildContext context,
    TypePayment typePayment,
  ) async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo đơn vui lòng đợi',
    );
    final res = await cubit.createOrder();
    Navigator.of(context).pop();
    if (res.response.code == 200 && context.mounted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BasePopupNoti(
              click: () {
                context.router
                    .popUntil((route) => route.settings.name == 'HomeRoute');
                // context.router.push(
                //   OrderDetailRoute(
                //     order: res.response.data,
                //     typeOrder: TypeOrder.cHTH,
                //   ),
                // );
              },
              close: () {
                context.router
                    .popUntil((route) => route.settings.name == 'HomeRoute');
              },
              content: 'Tạo đơn hàng thành công',
              status: StatusNoti.SUCCESS,
              titleClose: 'Trang danh sách',
              titleConfirm: 'Chi tiết đơn',
            ),
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo đơn hàng thất bại !!',
      );
    }
  }
}

class CardProductConfirmOrder extends StatelessWidget {
  const CardProductConfirmOrder({
    super.key,
    required this.variant,
  });

  final VariantWmEntity variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: variant.amountRetail != 0,
          child: RowItemCardProductConfirmOrder(
            title: variant.title,
            amount: variant.amountRetail.toString(),
            total:
                '${FormatCurrency(variant.amountRetail * variant.priceSell)}đ',
          ),
        ),
        Visibility(
          visible: variant.amountRetail != 0,
          child: const SizedBox(height: sp12),
        ),
        Visibility(
          visible: variant.amount != 0,
          child: RowItemCardProductConfirmOrder(
            title: variant.title,
            amount: variant.amount.toString(),
            total: '${FormatCurrency(variant.amount * variant.priceSellUnit)}đ',
          ),
        ),
        Visibility(
          visible: variant.amount != 0,
          child: const SizedBox(height: sp12),
        ),
        // Promotion in Variant
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final promo = variant.promotionDetailEntity?[index];
            // Promotion Item Data
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final promoItem = promo?.promotionItemData?[index];
                // Variant in Item Data
                return Visibility(
                  visible: promoItem?.quantitySelected != 0,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variant = promoItem?.variantValueData?[index];
                      return RowItemCardProductConfirmOrder(
                        title: variant?.title ?? '',
                        amount:
                            '${(variant?.quantity ?? 0) * (promoItem?.quantitySelected ?? 0)}',
                        total: '0đ',
                        color: borderColor_4,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: sp12),
                    itemCount: promoItem?.variantValueData?.length ?? 0,
                  ),
                );
              },
              separatorBuilder: (context, index) => Visibility(
                  visible:
                      promo?.promotionItemData?[index].quantitySelected != 0,
                  child: const SizedBox(height: sp12)),
              itemCount: promo?.promotionItemData?.length ?? 0,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: sp12),
          itemCount: variant.promotionDetailEntity?.length ?? 0,
        ),
      ],
    );
  }
}

class RowItemCardProductConfirmOrder extends StatelessWidget {
  const RowItemCardProductConfirmOrder({
    super.key,
    required this.title,
    required this.amount,
    required this.total,
    this.color,
    this.style,
  });

  final String title;
  final String amount;
  final String total;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: (style ?? p5).copyWith(color: color ?? blackColor),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            amount,
            style: (style ?? p5).copyWith(color: color ?? blackColor),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            total,
            style: (style ?? p5).copyWith(color: color ?? blackColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
