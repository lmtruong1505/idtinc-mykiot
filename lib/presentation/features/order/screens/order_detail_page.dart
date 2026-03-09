// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:pharmago/presentation/base/app_bar.dart';
// import 'package:pharmago/presentation/base/dialog.dart';
// import 'package:pharmago/presentation/base/loading.dart';
// import 'package:pharmago/presentation/base/row_item.dart';
// import 'package:pharmago/presentation/base/text_field.dart';
// import 'package:pharmago/presentation/base/two_button_box.dart';
// import 'package:pharmago/presentation/constants/colors.dart';
// import 'package:pharmago/presentation/constants/size_device.dart';
// import 'package:pharmago/presentation/constants/spacing.dart';
// import 'package:pharmago/presentation/di/di.dart';
// import 'package:pharmago/presentation/features/order/cubit/order_detail_cubit/order_detail_cubit.dart';
// import 'package:pharmago/presentation/features/order/cubit/order_detail_cubit/order_detail_state.dart';
// import 'package:pharmago/presentation/shared/utils/event.dart';
//
// import '../../../../shared/constants/pref_key.dart';
// import '../../../base/cache_image.dart';
// import '../../../constants/typography.dart';
// import '../../../shared/utils/address.dart';
// import '../domain/entities/order_entity.dart';
//
// enum OrderDetailTab { variant, service }
//
// @RoutePage()
// class OrderDetailPage extends StatefulWidget {
//   const OrderDetailPage({
//     super.key,
//     this.id,
//   });
//
//   final int? id;
//
//   @override
//   State<OrderDetailPage> createState() => _OrderDetailPageState();
// }
//
// class _OrderDetailPageState extends State<OrderDetailPage> {
//   final myBloc = getIt.get<OrderDetailCubit>();
//   OrderDetailTab _tab = OrderDetailTab.variant;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<OrderDetailCubit>(
//       create: (context) => myBloc..getDetail(widget.id),
//       child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
//         builder: (context, state) {
//           return Scaffold(
//             appBar: const BaseAppBar(title: 'Chi tiết đơn hàng'),
//             body: Container(
//               height: heightDevice(context),
//               width: widthDevice(context),
//               child: state.isLoading ? const BaseLoading() : _buildBody(state),
//             ),
//             bottomNavigationBar: _buildBottom(state),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildBody(OrderDetailState state) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: sp24,
//           horizontal: sp16,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(sp16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(sp12),
//                 color: whiteColor,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Thông tin đơn hàng',
//                     style: h6.copyWith(color: blackColor.withOpacity(0.6)),
//                   ),
//                   gapHeight(sp24),
//                   Text(
//                     state.order?.code ?? '',
//                     style: p5.copyWith(color: blackColor),
//                   ),
//                   gapHeight(sp8),
//                   Container(
//                     constraints: const BoxConstraints(
//                       minWidth: 100,
//                       maxWidth: 300,
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: sp4,
//                       horizontal: sp8,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(sp8),
//                       color: getBackgroundColorByStatus(
//                         state.order?.status?.code ?? '',
//                       ),
//                     ),
//                     child: Text(
//                       state.order?.status?.name ?? '',
//                       style: p5.copyWith(
//                         color: getColorByStatus(
//                           state.order?.status?.code ?? '',
//                         ),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   gapHeight(sp16),
//                   RowItem(
//                     title: 'Người tạo',
//                     content: state.order?.userCreated ?? 'Chưa có thông tin',
//                   ),
//                   gapHeight(sp12),
//                   RowItem(
//                     title: 'Thời gian tạo',
//                     content: DateFormat('H:m dd/M/y').format(
//                       state.order?.createdAt ?? DateTime.now(),
//                     ),
//                   ),
//                   gapHeight(sp12),
//                   RowItem(
//                     title: 'Người cập nhật',
//                     content: state.order?.userUpdated ?? 'Chưa có thông tin',
//                   ),
//                   gapHeight(sp12),
//                   RowItem(
//                     title: 'Thời gian cập nhật',
//                     content: state.order?.updatedAt == null
//                         ? 'Chưa có cập nhật'
//                         : DateFormat('H:m dd/M/y')
//                             .format(state.order!.updatedAt!),
//                   ),
//                 ],
//               ),
//             ),
//             gapHeight(sp16),
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(sp12),
//                 color: whiteColor,
//                 boxShadow: [
//                   BoxShadow(
//                     color: blackColor.withOpacity(0.1),
//                     blurRadius: sp4,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: sp8,
//                       horizontal: sp16,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(sp12),
//                       ),
//                       color: accentColor_4.withOpacity(0.5),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.person,
//                           color: greyTextColor,
//                         ),
//                         gapWidth(sp12),
//                         Text(
//                           'Thông tin khách hàng',
//                           style: p3.copyWith(color: greyTextColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(sp16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           state.order?.customer?.name ?? 'Khách lẻ',
//                           style: p3.copyWith(color: blackColor),
//                         ),
//                         gapHeight(sp4),
//                         Text(
//                           state.order?.customer?.phone ?? 'Chưa có thông tin',
//                           style: p5.copyWith(color: greyTextColor),
//                         ),
//                         gapHeight(sp4),
//                         Text(
//                           formatAddress(state.order?.customer?.address),
//                           style: p5.copyWith(color: greyTextColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             gapHeight(sp16),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(sp16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(sp12),
//                 color: whiteColor,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Thông tin thanh toán',
//                     style: h6.copyWith(color: blackColor.withOpacity(0.6)),
//                   ),
//                   gapHeight(sp24),
//                   Text(
//                     '${FormatCurrency(state.order?.totalPrice)} VNĐ',
//                     style: h6.copyWith(color: mainColor),
//                   ),
//                   gapHeight(sp8),
//                   Text(
//                     'Thuế tổng đơn: ${state.order?.vat ?? 0}%',
//                     style: p5.copyWith(color: blackColor),
//                   ),
//                   gapHeight(sp16),
//                   RowItem(
//                     title: 'Chiết khấu',
//                     content: state.order?.discount ?? 'Chưa có thông tin',
//                   ),
//                   gapHeight(sp12),
//                   RowItem(
//                     title: 'Phí dịch vụ',
//                     content: '${FormatCurrency(state.order?.servicePrice)} VNĐ',
//                   ),
//                   gapHeight(sp12),
//                   RowItem(
//                     title: 'Khách phải trả',
//                     content:
//                         '${FormatCurrency(state.order?.payment?.needPay)} VNĐ',
//                   ),
//                   gapHeight(sp12),
//                   RowItem(
//                     title: 'Khách đã trả',
//                     content:
//                         '${FormatCurrency(state.order?.payment?.hadPaid)} VNĐ',
//                   ),
//                   gapHeight(sp12),
//                   ListView(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: (state.order?.payment?.items ?? []).map((e) {
//                       return Container(
//                         padding: const EdgeInsets.all(sp16),
//                         margin: const EdgeInsets.only(bottom: sp12),
//                         decoration: BoxDecoration(
//                           color: accentColor_4,
//                           borderRadius: BorderRadius.circular(sp12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 '${e.type?.name ?? ''} (${e.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán'})',
//                                 style: p5.copyWith(
//                                   color: e.isPaid ? mainColor : yellow_1,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 '${FormatCurrency(e.value)} đ',
//                                 style: p5.copyWith(color: blackColor),
//                                 textAlign: TextAlign.right,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//             gapHeight(sp16),
//             // CupertinoSlidingSegmentedControl<OrderDetailTab>(
//             //   backgroundColor: greyColor.withOpacity(0.1),
//             //   groupValue: _tab,
//             //   children: {
//             //     OrderDetailTab.variant: Container(
//             //       width: widthDevice(context),
//             //       padding: const EdgeInsets.symmetric(vertical: sp8),
//             //       child: Align(
//             //         alignment: Alignment.center,
//             //         child:
//             //             Text('Sản phẩm (${state.order?.items?.length ?? 0})'),
//             //       ),
//             //     ),
//             //     OrderDetailTab.service:
//             //         Text('Dịch vụ (${state.order?.services?.length ?? 0})'),
//             //   },
//             //   onValueChanged: (value) => setState(() {
//             //     if (value == null) return;
//             //     _tab = value;
//             //   }),
//             // ),
//             // gapHeight(sp16),
//             Text(
//               'Danh sách sản phẩm (${_count.toString()})',
//               style: h6.copyWith(color: blackColor),
//             ),
//             gapHeight(sp12),
//             AppInputSupport(
//               hintText: 'Tìm kiếm',
//               prefixIcon: const Icon(Icons.search_rounded),
//               backgroundColor: whiteColor,
//               borderColor: whiteColor,
//               radius: sp12,
//             ),
//             gapHeight(sp16),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return _item(index);
//               },
//               separatorBuilder: (context, index) => gapHeight(sp16),
//               itemCount: int.parse(_count.toString()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottom(OrderDetailState state) {
//     return Visibility(
//       visible: state.order?.status?.code != OrderStatus.complete.code &&
//           state.order?.status?.code != OrderStatus.cancel.code,
//       child: Container(
//         decoration: BoxDecoration(
//           color: whiteColor,
//           boxShadow: [
//             BoxShadow(
//               color: blackColor.withOpacity(0.1),
//               blurRadius: sp4,
//               offset: const Offset(sp0, -1),
//             ),
//           ],
//         ),
//         child: TwoButtonBox(
//           mainTitle: state.order?.status?.code == OrderStatus.inProcess.code
//               ? 'Hoàn thành'
//               : 'Xác nhận',
//           extraTitle: 'Huỷ đơn',
//           extraOnTap: () {
//             DialogUtils.showLoadingDialog(
//               context,
//               'Đang cập nhật đơn hàng.',
//             );
//             myBloc.updateStatus(OrderStatus.cancel.code).then((value) {
//               Navigator.of(context).pop();
//               if (value.code != 200) {
//                 DialogUtils.showErrorDialog(
//                   context,
//                   content: 'Cập nhật đơn thất bại',
//                 );
//               }
//             });
//           },
//           mainOnTap: () {
//             DialogUtils.showLoadingDialog(
//               context,
//               'Đang cập nhật đơn hàng.',
//             );
//             myBloc
//                 .updateStatus(
//               state.order?.status?.code == OrderStatus.inProcess.code
//                   ? OrderStatus.complete.code
//                   : OrderStatus.inProcess.code,
//             )
//                 .then((value) {
//               Navigator.of(context).pop();
//               if (value.code != 200) {
//                 DialogUtils.showErrorDialog(
//                   context,
//                   content: 'Cập nhật đơn thất bại',
//                 );
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   num get _count {
//     var count = 0;
//     switch (_tab) {
//       case OrderDetailTab.service:
//         count = myBloc.state.order?.services?.length ?? 0;
//         break;
//       default:
//         count = myBloc.state.order?.items?.length ?? 0;
//     }
//     return count;
//   }
//
//   Widget _item(int index) {
//     switch (_tab) {
//       case OrderDetailTab.service:
//         final item = myBloc.state.order?.services?[index];
//         return _cardService(item);
//       default:
//         final item = myBloc.state.order?.items?[index];
//         return _cardVariant(item);
//     }
//   }
//
//   Widget _cardVariant(OrderItemEntity? item) {
//     return Container(
//       padding: const EdgeInsets.all(sp16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(sp12),
//         color: whiteColor,
//       ),
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.all(0),
//             leading: SizedBox(
//               height: sp48,
//               width: sp48,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(sp8),
//                 child: BaseCacheImage(
//                   url: item?.variant?.media ?? PrefKeys.imgProductDefault,
//                 ),
//               ),
//             ),
//             title: Text(
//               item?.variant?.name ?? 'Chưa có dữ liệu',
//               style: p5.copyWith(color: blackColor),
//             ),
//             subtitle: Text(
//               item?.variant?.code ?? 'Chưa có dữ liệu',
//               style: p6.copyWith(color: greyColor),
//             ),
//           ),
//           gapHeight(sp12),
//           RowItem(
//             title: 'Số lượng bán',
//             content: item?.value.toString() ?? 'Chưa có thông tin',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _cardService(ServiceItemEntity? item) {
//     return Container(
//       padding: const EdgeInsets.all(sp16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(sp12),
//         color: whiteColor,
//       ),
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.all(0),
//             leading: SizedBox(
//               height: sp48,
//               width: sp48,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(sp8),
//                 child: const BaseCacheImage(
//                   url: PrefKeys.imgProductDefault,
//                 ),
//               ),
//             ),
//             title: Text(
//               item?.service?.title ?? 'Chưa có dữ liệu',
//               style: p5.copyWith(color: blackColor),
//             ),
//             subtitle: Text(
//               item?.service?.code ?? 'Chưa có dữ liệu',
//               style: p6.copyWith(color: greyColor),
//             ),
//           ),
//           gapHeight(sp12),
//           RowItem(
//             title: 'Đơn giá',
//             content: '${FormatCurrency(item?.unitPrice)}VNĐ',
//           ),
//         ],
//       ),
//     );
//   }
// }
