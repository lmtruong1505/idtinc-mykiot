import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/input/app_input.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../router/router.gr.dart';
import '../cubit/order_detail_cubit/order_detail_cubit.dart';
import '../cubit/order_list_cubit/order_list_cubit.dart';
import '../cubit/order_list_cubit/order_list_state.dart';
import '../domain/entities/order_preview_entity.dart';
import '../widgets/bts_chose_type_order.dart';
import '../widgets/bts_filter_order.dart';

@RoutePage()
class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final myBloc = getIt.get<OrderListCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBloc.getList(0);
  }

  @override
  Widget build(BuildContext context) {
    //return _bodyV1();
    return Scaffold(
      appBar: const BaseAppBar(title: 'Danh sách đơn hàng'),
      body: BlocBuilder<OrderListCubit, OrderListState>(
        bloc: myBloc,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => myBloc.infiniteListController.onRefresh(),
            child: SingleChildScrollView(
              controller: myBloc.scrollController,
              padding: sp16.pading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainButtonV2(
                    title: 'Thêm mới',
                    radius: 8,
                    onTap: () {
                      context.bottomSheet(
                        const BtsChoseTypeOrder(),
                      );
                    },
                  ),
                  sp16.height,
                  _buildStatus().size(height: 40),
                  sp16.height,
                  _buildFilter(state),
                  sp16.height,
                  _buildListOrder(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListOrder(BuildContext context) {
    return InfiniteList<OrderPreviewEntity>(
      shrinkWrap: true,
      getData: (page) async {
        return myBloc.getList(page);
      },
      itemBuilder: (context, item, index) {
        return gapHeight(sp0);
        // return ItemOrder(
        //   order: item,
        // );
      },
      scrollController: myBloc.scrollController,
      infiniteListController: myBloc.infiniteListController,
      noItemFoundWidget: emptyOrder(context, myBloc),
      circularProgressIndicator: const BaseLoading(),
    );
  }

  Widget _buildStatus() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => BtnStatusCount(
        onPressed: () {
          myBloc.selectFilterButton(myBloc.state.listFilter[index]);
        },
        title: myBloc.state.listFilter[index].toName,
        isActive: myBloc.state.listFilter[index] == myBloc.state.selectFilter,
        count: _getCount(myBloc.state.listFilter[index].code),
      ),
      separatorBuilder: (context, index) => sp16.width,
      itemCount: myBloc.state.listFilter.length,
    );
  }

  // Widget _bodyV1() {
  //   return BlocProvider<OrderListCubit>(
  //     create: (context) => myBloc,
  //     child: BlocBuilder<OrderListCubit, OrderListState>(
  //       builder: (context, state) {
  //         return Scaffold(
  //           appBar: BaseAppBar(
  //             title: 'Danh sách đơn hàng',
  //             actions: [
  //               InkWell(
  //                 onTap: () => context.router.push(
  //                   OrderCreateRoute(
  //                     onSuccess: () =>
  //                         myBloc.infiniteListController.onRefresh(),
  //                   ),
  //                 ),
  //                 child: const Icon(Icons.add_rounded),
  //               ),
  //               gapWidth(sp16),
  //             ],
  //           ),
  //           body: Container(
  //             width: widthDevice(context),
  //             height: heightDevice(context),
  //             padding: const EdgeInsets.symmetric(
  //               vertical: sp24,
  //               horizontal: sp16,
  //             ),
  //             child: RefreshIndicator(
  //               onRefresh: () async =>
  //                   myBloc.infiniteListController.onRefresh(),
  //               child: SingleChildScrollView(
  //                 controller: myBloc.scrollController,
  //                 physics: const BouncingScrollPhysics(),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     _filterButton(state),
  //                     gapHeight(sp16),
  //                     GestureDetector(
  //                       onTap: () => showModalBottomSheet(
  //                         context: context,
  //                         shape: const RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.vertical(
  //                             top: Radius.circular(sp12),
  //                           ),
  //                         ),
  //                         isScrollControlled: true,
  //                         builder: (context) => _filterBts(state),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           Text(
  //                             'Bộ lọc',
  //                             style: p6.copyWith(color: blackColor),
  //                           ),
  //                           gapWidth(sp8),
  //                           const Icon(
  //                             Icons.filter_alt_outlined,
  //                             color: blackColor,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     gapHeight(sp24),
  //                     InfiniteList<OrderPreviewEntity>(
  //                       shrinkWrap: true,
  //                       getData: (page) async {
  //                         return myBloc.getList(page);
  //                       },
  //                       itemBuilder: (context, item, index) {
  //                         return InkWell(
  //                           onTap: () => context.router.push(
  //                             OrderDetailRoute(id: item.id),
  //                           ),
  //                           child: Container(
  //                             padding: const EdgeInsets.all(sp16),
  //                             decoration: BoxDecoration(
  //                               color: whiteColor,
  //                               borderRadius: BorderRadius.circular(sp12),
  //                             ),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 ListTile(
  //                                   contentPadding: const EdgeInsets.all(sp0),
  //                                   title: Text(
  //                                     item.code ?? 'Chưa có thông tin',
  //                                     style: p5.copyWith(color: blackColor),
  //                                   ),
  //                                   subtitle: Text(
  //                                     item.customerName ?? 'Chưa có thông tin',
  //                                     style: p6.copyWith(color: greyColor),
  //                                   ),
  //                                   trailing: Visibility(
  //                                     visible: item.status?.code !=
  //                                             OrderStatus.complete.code &&
  //                                         item.status?.code !=
  //                                             OrderStatus.cancel.code,
  //                                     child: SizedBox(
  //                                       width: 50,
  //                                       height: 50,
  //                                       child: Column(
  //                                         children:
  //                                             MenuEntry.build(_getMenus(item)),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   padding: const EdgeInsets.symmetric(
  //                                     vertical: sp4,
  //                                   ),
  //                                   width: 133,
  //                                   decoration: BoxDecoration(
  //                                     color: getBackgroundColorByStatus(
  //                                       item.status?.code ?? '',
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(sp8),
  //                                   ),
  //                                   child: Text(
  //                                     item.status?.name ?? 'Chưa có thông tin',
  //                                     style: p5.copyWith(
  //                                       color: getColorByStatus(
  //                                         item.status?.code ?? '',
  //                                       ),
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                                 gapHeight(sp16),
  //                                 RowItem(
  //                                   title: 'Tổng tiền',
  //                                   content:
  //                                       '${FormatCurrency(item.totalPrice)} VNĐ',
  //                                   contetnColor: mainColor,
  //                                 ),
  //                                 gapHeight(sp12),
  //                                 RowItem(
  //                                   title: 'Người tạo',
  //                                   content:
  //                                       item.userCreated ?? 'Chưa có thông tin',
  //                                 ),
  //                                 gapHeight(sp12),
  //                                 RowItem(
  //                                   title: 'Thời gian tạo',
  //                                   content: DateFormat('h:m dd-M-y')
  //                                       .format(item.createdAt!),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       scrollController: myBloc.scrollController,
  //                       infiniteListController: myBloc.infiniteListController,
  //                       noItemFoundWidget: emptyOrder(context, myBloc),
  //                       circularProgressIndicator: const BaseLoading(),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Row _buildFilter(OrderListState state) {
    return Row(
      children: [
        Expanded(
          child: AppInputV2(
            hintText: 'Tìm kiếm theo mã ĐH, tên KH',
            borderColor: ColorApp.greyE2,
            backgroundColor: ColorApp.white,
            radius: Dimensions.sp8,
            prefixIcon: const Icon(
              Icons.search,
              color: ColorApp.black,
            ),
            onChanged: (p0) {
              myBloc.search(p0);
            },
          ),
        ),
        // Dimensions.sp16.width,
        // GestureDetector(
        //   onTap: () => showModalBottomSheet(
        //     context: context,
        //     shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(
        //         top: Radius.circular(sp12),
        //       ),
        //     ),
        //     isScrollControlled: true,
        //     builder: (context) => _filterBts(state),
        //   ),
        //   child: Container(
        //     width: 45,
        //     height: 45,
        //     clipBehavior: Clip.antiAlias,
        //     decoration: ShapeDecoration(
        //       color: Colors.white,
        //       shape: RoundedRectangleBorder(
        //         side: const BorderSide(
        //           width: 1,
        //           color: ColorApp.greyE2,
        //         ),
        //         borderRadius: Dimensions.sp8.radius,
        //       ),
        //     ),
        //     child: Center(
        //       child: Image.asset(
        //         Assets.iconsIcSort,
        //         width: 20,
        //         color: ColorApp.greyAA,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // List<MenuEntry> _getMenus(OrderPreviewEntity value) {
  //   final List<MenuEntry> result = <MenuEntry>[
  //     MenuEntry(
  //       labelWidget: const Icon(
  //         Icons.more_vert_rounded,
  //         color: blackColor,
  //       ),
  //       menuChildren: <MenuEntry>[
  //         MenuEntry(
  //           label: value.status?.code == OrderStatus.draft.code
  //               ? 'Xác nhận đơn'
  //               : 'Hoàn thành đơn',
  //           onPressed: () => _updateHandle(
  //             value,
  //             OrderStatus.inProcess,
  //           ),
  //         ),
  //         // MenuEntry(
  //         //   label: 'Chỉnh sửa đơn',
  //         //   onPressed: () {},
  //         // ),
  //         MenuEntry(
  //           label: 'Huỷ đơn',
  //           onPressed: () => _updateHandle(
  //             value,
  //             OrderStatus.cancel,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ];
  //   return result;
  // }

  void _updateHandle(OrderPreviewEntity order, OrderStatus status) {
    myBloc.updateStatus(order.id!, status).then((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: value.code == 200 ? mainColor : red_1,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Expanded(
                child: Text(
                  'Cập nhât đơn ${value.code == 200 ? 'thành công' : 'thất bại'}',
                ),
              ),
              gapWidth(sp8),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  context.router.push(OrderDetailV2Route(id: order.id ?? -1));
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _filterBts(OrderListState state) {
    return BtsFilterOrder(
      createdAtFrom: state.createdAtFrom,
      createdAtTo: state.createdAtTo,
      updatedFrom: state.updatedFrom,
      updatedTo: state.updatedTo,
      orderBy: state.orderBy,
      onConfirm: myBloc.filterChange,
    );
  }

  Widget _filterButton(OrderListState state) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 36,
        maxHeight: 36,
        maxWidth: widthDevice(context),
        minWidth: widthDevice(context),
      ),
      // width: widthDevice(context),
      // height: 40,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: sp16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => myBloc.selectFilterButton(
              state.listFilter[index],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp8,
                horizontal: sp12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp8),
                color: state.listFilter[index] == state.selectFilter
                    ? mainColor
                    : whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.01),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      state.listFilter[index].toName,
                      style: p5.copyWith(
                        color: state.listFilter[index] == state.selectFilter
                            ? whiteColor
                            : greyColor,
                      ),
                    ),
                    gapWidth(sp4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: sp4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        color: state.listFilter[index] == state.selectFilter
                            ? whiteColor
                            : accentColor_4,
                      ),
                      child: Text(
                        '${_getCount(state.listFilter[index].code)}',
                        style: p8.copyWith(
                          color: mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: state.listFilter.length,
      ),
    );
  }

  int _getCount(String code) {
    switch (code.toLowerCase()) {
      case 'product':
        return myBloc.state.orderCount?.product ?? 0;
      case 'service':
        return myBloc.state.orderCount?.service ?? 0;
      default:
        return (myBloc.state.orderCount?.service ?? 0) +
            (myBloc.state.orderCount?.product ?? 0);
    }
  }
}

Widget emptyOrder(BuildContext context, OrderListCubit myBloc,
    {int? idBranch}) {
  return Container(
    padding: const EdgeInsets.all(sp16),
    width: widthDevice(context),
    margin: const EdgeInsets.symmetric(
      vertical: sp24,
      horizontal: sp16,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(sp8),
      color: whiteColor,
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.1),
          blurRadius: sp4,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IcSvg.asset('/ic_order_empty.svg'),
        gapHeight(sp24),
        Text(
          'Chưa có đơn hàng',
          style: p3.copyWith(color: blackColor),
        ),
        gapHeight(sp8),
        Text(
          'Chưa có đơn bán hàng nào. Hãy tạo đơn bán\nhàng ngày!',
          style: p6.copyWith(color: blackColor),
          textAlign: TextAlign.center,
        ),
        gapHeight(sp24),
        // SizedBox(
        //   width: double.infinity,
        //   child: MainButton(
        //     title: 'Quét đơn thuốc',
        //     event: () {},
        //   ),
        // ),
        // gapHeight(sp16),
        SizedBox(
          width: double.infinity,
          child: MainButton(
            title: 'Tạo đơn hàng',
            event: () => context.bottomSheet(
              BtsChoseTypeOrder(
                idBranch: idBranch,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
