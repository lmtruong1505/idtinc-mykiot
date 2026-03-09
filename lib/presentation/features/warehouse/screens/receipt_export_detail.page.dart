import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../cubit/receipt_export_manager_cubit/receipt_export_manager_cubit.dart';
import '../cubit/receipt_export_manager_cubit/receipt_export_manager_state.dart';
import '../domain/entities/receipt_export_entity.dart';
import 'create_warehouse_receipt_page.dart';

@RoutePage()
class ReceiptExportDetailPage extends StatefulWidget {
  const ReceiptExportDetailPage({
    super.key,
    required this.receiptId,
  });

  final int receiptId;

  @override
  State<ReceiptExportDetailPage> createState() =>
      _ReceiptExportDetailPageState();
}

class _ReceiptExportDetailPageState extends State<ReceiptExportDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _receiptExportManagerCubit = getIt.get<ReceiptExportManagerCubit>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _receiptExportManagerCubit
        ..getDetailReceipt(
          widget.receiptId,
        ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBarCustom(
          onBack: () => context.pop(),
          height: 90,
          title: 'Quản lý phiếu xuất kho',
          subTitle: 'Chi tiết phiếu xuất kho',
        ),
        body: Container(
          height: heightDevice(context),
          child: Column(
            children: [
              TabBar(
                onTap: (value) {
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Thông tin cơ bản'),
                  Tab(text: 'Lô hàng'),
                ],
                unselectedLabelColor: AppColors.text_tertiary,
                indicatorColor: AppColors.brand,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: s14w500.copyWith(color: AppColors.brand),
              ),
              IndexedStack(
                index: _tabController.index,
                children: [
                  _formInfoBase,
                  _shipmentsView,
                ],
              ).expanded(),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _formInfoBase {
    return BlocBuilder<ReceiptExportManagerCubit, ReceiptExportManagerState>(
      builder: (context, state) {
        final info = state.receipt;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseContainer(
              padding: const EdgeInsets.all(sp16),
              child: Column(
                children: [
                  RowItem(
                    title: 'Mã phiếu',
                    content: info?.code ?? '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Ngày tạo',
                    content: info?.createdAt.fomatCustom() ?? '',
                  ),
                  // 8.height,
                  // RowItem(
                  //   title: 'Kho xuất',
                  //   content: info?.code ?? '',
                  // ),
                  8.height,
                  RowItem(
                    title: 'Giá trị xuất',
                    content: info?.totalPrice.formatCurrency ?? '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Lý do xuất',
                    content: info?.reason ?? '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Nhà cung cấp',
                    content: '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Người kiểm tra',
                    content: '',
                  ),
                ],
              ),
            ),
            16.height,
            BaseContainer(
              padding: const EdgeInsets.all(sp16),
              child: Column(
                children: [
                  RowItem(
                    title: 'Thời gian tạo',
                    content: info?.createdAt.fomatCustom() ?? '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Người tạo',
                    content: info?.userCreatedData?.fullName ?? '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Thời gian cập nhật',
                    content: info?.updatedAt.fomatCustom() ?? '',
                  ),
                  8.height,
                  RowItem(
                    title: 'Người cập nhật',
                    content: info?.userUpdatedData?.fullName ?? '',
                  ),
                ],
              ),
            ),
          ],
        ).padding(16.pading);
      },
    );
  }

  Widget get _shipmentsView {
    return BlocSelector<ReceiptExportManagerCubit, ReceiptExportManagerState,
        List<ReceiptItemEntity>>(
      selector: (state) {
        return state.receiptItems;
      },
      builder: (context, receiptItems) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final item = receiptItems[index];
                  return Column(
                    children: [
                      RowItem(
                        title: item.shipmentData?.code ?? '',
                        titleStyle:
                            s18w500.copyWith(color: AppColors.text_primary),
                        content: item.exportNumber.formatCurrency,
                        contetnStyle:
                            s18w500.copyWith(color: AppColors.green60),
                      ),
                      sp8.height,
                      RowItem(
                        title: item.totalExportPrice.formatCurrency,
                        titleStyle:
                            s12w400.copyWith(color: AppColors.text_tertiary),
                        content: item.exportUnitData.toString(),
                        contetnStyle:
                            s14w500.copyWith(color: AppColors.text_quaternary),
                      ),
                      sp8.height,
                      Row(
                        children: [
                          BaseCacheImage(
                            loadPharmagoLogo: true,
                            url: '',
                            width: sp48,
                            height: sp48,
                            borderRadius: 4.radius,
                            fit: BoxFit.cover,
                          ),
                          12.width,
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.productData?.name ?? '',
                              style: s12w400,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Ngày sản xuất',
                                  style: s12w400.copyWith(
                                      color: AppColors.text_tertiary),
                                ),
                                Text(item.shipmentData?.startDate
                                        .fomatCustom() ??
                                    ''),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Hạn sử dụng',
                                  style: s12w400.copyWith(
                                      color: AppColors.text_tertiary),
                                ),
                                Text(item.shipmentData?.endDate.fomatCustom() ??
                                    ''),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: sp24);
                },
                itemCount: receiptItems.length,
              ),
            ),
          ],
        );
      },
    ).padding(16.pading);
  }
}
