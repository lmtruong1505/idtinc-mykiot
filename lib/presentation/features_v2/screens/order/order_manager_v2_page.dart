import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/bottom_sheet_custom.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features_v2/blocs/order/exprort_invoice_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/order_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/bts/bts_filter_order.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/export_electric_invoice_bottom_sheet.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/item_order.dart';
import 'package:pharmago/presentation/features_v2/screens/order/order_detail_v2.page.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../../shared/components/widgets/empty_view.dart';
import '../../../../shared/components/widgets/search_filter.dart';
import '../../../base/empty_container.dart';
import '../../../base/infinite_list.dart';
import '../../../base/loading.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../../features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import '../../../features/home/home_page.dart';
import '../../../features/notification/cubit/notification_manager_cubit/notification_manager_cubit.dart';
import '../../../features/notification/domain/entities/notification_entity.dart';
import '../../../router/router.gr.dart';
import '../../../shared/utils/event.dart';
import '../../blocs/enum/bloc_status.dart';
import '../../blocs/state/cubit_state.dart';

@RoutePage()
class OrderManagerV2Page extends StatefulWidget {
  const OrderManagerV2Page({super.key});

  @override
  State<OrderManagerV2Page> createState() => _OrderManagerV2PageState();
}

class _OrderManagerV2PageState extends State<OrderManagerV2Page> {
  final bloc = getIt<OrderManagerBloc>();
  final exportInvoiceBloc = getIt<ExprortInvoiceBloc>();
  final notiBloc = getIt.get<NotificationManagerCubit>();
  final scroll = ScrollController();
  final textCtrl = TextEditingController();
  String _page = 'ORDER';

  @override
  void initState() {
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
    bloc.init();
    exportInvoiceBloc.getListSerial();
    super.initState();
  }

  @override
  void dispose() {
    scroll.dispose();
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthWsManagerCubit, AuthWsManagerState>(
      bloc: getIt.get<AuthWsManagerCubit>(),
      listener: (context, state) {
        bloc.getList(isMore: false);
      },
      listenWhen: (previous, current) {
        return previous.isAuthen != current.isAuthen;
      },
      child: Scaffold(
        backgroundColor: AppColors.bg_primary,
        appBar: const BaseAppBar(
          title: 'Quản lý đơn hàng',
          elevation: 1,
        ),
        body: Column(
          children: [
            Padding(
              padding: 16.padingHor + 16.padingTop,
              child: CupertinoSlidingSegmentedControl(
                children: {
                  'ORDER': const Text('Đơn hàng').padding(
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                  ),
                  'PRESCRIPTION': const Text('Đơn thuốc').padding(
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                  ),
                },
                groupValue: _page,
                onValueChanged: (value) {
                  setState(() {
                    _page = value ?? _page;
                  });
                },
              ),
            ),
            BlocBuilder<OrderManagerBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                if (_page == 'ORDER') return _buildBody;
                return _prescriptionView;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildBody {
    return Container(
      height: heightDevice(context),
      padding: 16.padingHor + 16.padingTop,
      child: BlocConsumer<OrderManagerBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == BlocStatus.loading &&
              state.isFirst &&
              bloc.list.isEmpty) {
            return const BaseLoading();
          }
          if (state.status == BlocStatus.success &&
              state.isFirst &&
              bloc.list.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EmptyComfirm(
                  labelBtn: 'Tạo đơn',
                  text: 'Chưa có đơn hàng',
                  onPressed: assign,
                  svgAsset: 'assets/icons/ic_cube.svg',
                  suffixIcon: const Icon(
                    Icons.add,
                    color: AppColors.button_brand_solid_iconDefault,
                    size: 20,
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              _buildSearchAndFilter(),
              12.height,
              _buidHeaderList(),
              Visibility(
                visible: bloc.showCheckBox,
                child: Row(
                  children: [
                    BaseCheckbox2(
                      value: (bloc.listSelected?.length ?? 0) == 10 ||
                          bloc.listSelected?.length == bloc.list.length,
                      onChanged: (value) {
                        bloc.selectMax();
                      },
                    ),
                    8.width,
                    Text(
                      'Chọn tối đa (${(bloc.list.length) < 10 ? bloc.list.length : 10} đơn hàng)',
                      style: s14w500.copyWith(height: 1),
                    ),
                    const Spacer(),
                    if (bloc.listSelected?.isNotEmpty == true)
                      MainButtonV2(
                        padding: 8.padingVer + 16.padingHor,
                        radius: 999,
                        backgroundColor: AppColors.brand,
                        onTap: state.status == BlocStatus.loadList
                            ? null
                            : () {
                                // showModalBottomSheet(
                                //   context: context,
                                //   isScrollControlled: true,
                                //   shape: const RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.vertical(
                                //       top: Radius.circular(sp16),
                                //     ),
                                //   ),
                                //   builder: (context) =>
                                //       ExportElectricInvoiceBottomSheet(
                                //     bloc: myBloc,
                                //   ),
                                // );

                                // thêm mới
                                showModalBottomSheetCustom(
                                  context: context,
                                  body: ExportInvoiceBottomSheet(
                                    bloc: exportInvoiceBloc,
                                    onChanged: bloc.selectInvoice,
                                  ),
                                  confirmTitle: 'Phát hành',
                                  title: 'Phát hành HĐĐT',
                                  onConfirm: bloc.createRedInvoice,
                                );
                              },
                        title:
                            '${bloc.invoice != null ? 'Phát hành HĐĐT' : 'Đồng bộ CSDL Dược'}  (${bloc.listSelected?.length})',
                      )
                    else
                      48.height
                  ],
                ).padding(8.padingBottom),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  bloc.getList();
                },
                child: SingleChildScrollView(
                  controller: scroll,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      8.height,
                      if (bloc.list.isEmpty) ...[
                        Image.asset(
                          '${AssetsPath.image}/not_found.png',
                        ).size(height: 200),
                        16.height,
                        Center(
                          child: Text(
                            'Không tìm thấy kết quả',
                            style: AppStyle.headingLg,
                          ),
                        ),
                      ],
                      if (bloc.list.isNotEmpty) _buildTable(state),
                      16.height,
                      if (state.status == BlocStatus.loading)
                        const BaseLoading(),
                      250.height,
                    ],
                  ),
                ),
              ).expanded(),
            ],
          );
        },
        listener: (context, state) {
          if (state.status == BlocStatus.submitFailure) {
            print('listener====reload');
            context.pop();
            DialogUtils.showErrorDialog(
              context,
              content:
                  'Đã có lỗi xảy ra, đồng bộ không thành công\n${state.msg}',
            );
          } else if (state.status == BlocStatus.submitSuccess) {
            context.pop();
          } else if (state.status == BlocStatus.submit) {
            context.pop();

            DialogUtils.showLoadingDialog(
              context,
              'Đang phát hành hoá đơn điện tử',
            );
          }
        },
      ),
    );
  }

  Widget get _prescriptionView {
    return InfiniteList(
      shrinkWrap: true,
      getData: (page) async {
        return notiBloc.getNotifications(page, type: 'prescription');
      },
      itemBuilder: (context, item, index) {
        return InkWell(
          onTap: () {
            context.router.push(
              NotificationDetailRoute(id: item.id!),
            );
          },
          child: _buildRowItem(item),
        );
      },
      scrollController: notiBloc.scrollController,
      infiniteListController: notiBloc.notificationsILC,
      circularProgressIndicator: const BaseLoading(),
      noItemFoundWidget: const EmptyContainer(),
      heightGap: 0,
    ).expanded();
  }

  Widget _buildRowItem(NotificationEntity item) {
    return InkWell(
      onTap: () {
        if (item.canAccess) {
          context.router.push(
            OrderHubActionRoute(notiId: item.id!, dataHub: item.data!),
          );
        }
      },
      child: Container(
        // padding: const EdgeInsets.all(sp16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor_2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Icon(
                item.type?.icon.icon,
                color: item.isRead ? greyColor : mainColor,
                size: sp20,
              ),
            ),
            gapWidth(sp16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: h6.copyWith(
                      color: item.isRead ? greyColor : blackColor,
                    ),
                  ),
                  gapHeight(sp8),
                  Text(
                    item.content ?? '',
                    style: p6.copyWith(
                      color: item.isRead ? greyColor : blackColor,
                    ),
                    maxLines: 3,
                  ),
                  Visibility(
                    visible: !item.canAccess,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: yellow_1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Đơn thuốc đã được nhận',
                        style: p9.copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                  Text(
                    '${timeBetween(startTime: item.createdAt!, endTime: DateTime.now())} trước',
                    style: p9.copyWith(
                      color: item.isRead ? greyColor : blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  assign() {
    BottomBarHome.handleCreateOrder(context);
  }

  Widget _buildSearchAndFilter() {
    return SearchFilterCustom(
      hintText: 'Tìm tên, số điện thoại, mã',
      value: bloc.search,
      onChange: bloc.changeSearch,
      isActive: bloc.isSort,
      controller: textCtrl,
      clear: () {
        bloc.changeSearch(null);
        textCtrl.clear();
      },
      onTap: () {
        context.bottomSheet(
          BtsFilterOrder(
            onChange: (type, status, time, price, invoice, synchronizePharma) =>
                bloc.changeFilter(
              type: type,
              status: status,
              time: time,
              price: price,
              invoice: invoice,
              synchronizePharma: synchronizePharma,
            ),
            type: bloc.type,
            status: bloc.status,
            time: bloc.time,
            price: bloc.price,
            invoice: bloc.invoice,
            synchronizePhama: bloc.synchronizePharma,
          ),
        );
      },
    );
  }

  Column _buidHeaderList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (myBloc.isShowCheckbox) ...[
        //   Row(
        //     children: [
        //       BaseCheckbox2(
        //         onChanged: (value) {
        //           myBloc.onToggleAll(value);
        //         },
        //         value: myBloc.isSelectAll,
        //       ),
        //       8.width,
        //       Text(
        //         'Chọn tất cả',
        //         style: AppStyle.bodyBsMedium
        //             .copyWith(color: AppColors.text_tertiary),
        //       ),
        //       const Spacer(),
        //       InkWell(
        //         onTap: () {},
        //         child: BaseContainer(
        //           borderRadius: 999,
        //           padding: 4.padingVer + 8.padingHor,
        //           child: Row(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Text(
        //                 myBloc.isSelectInvoice
        //                     ? 'Phát hành HĐĐT'
        //                     : 'Đồng bộ CSDL Dược',
        //                 style: AppStyle.bodyBsMedium.copyWith(
        //                   color: AppColors.text_tertiary,
        //                   height: 1,
        //                 ),
        //               ),
        //               8.width,
        //               const Icon(Icons.arrow_forward),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   16.height,
        // ],

        Row(
          children: [
            Text(
              'Tất cả đơn hàng',
              style: AppStyle.bodyBsMedium
                  .copyWith(color: AppColors.text_tertiary),
            ),
          ],
        ),
        // const Divider(
        //   thickness: 1,
        //   color: AppColors.border_tertiary,
        // ),
      ],
    );
  }

  Widget _buildTable(CubitState<dynamic> state) {
    print('myBloc.list.length: ${bloc.list.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildHeader().container(
        //   bgColor: AppColors.bg_secondary_subtle,
        //   radius: 0,
        //   padding: 12.padingHor + 6.padingVer,
        // ),
        const Divider(
          color: AppColors.border_tertiary,
          height: 0,
          thickness: 1,
        ),
        const Divider(
          color: AppColors.border_tertiary,
          height: 0,
          thickness: 1,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bloc.list.length,
          padding: 0.pading,
          itemBuilder: (context, index) {
            return ItemOrderPageV2(
              isSend: state.status == BlocStatus.loadList,
              order: bloc.list[index],
              isBg: index % 2 == 0,
              isShowCheckbox: bloc.isShowCheckbox,
              onChanged: (p0) {
                final prd = bloc.list[index];
                final select = prd.isSelect ?? false;
                final isSelectOrder = bloc.showCheckBox;
                //nếu quá 10sp thì không đc chọn thêm, nhưng có thể bớt
                if (isSelectOrder) {
                  if (select == true) {
                    bloc.onToggleProduct(prd);
                  } else {
                    if (bloc.canSelect) {
                      bloc.onToggleProduct(prd);
                    } else {
                      ToastCustom.show(
                        context,
                        title: 'Cảnh báo',
                        msg: 'Chỉ chọn tối đa 10 đơn hàng',
                      );
                    }
                  }
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Đơn hàng',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(),
        Text(
          'Đã thu',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
          textAlign: TextAlign.end,
        ).expanded(),
      ],
    );
  }
}
