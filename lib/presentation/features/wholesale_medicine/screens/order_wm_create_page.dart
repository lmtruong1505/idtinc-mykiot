import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/variant_wm_entity.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../../shared/constants/storage/shared_preference.dart';
import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/dialog.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_cubit.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';
import '../domain/entities/promotion_detail_wm_entity.dart';
import '../widgets/list_promo_for_order.dart';
import '../widgets/variant_wm_create_card.dart';

@RoutePage()
class OrderWmCreatePage extends StatefulWidget {
  const OrderWmCreatePage({
    super.key,
    this.idCustomer,
    this.onComplete,
    this.typeCreate,
  });

  final int? idCustomer;
  final Function()? onComplete;
  final TypeCreateOrder? typeCreate;

  @override
  State<OrderWmCreatePage> createState() => _OrderWmCreatePageState();
}

class _OrderWmCreatePageState extends State<OrderWmCreatePage> {
  final OrderWmCreateCubit _cubit = getIt.get<OrderWmCreateCubit>();

  late ScrollController scrollController;

  final TextEditingController searchTec = TextEditingController();
  final role = AppSharedPreference.instance.getValue(PrefKeys.userCode);

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 100) {
          _cubit.isBottomSrollChange(true);
        } else {
          _cubit.isBottomSrollChange(false);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderWmCreateCubit>(
      create: (context) => _cubit
        ..initData(
          TypeOrder.cHTH,
          widget.typeCreate,
        )
        ..getListVariant(-1),
      child: BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: const BaseAppBar(title: 'Tạo đơn hàng'),
              body: Container(
                padding: const EdgeInsets.symmetric(vertical: sp16),
                width: widthDevice(context),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Visibility(
                            visible:
                                state.typeCreate == TypeCreateOrder.byPromotion,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: sp16,
                              ).copyWith(top: sp24),
                              child: AppInputSupport(
                                controller: searchTec,
                                hintText: 'Nhập tên, mã sản phẩm',
                                backgroundColor: whiteColor,
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  size: sp20,
                                ),
                                radius: sp12,
                                onChanged: _cubit.searchKeyChange,
                                suffixIcon: state.searchKey.isEmpty
                                    ? null
                                    : InkWell(
                                        onTap: () {
                                          searchTec.clear();
                                          _cubit.searchKeyChange('');
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: sp20,
                                          color: mainColor,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: sp24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: sp16,
                            ),
                            child: Text(
                              'Danh sách sản phẩm trong đơn',
                              style: p5.copyWith(color: borderColor_4),
                            ),
                          ),
                          Visibility(
                            visible:
                                state.typeCreate == TypeCreateOrder.byProduct,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: sp16,
                              ).copyWith(top: sp16),
                              child: SizedBox(
                                width: double.infinity,
                                child: ExtraButton(
                                  title: 'Chọn sản phẩm',
                                  event: () => context.router.push(
                                    SelectVariantRoute(
                                      bloc: _cubit,
                                      dataInit: state.listVariantSelect,
                                      onConfirm: _cubit.updateVariantSelected,
                                    ),
                                  ),
                                  largeButton: true,
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    color: blackColor,
                                  ),
                                  backgroundColor: whiteColor,
                                  borderColor: borderColor_2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: sp24),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) {
                          final variant = state.listVariantSelect
                              .where(
                                (e) =>
                                    e.title
                                        .toLowerCase()
                                        .contains(state.searchKey) ||
                                    e.code
                                        .toLowerCase()
                                        .contains(state.searchKey),
                              )
                              .toList()[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: sp16,
                            ),
                            margin: const EdgeInsets.only(bottom: sp16),
                            child: VariantWmCreateCard(
                              variant: variant,
                              quantityChange: (variant, value) =>
                                  _cubit.changeAmount(
                                variant,
                                value,
                              ),
                              quantityGiftChange: (variant, value) =>
                                  _cubit.changeAmountGift(
                                variant,
                                value,
                              ),
                              toggleCheckbox: (bool? value) =>
                                  _cubit.checkboxToggle(variant),
                              priceSellChange: (
                                VariantWmEntity variant,
                                String value,
                              ) =>
                                  _cubit.priceChange(
                                variant,
                                value,
                              ),
                              onConfirmPromo: (value) {
                                if (value == null) return;
                                _cubit.confirmPromoForVariant(
                                  idVariant: variant.id ?? 0,
                                  value: value,
                                  typePromotion: TypePromotion.product,
                                );
                              },
                              onDelete: _cubit.deleteVariantSelected,
                              onDeletePromo: (int idPromo) =>
                                  _cubit.deletePromoForVariant(
                                idVariant: variant.id ?? 0,
                                idPromo: idPromo,
                              ),
                              onSelect: _cubit.selectVariant,
                              typeCreate: state.typeCreate,
                              onPromoItemChangeQuantity:
                                  _cubit.changeQuantityPromo,
                            ),
                          );
                        },
                        childCount: state.listVariantSelect
                            .where(
                              (e) =>
                                  e.title
                                      .toLowerCase()
                                      .contains(state.searchKey) ||
                                  e.code
                                      .toLowerCase()
                                      .contains(state.searchKey),
                            )
                            .toList()
                            .length,
                      ),
                    ),

                    // Khuyến mãi cho đơn hàng
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: sp16),
                          child: const Text(
                            'Chương trình khuyễn mãi cho đơn hàng',
                            style: p1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: sp16),
                        ListPromoForOrder(
                          listPromo: _cubit.convertPromotionForOrder,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar:
                  BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: state.listVariantSelect
                            .where((e) => e.isChoose)
                            .toList()
                            .isNotEmpty,
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: blackColor.withOpacity(0.2),
                                offset: const Offset(0, -1),
                                blurRadius: sp4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: sp12,
                            horizontal: sp16,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Đã đủ điều kiện áp dụng CTBH',
                                style: p6.copyWith(color: mainColor),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  context.router.push(
                                    PromotionSelectRoute(
                                      typePromotion: TypePromotion.orderTotal,
                                      value: _cubit.state.totalPrice,
                                      listPromoInit: _cubit.state
                                          .promotionDetailEntityForTotalOrder,
                                      onConfirm: (value) {
                                        if (value == null) return;
                                        _cubit.confirmPromoForVariant(
                                          value: value,
                                          typePromotion:
                                              TypePromotion.orderTotal,
                                        );
                                      },
                                      totalPriceBuy: _cubit.state.totalPrice,
                                    ),
                                  );
                                },
                                child: Text(
                                  'Áp dụng',
                                  style: p5.copyWith(color: blue_1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: whiteColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: sp24,
                          horizontal: sp16,
                        ),
                        child: state.typeOrder == TypeOrder.cHTH
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tổng tiền đơn hàng',
                                        style: p6.copyWith(color: greyColor),
                                      ),
                                      BlocBuilder<OrderWmCreateCubit,
                                          OrderWmCreateState>(
                                        bloc: _cubit,
                                        builder: (context, state) {
                                          return Text(
                                            '${FormatCurrency(state.totalPrice)}đ',
                                            style:
                                                p5.copyWith(color: mainColor),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: sp12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Giảm giá CTKM đơn hàng',
                                        style: p6.copyWith(color: greyColor),
                                      ),
                                      BlocBuilder<OrderWmCreateCubit,
                                          OrderWmCreateState>(
                                        bloc: _cubit,
                                        builder: (context, state) {
                                          return Text(
                                            '${FormatCurrency(state.totalPriceDiscount)}đ',
                                            style:
                                                p5.copyWith(color: mainColor),
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
                                              padding:
                                                  const EdgeInsets.all(sp12),
                                              color: bg_4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Khách phải trả',
                                                    style: p7.copyWith(
                                                      color: borderColor_4,
                                                    ),
                                                  ),
                                                  const SizedBox(height: sp4),
                                                  Text(
                                                    '${FormatCurrency(state.totalPrice - state.totalPriceDiscount)}đ',
                                                    style: p3.copyWith(
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              context.router.push(
                                                OrderWmCreatePreviewRoute(
                                                  cubit: _cubit,
                                                  onConfirm: widget.onComplete,
                                                ),
                                              );
                                            },
                                            child: const SizedBox(
                                              width: sp48 + sp12,
                                              child: Center(
                                                child: Icon(
                                                  Icons.arrow_forward_rounded,
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
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: MainButton(
                                  title: 'Xác nhận đặt hàng',
                                  event: () => createOrderEvent(
                                    context,
                                    TypePayment.cash,
                                  ),
                                  largeButton: true,
                                  icon: null,
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
              floatingActionButton:
                  BlocBuilder<OrderWmCreateCubit, OrderWmCreateState>(
                builder: (context, state) {
                  return FloatingActionButton(
                    backgroundColor: mainColor.withOpacity(0.5),
                    onPressed: () {
                      late double value;
                      if (scrollController.position.pixels >
                          scrollController.position.maxScrollExtent - 100) {
                        value = 0;
                      } else {
                        value = scrollController.position.maxScrollExtent + 300;
                      }
                      scrollController.animateTo(
                        value,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    child: Icon(
                      !state.isBottomSroll
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward,
                      color: whiteColor,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// create order by post API
  Future<void> createOrderEvent(
    BuildContext context,
    TypePayment typePayment,
  ) async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo đơn vui lòng đợi',
    );
    final res = await _cubit.createOrder();
    Navigator.of(context).pop();
    if (res.response.code == 200 && context.mounted) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Tạo đơn hàng thành công',
        titleClose: 'Trang danh sách',
        titleConfirm: 'Chi tiết đơn',
        close: () {
          context.router
              .popUntil((route) => route.settings.name == 'HomeRoute');
        },
        accept: () {
          context.router
              .popUntil((route) => route.settings.name == 'HomeRoute');
          // context.router.push(
          //   OrderDetailRoute(
          //     order: res.response.data,
          //     typeOrder: TypeOrder.cHTH,
          //   ),
          // );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo đơn hàng thất bại, vui lòng kiểm tra tồn kho',
      );
    }
  }
}
