import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/base/app_text.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/bottom_sheet_custom.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/promotion_timer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_market_v2_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/shopping_cart/cart_vouchers_screen%20.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/shopping_cart/widget/drug_cart_product_item.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/wholesale_drug_market/widget/drug_categogy_product.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/wholesale_drug_market/widget/drug_product_widget.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../shared/style_app/init_style.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../di/di.dart';
import '../../../../router/router.gr.dart';
import '../../../../shared/utils/event.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/state/cubit_state.dart';
import '../../../blocs/wholesale_drug_maket/variant_detail_bloc.dart';
import '../components/shopping_cart_btn.dart';

@RoutePage()
class VariantKafaDetailPage extends StatefulWidget {
  const VariantKafaDetailPage({super.key, required this.id});
  final int id;

  @override
  State<VariantKafaDetailPage> createState() => _VariantKafaDetailPageState();
}

class _VariantKafaDetailPageState extends State<VariantKafaDetailPage> {
  final bloc = getIt.get<VariantDetailBloc>();
  // final shoppingCartBloc = getIt.get<ShoppingCartBloc>();
  final promotionTimerBloc = getIt<PromotionTimerBloc>();
  final wholeSaleDrugBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final bestSellerPrdBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final cartBloc = getIt<DrugCartBloc>();

  final delay = DelayCallBack(delay: 1.seconds);
  final TextEditingController amountTec = TextEditingController();

  @override
  void initState() {
    super.initState();
    wholeSaleDrugBloc.getList();
    bestSellerPrdBloc
      ..setType(value: DrugPrdV2Type.bestSeller)
      ..getList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => bloc
            ..getDetail(widget.id)
            ..getVouchers(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => promotionTimerBloc,
        ),
        BlocProvider(
          create: (context) => wholeSaleDrugBloc,
        ),
        BlocProvider(
          create: (context) => bestSellerPrdBloc,
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: BlocBuilder<VariantDetailBloc, CubitState<VariantKafaModel>>(
          builder: (context, state) {
            if (state.status == BlocStatus.loading) {
              return const BaseLoading();
            }
            final promotionData = state.data?.promotionData;
            promotionTimerBloc.initData(promotionData?.firstOrNull?.endDate);
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      BaseCacheImage(
                        height: widthDevice(context),
                        width: widthDevice(context),
                        url: state.data?.image ?? '',
                        fit: BoxFit.cover,
                      ),
                      _flashSaleSection(),
                      _invoiceAndPromotionSection(promotionData),
                    ],
                  ),
                  _header(state.data),
                  _basicInfo(state.data),
                  Row(
                    children: [
                      DividerCustom(color: AppColors.text_tertiary).expanded(),
                      8.width,
                      Text(
                        'Có thể bạn cũng cần',
                        style: s12w400.copyWith(color: AppColors.text_tertiary),
                      ),
                      8.width,
                      DividerCustom(color: AppColors.text_tertiary).expanded(),
                    ],
                  ).padding(16.padingHor),
                  DrugCategoryProduct(
                    bloc: wholeSaleDrugBloc,
                    isShowCate: false,
                    cartBloc: cartBloc,
                  ),
                  DrugCategoryProduct(
                    icon: 'f7e4',
                    bloc: bestSellerPrdBloc,
                    title: 'Chương trình khuyến mãi',
                    cartBloc: cartBloc,
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  Widget _invoiceAndPromotionSection(List<PromotionData>? promotionData) {
    return Visibility(
      visible: promotionTimerBloc.isFinished,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Row(
          children: [
            Container(
              height: 40,
              padding: 16.padingHor,
              decoration: const BoxDecoration(color: AppColors.green80),
              child: Row(
                children: [
                  FaIcon(
                    iconCode: 'f543',
                    color: AppColors.white,
                    type: FaIconType.solid,
                    size: 18,
                  ),
                  8.width,
                  Text(
                    'Hoá đơn',
                    style: s14w400.copyWith(
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: (promotionData?.isNotEmpty == true),
              child: Container(
                height: 40,
                padding: 16.padingHor,
                decoration: const BoxDecoration(
                  color: AppColors.red60,
                ),
                child: Center(
                  child: Text(
                    'Khuyến mãi',
                    style: s14w400.copyWith(
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flashSaleSection() {
    return Visibility(
      visible: !promotionTimerBloc.isFinished,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: 16.pading,
          color: AppColors.red10,
          child: Row(
            children: [
              FaIcon(
                iconCode: 'f7e4',
                color: AppColors.red60,
                type: FaIconType.solid,
              ),
              8.width,
              SvgPicture.asset(
                'assets/svg/ic_flash_sale.svg',
                height: 17,
                fit: BoxFit.cover,
              ),
              const Spacer(),
              _promotionCount(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        color: AppColors.bg_black,
        onPressed: () => context.pop(result: bloc.isReloadPrePage),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        ShoppingCartBtn(
          onTap: () async {
            final result = await context.router.push(const DrugCartRoute());
            if (result == true) {
              print('=====DrugCartRoute===$result');
              bloc
                ..getDetail(widget.id)
                ..setReload(true);
            }
          },
        ),
        16.width,
      ],
    );
  }

  Widget _promotionCount() {
    return BlocBuilder<PromotionTimerBloc, CubitState>(
      builder: (context, state) {
        String format(int n) => n.toString().padLeft(2, '0');

        return Visibility(
          visible: !promotionTimerBloc.isFinished,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerBox(format(promotionTimerBloc.hours)),
              Text(
                ' : ',
                style: s14w600.copyWith(
                  color: AppColors.red60,
                ),
              ),
              _buildTimerBox(format(promotionTimerBloc.minutes)),
              Text(
                ' : ',
                style: s14w600.copyWith(
                  color: AppColors.red60,
                ),
              ),
              _buildTimerBox(format(promotionTimerBloc.seconds)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerBox(String text) {
    return BaseContainer(
      borderColor: AppColors.red60,
      borderRadius: 4,
      height: 25,
      width: 25,
      color: AppColors.red60,
      child: Center(
        child: Text(
          text,
          style: s14w600.copyWith(color: AppColors.white, height: 1),
        ),
      ),
    );
  }

  Widget _header(VariantKafaModel? prd) {
    final voucher = bloc.voucherSelect ?? bloc.vouchers.firstOrNull;
    final drugPrd = prd?.toDrugProductModel();
    final promotion = getNearestPromotion(drugPrd?.product?.promotions);
    return Container(
      padding: 12.pading,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.green20],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${FormatCurrency(prd?.price.validator)} đ',
                style: s24w700.copyWith(color: ColorApp.main, fontSize: 28),
              ),
              const Spacer(),
              Text(
                'Đã đặt ${FormatCurrency(prd?.countQuantity)}',
                style: s14w400,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheetCustom(
                isScrollControlled: true,
                height: heightDevice(context) * 3 / 4,
                context: context,
                body: PromotionInforBottomSheet(
                  bloc: bloc,
                  promotionData: promotion,
                  promotions: drugPrd?.product?.promotions,
                ),
                isDismissible: true,
                onConfirm: () => context.pop(),
                title: ' Thông tin khuyến mãi',
                confirmTitle: 'Quay lại',
                isDoubleBtn: false,
              );
            },
            child: SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  if (voucher != null) ...[
                    BaseContainer(
                      borderRadius: 4,
                      borderColor: AppColors.red10,
                      color: AppColors.red10,
                      padding: 4.padingVer + 8.padingHor,
                      child: Row(
                        children: [
                          FaIcon(iconCode: 'f02b', color: AppColors.red60),
                          4.width,
                          Text(
                            voucher.title ?? '',
                            style: s10w400.copyWith(height: 1),
                          ),
                        ],
                      ),
                    ),
                    8.width,
                  ],
                  if (promotion != null)
                    BaseContainer(
                      borderRadius: 4,
                      borderColor: AppColors.red10,
                      color: AppColors.red10,
                      padding: 4.padingVer + 8.padingHor,
                      child: Row(
                        children: [
                          FaIcon(iconCode: 'f06b', color: AppColors.red60),
                          4.width,
                          Text(
                            promotion.title ?? '',
                            style: s10w400.copyWith(height: 1),
                          ),
                        ],
                      ),
                    ),
                  if (promotion != null || voucher != null)
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorApp.grey79,
                      size: 18,
                    ).padding(8.padingLeft),
                ],
              ),
            ),
          ),

          // Container(
          //   decoration: BoxDecoration(
          //     color: ColorApp.yellow19,
          //     borderRadius: 4.radius,
          //   ),
          //   padding: 4.padingHor,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       IcSvg.asset('/ic_badge_per.svg').size(height: 12, width: 12),
          //       2.width,
          //       Text(
          //         '${state.data?.promotionDetail.length ?? 0} CTKM',
          //         style: StyleApp.normal(color: ColorApp.yellowD2),
          //       ),
          //     ],
          //   ),
          // ),
          // 8.height,
        ],
      ),
    );
  }

  Widget _basicInfo(VariantKafaModel? prd) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        borderRadius: 16.radius,
        color: ColorApp.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prd?.title ?? 'Không có thông tin',
            style: StyleApp.medium(fontSize: 16),
          ),
          8.height,
          Row(
            children: [
              Row(
                children: [
                  FaIcon(
                    iconCode: 'f543',
                    color: AppColors.brand,
                    type: FaIconType.solid,
                    size: 18,
                  ),
                  8.width,
                  Text(
                    'Phát hành hóa đơn',
                    style: s10w400.copyWith(
                      height: 1,
                    ),
                  ),
                ],
              ),
              16.width,
              Center(
                child: Row(
                  children: [
                    FaIcon(
                      iconCode: 'f145',
                      color: AppColors.red60,
                      type: FaIconType.regular,
                      size: 18,
                    ),
                    8.width,
                    Text(
                      'Khuyến mãi',
                      style: s10w400.copyWith(height: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              Text(
                'Thương hiệu',
                style: s14w400.copyWith(height: 1),
              ),
              8.width,
              ...List.generate(
                prd?.brandData.length ?? 0,
                (index) => Text(
                  prd?.brandData[index].title ?? '',
                  style: s14w500.copyWith(height: 1, color: AppColors.blue60),
                ),
              ),
            ],
          ),
          12.height,
          BaseContainer(
            width: widthDevice(context),
            padding: 12.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi tiết sản phẩm',
                  style: s16w700,
                ),
                const Text(
                  'Mô tả',
                  style: s14w400,
                ),
                if (prd?.setting?.description != null)
                  Text(
                    prd?.setting?.description ?? '',
                    style: StyleApp.semibold(),
                  ),
                if (prd?.setting?.description != null) 16.height,
                RowItem(
                  title: 'Made in',
                  content: prd?.setting?.madeIn ?? 'Không có thông tin',
                ),
                RowItem(
                  title: 'Dạng bào chế',
                  content: prd?.setting?.dosageForm ?? 'Không có thông tin',
                ),
                RowItem(
                  title: 'Quy cách đóng gói',
                  content: prd?.setting?.packageForm ?? 'Không có thông tin',
                ),
                RowItem(
                  title: 'Công ty sản xuất',
                  content: prd?.setting?.productsByManufacturer ??
                      'Không có thông tin',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return BlocBuilder<VariantDetailBloc, CubitState<VariantKafaModel>>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const BaseLoading();
        }
        final prd = state.data;
        final totalPrice = (prd?.quantityInCart ?? 0) * (prd?.price ?? 0);
        final prodConverter = prd!.toDrugProductModel();
        return BaseBottomBar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Voucher giảm giá',
                    style: s12w700.copyWith(color: AppColors.brand),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.router.push(
                      CartVouchersRoute(
                        vouchers: bloc.vouchers,
                        totalPrice: totalPrice,
                        voucherSelect: bloc.voucherSelected,
                        onConfirm: (value) {
                          bloc.confirmVoucher(value);
                          context.pop();
                        },
                      ),
                    ),
                    child: Row(
                      children: [
                        bloc.voucherSelected != null
                            ? BaseContainer(
                                borderRadius: 4,
                                padding: 4.pading,
                                borderColor: AppColors.red60,
                                child: Text(
                                  bloc.totalDiscount.formatVND,
                                  style: s10w400.copyWith(
                                    color: AppColors.red60,
                                    height: 1,
                                  ),
                                ),
                              )
                            : Text(
                                'Chọn mã giảm giá của bạn',
                                style: s10w400.copyWith(
                                  color: AppColors.text_tertiary,
                                ),
                              ),
                        4.width,
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: bloc.showTotalPrice,
                child: Row(
                  children: [
                    const Text(
                      'Thanh toán',
                      style: s14w400,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => bloc.toggleShowPrice(),
                      child: Row(
                        children: [
                          Text(
                            totalPrice.formatVND,
                            style: s16w700,
                          ),
                          // const Icon(Icons.keyboard_arrow_up),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              8.height,
              Row(
                children: [
                  BaseContainer(
                    padding: 16.padingHor,
                    height: 48,
                    borderRadius: 999,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (prd.quantityInCart > 1) {
                              final quantity = prd.quantityInCart - 1;

                              bloc.onInput(quantity);
                              cartBloc.onMinus(prodConverter);
                            } else {
                              _showDetelePrdDialog(context, prodConverter);
                            }
                          },
                          child: FaIcon(
                            iconCode: 'f068',
                            color: AppColors.black,
                            size: 20,
                          ).padding(16.padingRight),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.grey60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FaIcon(
                                  iconCode: 'f217',
                                  type: FaIconType.regular,
                                  color: AppColors.brand,
                                  size: 20,
                                ),
                              ],
                            ).expanded(),
                            8.width,
                            QuantityInput(
                              textAlign: TextAlign.start,
                              onUpdate: (value) {
                                delay.debounce(
                                  () {
                                    final parseQuantity =
                                        int.tryParse(value.removeAllDot()) ?? 1;
                                    final updateQuantity =
                                        parseQuantity > 0 ? parseQuantity : 1;

                                    bloc.onInput(updateQuantity);

                                    cartBloc.onInput(
                                      prodConverter,
                                      updateQuantity,
                                    );
                                    FocusScope.of(context).unfocus();
                                  },
                                );
                              },
                              quantity: prd.quantityInCart,
                            ).expanded(),
                          ],
                        ).expanded(),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.grey60,
                        ),
                        InkWell(
                          onTap: () {
                            final quantity = prd.quantityInCart + 1;
                            if (prd.quantityInCart == 0) {
                              cartBloc.addPrdToCart(
                                prds: [
                                  DrugProductModel(
                                    id: prodConverter.id,
                                    quantity: quantity,
                                  ),
                                ],
                              );
                            } else {
                              cartBloc.onAdd(prodConverter);
                            }
                            bloc.onInput(quantity);
                          },
                          child: FaIcon(
                            iconCode: '2b',
                            color: AppColors.black,
                            size: 20,
                          ).padding(16.padingLeft),
                        ),
                      ],
                    ),
                  ).expanded(),
                  12.width,
                  ExtraButton(
                    title: 'Đặt ngay',
                    borderRadius: 999,
                    borderColor: null,
                    backgroundColor: ColorApp.main,
                    titleColor: ColorApp.white,
                    event: state.data?.quantityInCart == 0
                        ? null
                        : () {
                            context.router.push(
                              ConfirmKafaOrderV2Route(
                                readySaleCategory: bloc.prdSelected,
                                totalDiscount: bloc.totalDiscount,
                                totalPrice: bloc.totalPrice,
                                promotionActive: bloc.voucherPromotionActive,
                              ),
                            );
                          },
                  ).expanded(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetelePrdDialog(BuildContext context, DrugProductModel prd) {
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
          bloc.onInput(0);
          cartBloc.deletePrds(deletePrds: [prd]);
        },
      ),
    );
  }

  // void showBts(
  //   CubitState state, {
  //   bool isAddToCart = false,
  //   bool isBuyNow = false,
  // }) {
  //   context.bottomSheet(
  //     isScrollControlled: true,
  //     BtsQuantityVariant(
  //       variant: state.data!,
  //       onConfirm: (value) {
  //         bloc.updateVariant(value);
  //         if (!bloc.validateModel(value)) {
  //           return;
  //         }
  //         if (isAddToCart && isBuyNow) return;
  //         if (isAddToCart) {
  //           shoppingCartBloc.add(value);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: const Text('Thêm vào giỏ hàng thành công'),
  //               backgroundColor: ColorApp.main,
  //               duration: 1.seconds,
  //             ),
  //           );
  //         }
  //         if (isBuyNow) {
  //           shoppingCartBloc.orderSingleItem(value);
  //           context.router.push(const ConfirmKafaOrderRoute());
  //         }
  //       },
  //     ),
  //   );
  // }
}

class PromotionInforBottomSheet extends StatefulWidget {
  const PromotionInforBottomSheet({
    super.key,
    required this.bloc,
    this.promotionData,
    this.promotions,
  });

  final VariantDetailBloc bloc;
  final PromotionData? promotionData;
  final List<PromotionData>? promotions;

  @override
  State<PromotionInforBottomSheet> createState() =>
      _PromotionInforBottomSheetState();
}

class _PromotionInforBottomSheetState extends State<PromotionInforBottomSheet> {
  @override
  void initState() {
    super.initState();
    promotionExpand = widget.promotionData;
  }

  PromotionData? promotionExpand;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.promotions?.isNotEmpty == true) ...[
            _rowTitle('Quà tặng'),
            8.height,
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final promotion = widget.promotions?[index];
                final isExpand = promotionExpand?.id == promotion?.id;

                return Column(
                  children: [
                    Container(
                      padding: 8.padingHor + 4.padingVer,
                      decoration: BoxDecoration(
                        color: AppColors.red10,
                        borderRadius: 4.radius,
                      ),
                      child: Row(
                        children: [
                          FaIcon(iconCode: 'f06b', color: AppColors.red60),
                          8.width,
                          Text(
                            promotion?.title ?? '',
                            style: s10w400,
                          ).expanded(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isExpand) {
                                  promotionExpand = null;
                                } else {
                                  promotionExpand = promotion;
                                }
                              });
                            },
                            child: Icon(
                              isExpand
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.text_tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isExpand)
                      ListView.separated(
                        shrinkWrap: true,
                        padding: 8.padingVer + 16.padingLeft,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final bonusVariant = promotion?.promotionItems
                              ?.firstOrNull?.bonusVariantInfor?.firstOrNull;
                          return Row(
                            children: [
                              BaseCacheImage(
                                url: bonusVariant?.variant?.image ?? '',
                                width: 50,
                                height: 50,
                              ),
                              12.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      BaseContainer(
                                        borderColor: AppColors.red60,
                                        borderRadius: 4,
                                        padding: 4.pading,
                                        child: Text(
                                          'Quà tặng',
                                          style: s8w400.copyWith(
                                            color: AppColors.red60,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                      8.width,
                                      Text(
                                        bonusVariant?.variant?.title ?? '',
                                        style: s12w500,
                                      ),
                                    ],
                                  ),
                                  4.height,
                                  Row(
                                    children: [
                                      Text(
                                        0.formatVND,
                                        style: s14w700.copyWith(
                                          color: AppColors.brand,
                                        ),
                                      ),
                                      4.width,
                                      Text(
                                        bonusVariant
                                                ?.variant?.price.formatVND ??
                                            '',
                                        style: s10w400.copyWith(
                                          color: AppColors.fg_tertiary_onBrand,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'x${(bonusVariant?.quantity ?? 0).formatCurrency}',
                                        style: s10w400.copyWith(
                                          color: AppColors.red60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ).expanded(),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => 8.height,
                        itemCount: promotion?.promotionItems?.length ?? 0,
                      ),
                  ],
                );
              },
              separatorBuilder: (context, index) => 8.height,
              itemCount: widget.promotions?.length ?? 0,
            ),
            8.height,
          ],
          if (widget.bloc.vouchers.isNotEmpty == true) ...[
            _rowTitle('Voucher của Pharmago'),
            VoucherList(
              canScroll: false,
              vouchers: widget.bloc.vouchers,
              voucherSelect: widget.bloc.voucherSelect,
            ),
          ],
        ],
      ),
    );
  }

  Row _rowTitle(String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: s14w400.copyWith(color: AppColors.text_tertiary),
        ),
        4.width,
        DividerCustom().expanded(),
      ],
    );
  }
}
