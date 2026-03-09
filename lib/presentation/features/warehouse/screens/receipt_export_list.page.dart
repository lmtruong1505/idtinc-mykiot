import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../base/app_bar.dart';
import '../../../base/dialog.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../cubit/receipt_export_manager_cubit/receipt_export_manager_cubit.dart';
import '../cubit/receipt_export_manager_cubit/receipt_export_manager_state.dart';
import '../domain/entities/receipt_export_entity.dart';

@RoutePage()
class ReceiptExportListPage extends StatefulWidget {
  const ReceiptExportListPage({super.key});

  @override
  State<ReceiptExportListPage> createState() => _ReceiptExportListPageState();
}

class _ReceiptExportListPageState extends State<ReceiptExportListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _receiptExportManagerCubit = getIt.get<ReceiptExportManagerCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptExportManagerCubit>(
      create: (context) => _receiptExportManagerCubit,
      child: BlocListener<ReceiptExportManagerCubit, ReceiptExportManagerState>(
        listener: (context, state) {
          _tabController =
              TabController(length: state.listWareHouse.length, vsync: this);
        },
        child: Scaffold(
          appBar: BaseAppBar(
            title: 'Quản lý phiếu xuất kho',
            actions: [
              InkWell(
                onTap: () => context.router.push(
                  ReceiptExportCreateRoute(),
                ),
                child: const Icon(
                  Icons.add,
                  size: sp24,
                  color: blackColor,
                ),
              ),
              12.width,
            ],
          ),
          body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            padding: const EdgeInsets.all(sp16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchView,
                _tabBar,
                Expanded(child: _listView),
              ],
            ),
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
            hintText: 'Nhập mã phiếu',
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
          ),
        ),
        16.width,
        GestureDetector(
          onTap: _calendarHanle,
          child: CircleAvatar(
            backgroundColor: AppColors.checkbox_backgroundDefault,
            radius: sp24,
            child: FaIcon(
              iconCode: 'f073',
              color: AppColors.icon_iconPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _tabBar {
    return BlocSelector<ReceiptExportManagerCubit, ReceiptExportManagerState,
        bool>(
      selector: (state) {
        return state.isLoadingListWareHouse;
      },
      builder: (context, isLoadingListWareHouse) {
        if (isLoadingListWareHouse) {
          return const LinearProgressIndicator();
        }
        return SizedBox(
          width: widthDevice(context),
          child: BlocSelector<ReceiptExportManagerCubit,
              ReceiptExportManagerState, List<Widget>>(
            selector: (state) {
              return state.getTabs;
            },
            builder: (context, tabs) {
              if (tabs.isEmpty) return const SizedBox();
              final index = _receiptExportManagerCubit.state.listWareHouse.indexWhere((e) {
                return e.id == _receiptExportManagerCubit.state.warehouse?.id;
              });
              _tabController.animateTo(index);
              return TabBar(
                controller: _tabController,
                indicatorColor: mainColor,
                labelColor: mainColor,
                unselectedLabelColor: AppColors.text_tertiary,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: tabs,
                onTap: (value) {
                  log('--- value: $value');
                  _receiptExportManagerCubit.warehouseSelectHandle(value);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget get _listView {
    return BlocBuilder<ReceiptExportManagerCubit, ReceiptExportManagerState>(
      builder: (context, state) {
        if (state.listWareHouse.isEmpty) {
          return const SizedBox();
        }
        if (state.isLoadMore) {
          return const BaseLoading();
        }
        return RefreshIndicator(
          onRefresh: () async {
            _receiptExportManagerCubit.refreshList();
          },
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = state.receipts[index];
              return _receiptViewItem(item);
            },
            separatorBuilder: (context, index) => const Divider(height: sp24),
            itemCount: state.receipts.length,
          ),
        );
      },
    );
  }

  Widget _receiptViewItem(ReceiptExportEntity item) {
    return InkWell(
      onTap: () => context.router.push(
        ReceiptExportDetailRoute(receiptId: item.id!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  item.code ?? '',
                  style: s18w500.copyWith(color: AppColors.text_primary),
                ),
              ),
              sp16.width,
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.createdAt.fomatCustom(),
                      style: s14w400.copyWith(color: AppColors.text_quaternary),
                    ),
                    Text(
                      '${item.totalPrice.formatCurrency}đ',
                      style: s18w500.copyWith(color: AppColors.green60),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tạo bởi',
                style: s12w400.copyWith(color: AppColors.text_primary),
              ),
              Text(
                'Kho xuất',
                style: s12w400.copyWith(color: AppColors.text_primary),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.userCreatedData?.fullName ?? '',
                style: s14w500.copyWith(color: AppColors.text_secondary),
              ),
              Text(
                _receiptExportManagerCubit.state.warehouse?.title ?? '',
                style: s14w500.copyWith(color: AppColors.text_secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _calendarHanle() {
    DialogUtils.showCalendarDialog(
      context,
      selectedDate: [null, null],
      onConfirm: (p0) {
        // dateChanged?.call(p0);
      },
    );
  }
}
