import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_cubit_v2.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:toastification/toastification.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../company/screen_v2/components/setup_auth_code.dart';

@RoutePage()
class WarehouseListPageV2 extends StatefulWidget {
  const WarehouseListPageV2({super.key});

  @override
  State<WarehouseListPageV2> createState() => _WarehouseListPageV2State();
}

class _WarehouseListPageV2State extends State<WarehouseListPageV2> {
  final myBloc = getIt.get<WarehouseCubitV2>();
  late ScrollController _scroll;

  final timeFilter = [
    const FilterButtonModel(title: '14 ngày', value: 14),
    const FilterButtonModel(title: '30 ngày', value: 30),
    const FilterButtonModel(title: '90 ngày', value: 90),
  ];
  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    _scroll.onMore(() => myBloc.getListInventory(isMore: true));
    myBloc.initData(timeFilter.last);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocProvider(
          create: (context) => myBloc
            ..getListWareHouse()
            ..getListInventory(),
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: BaseAppBar(
              title: 'Danh sách kho',
              actions: [
                BlocBuilder<WarehouseCubitV2, WarehouseState>(
                  builder: (context, state) {
                    return PopupMenuButton(
                      offset: const Offset(0, 30),
                      borderRadius: BorderRadius.circular(sp12),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<String>(
                            value: '1',
                            child: Text('Tạo phiếu nhập'),
                          ),
                          const PopupMenuItem<String>(
                            value: '2',
                            child: Text('Tạo phiếu xuất'),
                          ),
                          const PopupMenuItem<String>(
                            value: '3',
                            child: Text('Tạo mới kho'),
                          ),
                          const PopupMenuItem<String>(
                            value: '4',
                            child: Text('Xem chi tiết kho'),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        switch (value) {
                          case '1':
                            context.router.push(
                              ReceiptImportCreateRoute(),
                            );
                          case '2':
                            break;
                          case '3':
                            context.router.push(
                              WarehouseCreateRoute(),
                            );
                            break;
                          case '4':
                            if (state.warehouseSelect?.id == null) return;
                            context.router.push(
                              WarehouseDetailRoute(
                                  warehouse: state.warehouseSelect!.id!),
                            );
                            break;
                          default:
                        }
                      },
                    );
                  },
                ),
                // InkWell(
                //   onTap: () async {
                //     await context.router.push(
                //       const WarehouseCreateRoute(),
                //     );
                //     myBloc.warehouseILC.onRefresh();
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                //     decoration: const BoxDecoration(color: Colors.white),
                //     child: const Icon(
                //       Icons.more_horiz,
                //       size: sp24,
                //       color: blackColor,
                //     ),
                //   ),
                // ),
              ],
            ),
            body: _body(),
          ),
        ),
      );

  Widget _body() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: BlocBuilder<WarehouseCubitV2, WarehouseState>(
              builder: (context, state) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final warehouse = state.listWareHouse[index];
                    final isSelect = state.warehouseSelect?.id == warehouse.id;
                    return GestureDetector(
                      onTap: () => myBloc.warehouseChange(
                        state.listWareHouse[index],
                      ),
                      onLongPress: () {
                        log('--- handle long press');
                        _authCodeLongPressCallback();
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                warehouse.title,
                                style: s14w400.copyWith(
                                  color: isSelect
                                      ? ColorApp.main
                                      : AppColors.black,
                                ),
                              ),
                              4.width,
                              // Visibility(
                              //   visible:
                              //       warehouse.totalShipmentNearDate != null,
                              //   child: Text(
                              //     '(${warehouse.totalShipmentNearDate.formatCurrency})',
                              //     style: s14w400.copyWith(
                              //       color: isSelect
                              //           ? ColorApp.main
                              //           : AppColors.black,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ).padding(8.padingVer),
                          SizedBox(
                            width: 100,
                            child: Divider(
                              height: 2,
                              color: isSelect
                                  ? ColorApp.main
                                  : AppColors.bg_primary,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 8.width,
                  itemCount: state.listWareHouse.length,
                );
              },
            ),
          ),
          16.height,
          SearchFilterCustom(
            hintText: 'Tìm kiếm sản phẩm',
            onChange: (p0) {
              myBloc.searchChange(p0);
            },
            isActive: true,
            onTap: () {},
          ).padding(16.padingHor),
          24.height,
          const Text(
            'Số ngày sắp hết hạn',
            style: s14w500,
          ).padding(16.padingHor),
          8.height,
          Padding(
            padding: 16.padingHor,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border_secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 44,
              child: BlocBuilder<WarehouseCubitV2, WarehouseState>(
                builder: (context, state) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final isSelect =
                          state.filter?.value == timeFilter[index].value;
                      return GestureDetector(
                        onTap: () => myBloc.changeTimeFilter(timeFilter[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelect
                                ? AppColors.bg_primary_active
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              timeFilter[index].title,
                              style: s14w400.copyWith(
                                color:
                                    isSelect ? ColorApp.main : AppColors.black,
                              ),
                            ).padding(8.padingHor),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 44,
                      width: 1,
                      color: AppColors.border_secondary,
                    ),
                    itemCount: timeFilter.length,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: 16.pading,
            child: BlocBuilder<WarehouseCubitV2, WarehouseState>(
              builder: (context, state) {
                return state.isLoading
                    ? const BaseLoading()
                    : state.inventories.isEmpty
                        ? const EmptyContainer(
                            msg: 'Không có sản phẩm',
                          )
                        : ListView.separated(
                            controller: _scroll,
                            itemBuilder: (context, index) {
                              final inventory = state.inventories[index];
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  context.router.push(
                                    ProductDetailV2Route(
                                      id: inventory.product?.id ?? 0,
                                      onRefresh: () {},
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        BaseCacheImage(
                                          url: inventory.product?.image
                                                  ?.firstOrNull?.url ??
                                              '',
                                          width: 64,
                                          height: 64,
                                          borderRadius: 4.radius,
                                          fit: BoxFit.cover,
                                          loadPharmagoLogo: true,
                                        ),
                                        16.width,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              inventory.product?.code ?? '',
                                              style: s12w400.copyWith(
                                                color: AppColors.text_primary,
                                              ),
                                            ),
                                            4.height,
                                            Text(
                                              inventory.product?.productName ??
                                                  '',
                                              style: s12w500,
                                            ),
                                            4.height,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Tồn ',
                                                    style: s12w400.copyWith(
                                                      color: AppColors
                                                          .text_primary,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: (inventory
                                                                    .inventory ??
                                                                0)
                                                            .formatPrice(),
                                                        style: s12w500,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Số lô ',
                                                    style: s12w400.copyWith(
                                                      color: AppColors
                                                          .text_primary,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: inventory
                                                            .totalShipment
                                                            .formatCurrency,
                                                        style: s12w500,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ).expanded(),
                                      ],
                                    ),
                                    12.height,
                                    Container(
                                      padding: 12.pading,
                                      decoration: BoxDecoration(
                                        color: AppColors.bg_secondary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Cận date',
                                                style: s12w500.copyWith(
                                                  color: AppColors.text_primary,
                                                ),
                                              ),
                                              8.height,
                                              RichText(
                                                text: TextSpan(
                                                  text: inventory
                                                      .quantityNearDate
                                                      .formatCurrency,
                                                  style: s16w500.copyWith(
                                                    color:
                                                        AppColors.text_warning,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          ' (trong ${inventory.totalShipmentNearDate.formatCurrency} lô)',
                                                      style: s12w500.copyWith(
                                                        color: AppColors
                                                            .text_primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ).expanded(),
                                          Container(
                                            color: AppColors.border_tertiary,
                                            width: 1,
                                            height: 44,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Hết hạn',
                                                style: s12w500.copyWith(
                                                  color: AppColors.text_primary,
                                                ),
                                              ),
                                              8.height,
                                              Text(
                                                inventory.quantityExpDate
                                                    .formatCurrency,
                                                style: s16w500.copyWith(
                                                  color: AppColors.red60,
                                                ),
                                              ),
                                            ],
                                          ).expanded(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => 16.height,
                            itemCount: state.inventories.length,
                          );
              },
            ),
          ).expanded(),
        ],
      );

  void _authCodeLongPressCallback() async {
    final cubit = getIt.get<AuthWsManagerCubit>();
    final isAuth = cubit.state.isAuthen;
    if (!isAuth) {
      await AuthWsInputDialog.show(
        context,
        title: 'Nhập mã xác thực',
        callBack: (value) {
          cubit.verifyCode(getCompany!, value).then(_logHandle);
        },
      );
    } else {
      cubit.stateChange(isAuth: !isAuth);
    }
    myBloc.getListWareHouse();
  }

  void _logHandle(bool isSuccess) {
    print(isSuccess);
    // final cubit = getIt.get<AuthWsManagerCubit>();
    if (isSuccess) {
      Navigator.of(context).pop();
      myBloc.getListInventory();
      // cubit.stateChange(isAuth: !cubit.state.isAuthen);
    } else {
      toastification.show(
        title: const Text('Xác thực thất bại'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }
}

class FilterButtonModel {
  final String title;
  final dynamic value;

  const FilterButtonModel({
    required this.title,
    this.value,
  });
}
