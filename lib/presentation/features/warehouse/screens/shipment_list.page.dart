import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/input/app_input.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/loading.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/shipment_manager_cubit/shipment_manager_cubit.dart';
import '../cubit/shipment_manager_cubit/shipment_manager_state.dart';
import '../domain/entities/shipment_data_entity.dart';
import 'create_warehouse_receipt_page.dart';

@RoutePage()
class ShipmentListPage extends StatefulWidget {
  const ShipmentListPage({super.key});

  @override
  State<ShipmentListPage> createState() => _ShipmentListPageState();
}

class _ShipmentListPageState extends State<ShipmentListPage> {
  final _shipmentManagerCubit = getIt.get<ShipmentManagerCubit>();
  final _scrollCtl = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollCtl.addListener(
      () {
        if (_scrollCtl.position.pixels >=
            _scrollCtl.position.maxScrollExtent - 200) {
          _shipmentManagerCubit.getListShipment();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShipmentManagerCubit>(
      create: (context) => _shipmentManagerCubit,
      child: Scaffold(
        appBar: AppBarCustom(
          onBack: () => context.pop(),
          height: 90,
          title: 'Quản lý kho hàng',
          subTitle: 'Danh sách lô hàng',
        ),
        body: Container(
          width: widthDevice(context),
          height: heightDevice(context),
          padding: const EdgeInsets.all(sp16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchView,
              16.height,
              Expanded(child: _listView),
              BlocSelector<ShipmentManagerCubit, ShipmentManagerState, bool>(
                selector: (state) => state.isLoadMore,
                builder: (context, isLoadMore) =>
                    isLoadMore ? const BaseLoading() : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _searchView {
    return Row(
      children: [
        Expanded(
          child: AppInputV2(
            hintText: 'Nhập mã lô, mã phiếu, tên sp',
            radius: sp48,
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: sp20,
            ),
            suffixIcon: SizedBox(
              width: sp24,
              child: Center(
                child: FaIcon(iconCode: 'f465'),
              ),
            ),
            onChanged: _shipmentManagerCubit.searchHandle,
          ),
        ),
        16.width,
        // GestureDetector(
        //   onTap: _calendarHanle,
        //   child: CircleAvatar(
        //     backgroundColor: AppColors.checkbox_backgroundDefault,
        //     radius: sp24,
        //     child: FaIcon(
        //       iconCode: 'f073',
        //       color: AppColors.icon_iconPrimary,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget get _listView {
    return BlocBuilder<ShipmentManagerCubit, ShipmentManagerState>(
      builder: (context, state) {
        if (state.listWareHouse.isEmpty) {
          return const SizedBox();
        }
        // if (state.isLoadMore) {
        //   return const BaseLoading();
        // }
        return RefreshIndicator(
          onRefresh: () async {
            _shipmentManagerCubit.refreshList();
          },
          child: ListView.separated(
            controller: _scrollCtl,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = state.list[index];
              if (index == 0) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: sp12),
                          padding: const EdgeInsets.symmetric(
                            vertical: sp2,
                            horizontal: sp8,
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.border_secondary),
                            borderRadius: BorderRadius.circular(sp12),
                          ),
                          child: Text(
                            item.createdAt.fomatCustom(),
                            style: s14w400.copyWith(
                              color: AppColors.text_secondary,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                    _shipmentViewItem(item),
                  ],
                );
              }
              return _shipmentViewItem(item);
            },
            separatorBuilder: (context, index) {
              final item = state.list[index + 1];
              final itemBefore = state.list[index];
              if (item.createdAt.fomatCustom() !=
                  itemBefore.createdAt.fomatCustom()) {
                return Row(
                  children: [
                    const Expanded(
                      child: Divider(),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: sp12),
                      padding: const EdgeInsets.symmetric(
                        vertical: sp2,
                        horizontal: sp8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border_secondary),
                        borderRadius: BorderRadius.circular(sp12),
                      ),
                      child: Text(
                        item.createdAt.fomatCustom(),
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(),
                    ),
                  ],
                );
              }
              return const Divider();
            },
            itemCount: state.list.length,
          ),
        );
      },
    );
  }

  Widget _shipmentViewItem(ShipmentItemEntity item) {
    return InkWell(
      onTap: () => context.router.push(
        ShipmentDetailRoute(shipment: item),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp2,
                  horizontal: sp8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: item.borderChip),
                  borderRadius: BorderRadius.circular(sp12),
                  color: item.bgChip,
                ),
                child: Text(
                  item.titleChip,
                  style: s12w500.copyWith(
                    color: item.colorTitleChip,
                  ),
                ),
              ),
              Text(
                item.currentQuantity.formatCurrency,
                style: s18w500.copyWith(color: item.colorTitleChip),
              ),
            ],
          ),
          4.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.code ?? '',
                style: s18w500.copyWith(color: AppColors.text_primary),
              ),
              Text(
                '/${item.inputQuantity.formatCurrency} đơn vị',
                style: s14w400.copyWith(color: AppColors.text_quaternary),
              ),
            ],
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mã phiếu',
                style: s12w400.copyWith(color: AppColors.text_tertiary),
              ),
              Text(
                'Hạn sử dụng',
                style: s12w400.copyWith(color: AppColors.text_tertiary),
              ),
            ],
          ),
          4.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.importReceiptData?.code ?? '',
                style: s14w500.copyWith(color: AppColors.text_secondary),
              ),
              Text(
                item.endDate.fomatCustom(),
                style: s14w500.copyWith(color: AppColors.text_secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
