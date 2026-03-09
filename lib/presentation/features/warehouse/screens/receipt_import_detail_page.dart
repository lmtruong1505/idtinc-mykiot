import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/receipt_import_detail_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/screens/create_warehouse_receipt_page.dart';
import 'package:pharmago/presentation/features/warehouse/widgets/warehouse_infor_widget.dart';
import 'package:pharmago/presentation/features/warehouse/widgets/warehouse_shipment_widget.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';

@RoutePage()
class ReceiptImportDetailPage extends StatefulWidget {
  const ReceiptImportDetailPage({
    super.key,
    required this.id,
    required this.warehouseId,
  });
  final int id;
  final int warehouseId;

  @override
  State<ReceiptImportDetailPage> createState() =>
      _ReceiptImportDetailPageState();
}

class _ReceiptImportDetailPageState extends State<ReceiptImportDetailPage>
    with SingleTickerProviderStateMixin {
  final cubit = getIt.get<ReceiptImportDetailCubit>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    cubit
      ..initReceipt(widget.warehouseId, widget.id)
      ..getReceiptInfor()
      ..getListLot();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocProvider<ReceiptImportDetailCubit>(
          create: (context) => cubit,
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBarCustom(
              onBack: () => context.pop(),
              height: 90,
              title: 'Quản lý phiếu nhập kho',
              subTitle: 'Chi tiết phiếu nhập kho',
              actions: [
                PopupMenuButton(
                  offset: const Offset(0, sp48),
                  padding: const EdgeInsets.fromLTRB(sp8, sp8, 0, sp8),
                  splashRadius: sp12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.qr_code_scanner_rounded,
                              size: sp20,
                            ),
                            sp4.width,
                            const Text(
                              'In mã tem',
                              style: s14w400,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_note_rounded,
                              size: sp20,
                            ),
                            sp4.width,
                            const Text(
                              'Chỉnh sửa',
                              style: s14w400,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        if (cubit.list.isNotEmpty) {
                          context.router.push(
                            PreviewPrintCodeTemRoute(
                              shipments: cubit.list,
                            ),
                          );
                        }
                      case 1:
                        if (cubit.list.isNotEmpty) {
                          context.router.push(
                            ReceiptImportCreateRoute(
                              listReceiptItem: cubit.list,
                              receiptDetail: cubit.detail,
                            ),
                          );
                        }
                      default:
                    }
                  },
                ),
              ],
            ),
            // (
            //   title:
            //   actions: [
            //     InkWell(
            //       onTap: () async {
            //         context.router.push(const CreateWarehouseReceiptRoute());
            //       },
            //       child: Container(
            //         margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            //         decoration: const BoxDecoration(color: Colors.white),
            //         child: const Icon(
            //           Icons.add,
            //           size: sp24,
            //           color: blackColor,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            body: _body(),
          ),
        ),
      );

  Widget _body() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            onTap: (value) {},
            padding: EdgeInsets.zero,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Thông tin cơ bản'),
              Tab(text: 'Lô hàng'),
            ],
            unselectedLabelColor: AppColors.grey60,
            indicatorColor: AppColors.brand,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: s16w500.copyWith(color: AppColors.brand),
          ),
          TabBarView(
            controller: _tabController,
            children: [
              WarehouseInforWidget(cubit: cubit),
              WarehouseShipmentWidget(cubit: cubit),
            ],
          ).expanded(),
        ],
      );
}
