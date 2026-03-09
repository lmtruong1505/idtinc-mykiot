import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../../shared/constants/storage/shared_preference.dart';
import '../../../base/app_bar.dart';
import '../../../base/loading.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';
import '../cubit/order_wm_detail_cubit/order_wm_detail_cubit.dart';
import '../cubit/order_wm_detail_cubit/order_wm_detail_state.dart';
import '../widgets/status_order.dart';
import 'order_wm_create_preview_page.dart';

@RoutePage()
class OrderWmDetailPage extends StatefulWidget {
  const OrderWmDetailPage({
    super.key,
    required this.order,
    // required this.typeOrder,
    // this.isDrafOrder = false,
    // this.onDispose,
  });

  final dynamic order;
  // final TypeOrder typeOrder;
  // final bool isDrafOrder;
  // final VoidCallback? onDispose;

  @override
  State<OrderWmDetailPage> createState() => _OrderWmDetailPageState();
}

class _OrderWmDetailPageState extends State<OrderWmDetailPage> {
  late OrderWmDetailCubit myBloc;

  @override
  void initState() {
    super.initState();

    myBloc = getIt.get<OrderWmDetailCubit>();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.onDispose?.call();
  // }

  final role = AppSharedPreference.instance.getValue(PrefKeys.userCode);
  // final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderWmDetailCubit>(
      create: (context) => myBloc..initData(widget.order),
      child: BlocBuilder<OrderWmDetailCubit, OrderWmDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_5,
            appBar: BaseAppBar(
              title: 'Chi tiết đơn bán hàng',
              actions: [
                if (state.orderDetail?.orderStatus?.id ==
                    PrefKeys.idOrderDrafStatus)
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      '${AssetsPath.icon}/ic_edit_order.svg',
                      width: sp16,
                    ),
                  ),
                const SizedBox(
                  width: sp16,
                ),
                // if (state.orderDetail?.orderStatus?.id ==
                //     PrefKeys.idOrderConfirm)
                //   InkWell(
                //     onTap: () => context.router.push(
                //       DloCreateRoute(order: state.orderDetail),
                //     ),
                //     child: const Icon(
                //       Icons.local_shipping_rounded,
                //       color: blackColor,
                //     ),
                //   ),
                // const SizedBox(
                //   width: sp16,
                // ),
              ],
            ),
            body: Container(
              width: widthDevice(context),
              height: heightDevice(context),
              child: state.isLoading
                  ? const Center(
                      child: BaseLoading(),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(sp16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(sp16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    color: whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: greyColor.withOpacity(0.2),
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.orderDetail?.code ?? '',
                                                style: p6,
                                              ),
                                              const SizedBox(
                                                height: sp12,
                                              ),
                                              Text(
                                                DateFormat('H:m a dd/MM/y')
                                                    .format(state.orderDetail
                                                            ?.createAt ??
                                                        DateTime.now()),
                                                style: p8.copyWith(
                                                  color: greyColor,
                                                ),
                                              ),
                                              Visibility(
                                                visible: state.orderDetail
                                                        ?.orderRed ??
                                                    false,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: sp12,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check_rounded,
                                                          size: sp20,
                                                          color: state.orderDetail
                                                                      ?.orderRed ??
                                                                  false
                                                              ? green_1
                                                              : red_1,
                                                        ),
                                                        const Text(
                                                          'Hoá đơn đỏ',
                                                          style: TextStyle(
                                                            color: green_1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          StatusOrderCard(
                                            title: state.orderDetail
                                                    ?.orderStatus?.title ??
                                                '',
                                            id: state.orderDetail?.orderStatus
                                                    ?.id ??
                                                0,
                                            typeOrder: TypeOrder.cHTH,
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: state
                                                .orderDetail?.orderStatus?.id ==
                                            3,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: sp16),
                                          padding: const EdgeInsets.all(sp16),
                                          width: widthDevice(context),
                                          decoration: BoxDecoration(
                                            color: bg_4,
                                            borderRadius:
                                                BorderRadius.circular(sp12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Lý do từ chối',
                                                style:
                                                    p7.copyWith(color: red_1),
                                              ),
                                              const SizedBox(height: sp12),
                                              Text(
                                                state.orderDetail?.noteCancel ??
                                                    'Chưa có lý do',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // state.typeOrder == TypeOrder.cHTH
                                //     ? Container(
                                //         margin: const EdgeInsets.only(
                                //           top: sp16,
                                //         ),
                                //         child: InfoCustomerCard(
                                //           orderDetail: state.orderDetail,
                                //         ),
                                //       )
                                //     : const SizedBox(),
                                const SizedBox(height: sp16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(sp16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp12),
                                    color: whiteColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ghi chú đơn hàng',
                                        style: p5.copyWith(
                                          color: blackColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: sp12,
                                      ),
                                      Text(
                                        state.orderDetail?.note ?? '',
                                        style: p5.copyWith(
                                          color: blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: sp16),
                          Container(
                            padding: const EdgeInsets.all(sp16),
                            color: whiteColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Danh sách sản phẩm',
                                  style: p1.copyWith(color: blackColor),
                                ),
                                const SizedBox(height: sp16),
                                const RowItemCardProductConfirmOrder(
                                  title: 'Sản phẩm',
                                  amount: 'Số lượng',
                                  total: 'Thành tiền',
                                  style: p6,
                                  color: borderColor_4,
                                ),
                                const Divider(
                                  height: sp32,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final variant = state.variants[index];
                                    return Column(
                                      children: [
                                        RowItemCardProductConfirmOrder(
                                          title: variant.name ?? '',
                                          amount: variant.amount.toString(),
                                          total:
                                              '${FormatCurrency((variant.amount ?? 0) * (variant.priceSell ?? 0))}đ',
                                        ),
                                        Visibility(
                                          visible: variant.promotions.isEmpty,
                                          child: const SizedBox(
                                            height: sp12,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              variant.promotions.isNotEmpty,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final variantPromo =
                                                  state.variantsGift
                                                      .where(
                                                        (e) =>
                                                            e.variantParentPromo ==
                                                            variant.id,
                                                      )
                                                      .toList()[index];
                                              return RowItemCardProductConfirmOrder(
                                                title: variantPromo.name ?? '',
                                                amount: variantPromo.amount
                                                    .toString(),
                                                total: '0đ',
                                                color: borderColor_4,
                                                style: p6,
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              height: sp16,
                                            ),
                                            itemCount: state.variantsGift
                                                .where(
                                                  (e) =>
                                                      e.variantParentPromo ==
                                                      variant.id,
                                                )
                                                .toList()
                                                .length,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: sp16),
                                  itemCount: state.variants.length,
                                ),
                                const Divider(height: sp32),
                                Text(
                                  'Sản phẩm tặng kèm (khuyến mãi đơn hàng)',
                                  style: p6.copyWith(color: borderColor_4),
                                ),
                                const SizedBox(height: sp16),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final variant = state.variantsPromo[index];
                                    return RowItemCardProductConfirmOrder(
                                      title: variant.name ?? '',
                                      amount: variant.amount.toString(),
                                      total: '0đ',
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: sp16),
                                  itemCount: state.variantsPromo.length,
                                ),
                                // PromoItem for Customer (CTKM người tiêu dùng)
                                const Divider(height: sp32),
                                Text(
                                  'Sản phẩm tặng cho người tiêu dùng',
                                  style: p6.copyWith(color: borderColor_4),
                                ),
                                const SizedBox(height: sp16),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final variant =
                                        (state.orderDetail?.variants ?? [])
                                            .where((e) => e.type == 2)
                                            .toList()[index];
                                    return RowItemCardProductConfirmOrder(
                                      title: variant.name ?? '',
                                      amount: variant.amount.toString(),
                                      total: '0đ',
                                      style: p5,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: sp16),
                                  itemCount: (state.orderDetail?.variants ?? [])
                                      .where((e) => e.type == 2)
                                      .toList()
                                      .length,
                                ),
                                const Divider(height: sp32),
                                Text(
                                  'Giảm giá đơn hàng',
                                  style: p6.copyWith(color: borderColor_4),
                                ),
                                const SizedBox(height: sp16),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final promo =
                                        state.orderDetail?.discountOrder[index];
                                    return RowItemCardProductConfirmOrder(
                                      title: promo?.title ?? '',
                                      amount: (promo?.timesApplyPromotion ?? 0)
                                          .toString(),
                                      total: promo?.typeDiscount == 'Tiền mặt'
                                          ? '${FormatCurrency((promo?.discountValue ?? 0) * (promo?.timesApplyPromotion ?? 0))}đ'
                                          : '${FormatCurrency((state.orderDetail?.total ?? 0) * (promo?.discountValue ?? 0) * (promo?.timesApplyPromotion ?? 0) / 100)}đ',
                                      style: p5,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: sp16),
                                  itemCount:
                                      (state.orderDetail?.discountOrder ?? [])
                                          .length,
                                ),
                              ],
                            ),
                          ),
                          // Visibility(
                          //   visible: state.orderDetail?.orderStatus?.id == 1 &&
                          //       role != PrefKeys.codeAdmin,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(sp16),
                          //     child: SizedBox(
                          //       width: double.infinity,
                          //       child: SupportButton(
                          //         title: 'Huỷ đơn hàng',
                          //         event: () {
                          //           showDialog(
                          //             context: context,
                          //             builder: (context) =>
                          //                 _confirmCancelOrder(),
                          //           );
                          //         },
                          //         color: whiteColor,
                          //         largeButton: true,
                          //         icon: null,
                          //         backgroundColor: red_1,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: sp24),
                        ],
                      ),
                    ),
            ),
            bottomNavigationBar:
                BlocBuilder<OrderWmDetailCubit, OrderWmDetailState>(
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        offset: const Offset(0, -sp4),
                        blurRadius: sp4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: p6.copyWith(color: greyColor),
                          ),
                          Text(
                            '${FormatCurrency(state.orderDetail?.total ?? 0)}đ',
                            style: p5.copyWith(
                              color: blackColor,
                            ),
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
                          Text(
                            '${FormatCurrency(state.orderDetail?.discount ?? 0)}đ',
                            style: p5.copyWith(color: blackColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: sp16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(sp12),
                        child: Container(
                          padding: const EdgeInsets.all(sp12),
                          color: bg_4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Khách phải trả',
                                style: p7.copyWith(
                                  color: borderColor_4,
                                ),
                              ),
                              const SizedBox(height: sp4),
                              Text(
                                '${FormatCurrency((state.orderDetail?.total ?? 0) - (state.orderDetail?.discount ?? 0))}đ',
                                style: p3.copyWith(
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: sp16),
                      // Visibility(
                      //   visible: state.orderDetail?.orderStatus?.id == 4,
                      //   child: SizedBox(
                      //     width: double.infinity,
                      //     child: MainButton(
                      //       title: 'Xem hoá đơn',
                      //       event: () => context.router.push(
                      //         BillDetailRoute(
                      //           orderDetailEntity: state.orderDetail!,
                      //           typeOrder: state.typeOrder!,
                      //         ),
                      //       ),
                      //       largeButton: true,
                      //       icon: null,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Future<void> confirmPayment() async {
  //   await cardBankCubit.getCard().then((card) {
  //     context.router.push(
  //       QrCodePaymentRoute(
  //         qrcodeInfo: myBloc.state.orderDetail!.qrCodePayment,
  //         cardEntity: card,
  //         orderDetailEntity: myBloc.state.orderDetail!,
  //       ),
  //     );
  //   });
  // }

  /// Before create Order, user must chose type payment [TypePayment]
  // void payment(BuildContext _) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: _,
  //     builder: (context) => ConfirmPaymentBts(
  //       orderCreateCubit: orderCreateCubit,
  //       cardBankCubit: getIt.get<CardBankCubit>(),
  //       onConfirm: () => null,
  //     ),
  //   );
  // }

  // void showPopupDeny(OrderWmDetailCubit myBloc) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Center(
  //       child: Card(
  //         shape: BeveledRectangleBorder(
  //           borderRadius: BorderRadius.circular(
  //             sp16,
  //           ),
  //         ),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(sp16),
  //             color: whiteColor,
  //           ),
  //           width: widthDevice(context) - sp32,
  //           padding: const EdgeInsets.all(sp24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 'Lý do từ chối nhận hàng',
  //                 style: p1,
  //               ),
  //               const SizedBox(height: sp24),
  //               CommonDropdown(
  //                 label: 'Chọn lý do từ chối',
  //                 items: myBloc.listReaseon,
  //                 hintText: 'Nhập hoặc chọn lý do có sẵn',
  //                 onChanged: (value) => myBloc.reasonChange(value),
  //               ),
  //               BlocBuilder<OrderWmDetailCubit, OrderWmDetailState>(
  //                 bloc: myBloc,
  //                 builder: (context, state) {
  //                   return Visibility(
  //                     visible: state.idReasonDeny == 3,
  //                     child: Column(
  //                       children: [
  //                         const SizedBox(height: sp16),
  //                         AppInput(
  //                           label: 'Nhập lý do từ chối khác',
  //                           hintText: 'Nhập lý do',
  //                           validate: (value) {},
  //                           textInputType: TextInputType.text,
  //                           onChanged: (value) =>
  //                               myBloc.titleReasonChange(value),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //               const SizedBox(height: sp24),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Extrabutton(
  //                       title: 'Huỷ bỏ',
  //                       event: () => Navigator.of(context).pop(),
  //                       largeButton: true,
  //                       borderColor: borderColor_2,
  //                       icon: null,
  //                     ),
  //                   ),
  //                   const SizedBox(width: sp16),
  //                   Expanded(
  //                     child: MainButton(
  //                       title: 'Xác nhận',
  //                       event: () {
  //                         Navigator.of(context).pop();
  //                         myBloc.cancelOrder(context);
  //                       },
  //                       largeButton: true,
  //                       icon: null,
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _deleteOrderDraf() {
  //   myBloc.deleteOrderDraf();
  //   context.router
  //       .popUntil((route) => route.settings.name == 'OrderManagerRoute');
  // }

  // /// Before create Order, user must chose type payment [TypePayment]
  // void _payment(BuildContext _) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: _,
  //     builder: (context) => ConfirmPaymentBts(
  //       onConfirm: (typePayment) => createOrderEvent(
  //         context,
  //         typePayment,
  //       ),
  //       totalPrice: myBloc.state.orderDetail?.total ?? 0,
  //     ),
  //   );
  // }

  // Future<void> createOrderEvent(
  //   BuildContext context,
  //   TypePayment typePayment,
  // ) async {
  //   orderCreateCubit.updateOrderInfo(myBloc.state.orderDetail);

  //   orderCreateCubit.validateCreateOrder();

  //   if (orderCreateCubit.state.failureCreateOrder != null) {
  //     DialogUtils.showErrorDialog(
  //       context,
  //       content: orderCreateCubit.state.failureCreateOrder?.errMsg ?? '',
  //     );
  //     return;
  //   }

  //   DialogUtils.showLoadingDialog(
  //     context,
  //     content: 'Đang tạo đơn vui lòng đợi',
  //   );
  //   final res = await orderCreateCubit.createOrder();

  //   if (context.mounted) {
  //     Navigator.of(context).pop();
  //   }
  //   if (res.response.code == 200 && context.mounted) {
  //     context.router.popUntil(
  //       (route) =>
  //           route.settings.name ==
  //           (orderCreateCubit.state.typeOrder == TypeOrder.cHTH
  //               ? 'OrderManagerRoute'
  //               : 'OrderImportRoute'),
  //     );
  //     myBloc.deleteOrderDraf();
  //     if (typePayment == TypePayment.qrCode) {
  //     } else {
  //       context.router.push(
  //         OrderDetailRoute(
  //           order: res.response.data!,
  //           typeOrder: orderCreateCubit.state.typeOrder,
  //         ),
  //       );
  //     }
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     DialogUtils.showErrorDialog(
  //       context,
  //       content: 'Tạo đơn hàng thất bại, vui lòng kiểm tra tồn kho',
  //     );
  //   }
  // }

  // Widget _confirmCancelOrder() {
  //   return Center(
  //     child: Card(
  //       shape:
  //           BeveledRectangleBorder(borderRadius: BorderRadius.circular(sp16)),
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
  //         decoration: BoxDecoration(
  //           color: whiteColor,
  //           borderRadius: BorderRadius.circular(sp16),
  //         ),
  //         width: max(widthDevice(context) - sp32, 343),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircleAvatar(
  //               radius: 30,
  //               backgroundColor: red_2,
  //               child: SvgPicture.asset(
  //                 '${AssetsPath.image}/noti/error.svg',
  //               ),
  //             ),
  //             const SizedBox(height: sp24),
  //             Text('Huỷ đơn hàng', style: h3.copyWith(color: blackColor)),
  //             const SizedBox(height: sp12),
  //             Text(
  //               'Xác nhận huỷ đơn hàng này ?',
  //               style: p4.copyWith(color: greyColor),
  //               maxLines: 2,
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: sp24),
  //             Form(
  //               key: _key,
  //               child: AppInput(
  //                 label: 'Lý do huỷ đơn',
  //                 required: true,
  //                 hintText: 'Nhập lý do huỷ đơn',
  //                 onChanged: myBloc.titleReasonChange,
  //                 validate: (value) {
  //                   if (value?.isEmpty ?? true) {
  //                     return 'Vui lòng nhập lý do huỷ đơn';
  //                   }
  //                 },
  //               ),
  //             ),
  //             const SizedBox(height: sp24),
  //             Row(
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Extrabutton(
  //                     title: 'Huỷ bỏ',
  //                     event: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     borderColor: borderColor_2,
  //                     largeButton: true,
  //                     icon: null,
  //                   ),
  //                 ),
  //                 const SizedBox(width: sp16),
  //                 Expanded(
  //                   flex: 1,
  //                   child: SupportButton(
  //                     title: 'Xác nhận',
  //                     event: () {
  //                       if (_key.currentState?.validate() == false) return;
  //                       Navigator.of(context).pop();
  //                       DialogUtils.showLoadingDialog(
  //                         context,
  //                         content: 'Đang thực hiện thao tác huỷ đơn.',
  //                       );
  //                       myBloc.updateStatus(5).then((value) {
  //                         Navigator.of(context).pop();
  //                       });
  //                     },
  //                     largeButton: true,
  //                     icon: null,
  //                     backgroundColor: mainColor,
  //                     color: whiteColor,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
