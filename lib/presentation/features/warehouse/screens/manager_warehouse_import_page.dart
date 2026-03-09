import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/manager_import_receipt_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../../../../shared/ext/ext_controller.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';

@RoutePage()
class ManagerWarehouseImportPage extends StatefulWidget {
  const ManagerWarehouseImportPage({
    super.key,
    required this.id,
  });
  final int id;

  @override
  State<ManagerWarehouseImportPage> createState() =>
      _ManagerWarehouseImportPageState();
}

class _ManagerWarehouseImportPageState extends State<ManagerWarehouseImportPage>
    with TickerProviderStateMixin {
  final cubit = getIt.get<ManagerImportReceiptCubit>();
  late ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    cubit.initWarehouse(widget.id);
    _scroll.onMore(() => cubit..getListImportReceipt());
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocProvider<ManagerImportReceiptCubit>(
          create: (context) => cubit,
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: BaseAppBar(
              title: 'Quản lý phiếu nhập kho',
              actions: [
                InkWell(
                  onTap: () async {
                    context.router.push(
                      ReceiptImportCreateRoute(),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Icon(
                      Icons.add,
                      size: sp24,
                      color: blackColor,
                    ),
                  ),
                ),
              ],
            ),
            body: _body(),
          ),
        ),
      );

  Widget _body() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          SearchFilterCustom(
            prefix: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                );
              },
              child: Padding(
                padding: 1.pading.copyWith(right: 0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.bg_secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(999),
                      bottomLeft: Radius.circular(999),
                    ),
                  ),
                  height: 48,
                  width: 48,
                  alignment: Alignment.center,
                  child: FaIcon(iconCode: 'f465', type: FaIconType.solid),
                ),
              ),
            ),
            hintText: 'Nhập mã phiếu',
            onChange: (p0) {
              cubit.onSearch(p0);
            },
            isActive: true,
          ).padding(16.padingHor),
          _tabBar,
          24.height,
          Padding(
            padding: 16.padingHor,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border_secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 44,
              child: BlocBuilder<ManagerImportReceiptCubit, CubitState>(
                builder: (context, state) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final isSelect =
                          cubit.selectTab?.value == cubit.tabs[index].value;
                      return GestureDetector(
                        onTap: () => cubit.changeTab(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelect
                                ? AppColors.bg_primary_active
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              cubit.tabs[index].title,
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
                    itemCount: cubit.tabs.length,
                  );
                },
              ),
            ),
          ),
          8.height,
          Padding(
            padding: 16.pading,
            child: BlocBuilder<ManagerImportReceiptCubit, CubitState>(
              builder: (context, state) {
                return state.status == BlocStatus.loading
                    ? const BaseLoading()
                    : cubit.list.isEmpty
                        ? const EmptyContainer(
                            msg: 'Không có sản phẩm',
                          )
                        : ListView.separated(
                            controller: _scroll,
                            itemBuilder: (context, index) {
                              final data = cubit.list[index];

                              return _receiptItem(data);
                            },
                            separatorBuilder: (context, index) => const Divider(
                              color: AppColors.border_primary,
                            ),
                            itemCount: cubit.list.length,
                          );
              },
            ),
          ).expanded(),
        ],
      );

  Widget get _tabBar {
    return SizedBox(
      width: widthDevice(context),
      child: BlocBuilder<ManagerImportReceiptCubit, CubitState>(
        builder: (context, tabs) {
          final index = cubit.listWareHouse.indexWhere((e) => e.id == cubit.warehouseSelected?.id);
          return TabBar(
            controller:
                TabController(length: cubit.listWareHouse.length, vsync: this, initialIndex: index == -1 ? 0 : index),
            indicatorColor: mainColor,
            labelColor: mainColor,
            unselectedLabelColor: AppColors.text_tertiary,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: cubit.listWareHouse
                .map(
                  (e) => Tab(
                    text: e.title,
                  ),
                )
                .toList(),
            onTap: (value) {
              log('--- value: $value');
              cubit.changeWarehouse(value);
            },
          );
        },
      ),
    );
  }

  Widget _receiptItem(ReceitExportModel data) {
    final code = data.statusData?.code;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.router.push(
          ReceiptImportDetailRoute(id: data.id ?? 0, warehouseId: data.warehouseId ?? 0),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              BaseContainer(
                borderRadius: 999,
                borderColor: getTextColor(code),
                padding: 4.pading,
                color: getColorBackground(code),
                child: Text(
                  data.statusData?.title ?? '',
                  style: s12w500.copyWith(
                    color: getTextColor(code),
                  ),
                ),
              ),
              const Spacer(),
              Text(data.createdAt.fomatCustom()),
            ],
          ),
          Row(
            children: [
              Text(
                data.code ?? '',
                style: s18w700,
              ),
              const Spacer(),
              Text(
                data.totalPrice.formatPrice(type: ' đ'),
                style: s18w700.copyWith(color: AppColors.ultility_brand_60),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Tạo bởi',
                style: s12w400.copyWith(color: AppColors.text_tertiary),
              ),
              const Spacer(),
              Text(
                'Kho chuyển',
                style: s12w400.copyWith(color: AppColors.text_tertiary),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                data.userCreatedData?.fullName ?? '',
                style: s14w500.copyWith(color: AppColors.text_secondary),
              ),
              const Spacer(),
              Text(
                data.warehouseData ?? '',
                style: s14w500.copyWith(color: AppColors.text_secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color? getColorBackground(String? code) {
  if (code == 'CXN') {
    return AppColors.ultility_carrot_20;
  }
  if (code == 'HT') {
    return AppColors.ultility_brand_20;
  }
  if (code == 'ĐTC') {
    return AppColors.ultility_negative_20;
  }

  return AppColors.ultility_carrot_20;
}

Color? getTextColor(String? code) {
  if (code == 'CXN') {
    return AppColors.ultility_carrot_60;
  }
  if (code == 'HT') {
    return AppColors.ultility_brand_60;
  }
  if (code == 'ĐTC') {
    return AppColors.ultility_negative_60;
  }

  return AppColors.ultility_carrot_60;
}
