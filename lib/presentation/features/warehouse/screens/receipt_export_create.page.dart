import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/input/input_column.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/base_buttom_bar.dart';
import '../../../base/button.dart';
import '../../../base/dotted_border_button.dart';
import '../../../base/select.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/spacing.dart';
import '../../../features_v2/models/employee/user_data_model.dart';
import '../../../features_v2/models/product/product_v2_model.dart';
import '../../../router/router.gr.dart';
import '../cubit/receipt_export_create_cubit/receipt_export_create_cubit.dart';
import '../cubit/receipt_export_create_cubit/receipt_export_create_state.dart';
import '../data/models/warehouse_model.dart';
import '../domain/entities/shipment_data_entity.dart';
import '../widgets/receipt_export_product_item.dart';
import 'create_warehouse_receipt_page.dart';

@RoutePage()
class ReceiptExportCreatePage extends StatefulWidget {
  const ReceiptExportCreatePage({super.key, this.shipments});

  final List<ShipmentItemEntity>? shipments;

  @override
  State<ReceiptExportCreatePage> createState() =>
      _ReceiptExportCreatePageState();
}

class _ReceiptExportCreatePageState extends State<ReceiptExportCreatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GlobalKey<FormState> _formInfoBaseKey;
  late GlobalKey<FormState> _shipmentKey;
  late TextEditingController _inputDateCtrl;

  late ReceiptExportCreateCubit _receiptExportCreateCubit;

  @override
  void initState() {
    super.initState();
    _receiptExportCreateCubit = getIt.get<ReceiptExportCreateCubit>();

    _tabController = TabController(vsync: this, length: 2)
      ..addListener(
        () {
          // _receiptExportCreateCubit.stateHandle(indexTab: 1);
        },
      );
    _formInfoBaseKey = GlobalKey<FormState>();
    _shipmentKey = GlobalKey<FormState>();
    _inputDateCtrl = TextEditingController(text: DateTime.now().fomatCustom());
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
    _inputDateCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptExportCreateCubit>(
      create: (context) => _receiptExportCreateCubit..initData(shipments: widget.shipments),
      child: BlocListener<ReceiptExportCreateCubit, ReceiptExportCreateState>(
        listener: (context, state) {
          if (state.errMessage != null) {
            DialogUtils.showErrorDialog(
              context,
              content: state.errMessage!,
            );
          }
        },
        listenWhen: (previous, current) {
          return previous.errMessage != current.errMessage;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBarCustom(
            onBack: () => context.pop(),
            height: 90,
            title: 'Quản lý phiếu xuất kho',
            subTitle: 'Tạo mới phiếu xuất kho',
          ),
          body: Column(
            children: [
              TabBar(
                onTap: (value) {
                  _receiptExportCreateCubit.stateHandle(indexTab: value);
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
              BlocSelector<ReceiptExportCreateCubit, ReceiptExportCreateState,
                  int>(
                selector: (state) {
                  return state.indexTab;
                },
                builder: (context, indexTab) {
                  return IndexedStack(
                    index: indexTab,
                    children: [
                      _formInfoBase,
                      _shipmentsView,
                    ],
                  );
                },
              ).expanded(),
            ],
          ),
          bottomNavigationBar: _bottomNavigationBar,
        ),
      ),
    );
  }

  Widget get _formInfoBase {
    return Form(
      key: _formInfoBaseKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputColumn(
              label: 'Mã phiếu',
              isRequired: true,
              padding: 0.pading,
              maxLength: 30,
              onChanged: (val) => _receiptExportCreateCubit.stateHandle(
                codeReceipt: val,
              ),
              validate: (value) {
                if (value == null || value == '') {
                  return 'Nhập mã phiếu';
                }
                return null;
              },
            ),
            16.height,
            InputColumn(
              controller: _inputDateCtrl,
              readOnly: true,
              label: 'Ngày xuất',
              isRequired: true,
              padding: 0.pading,
              maxLength: 30,
              onTap: () {
                final date = _inputDateCtrl.text.toDateV2;
                showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  locale: const Locale('vi'),
                ).then((value) {
                  if (value != null) {
                    _inputDateCtrl.text = value.fomatCustom();
                    _receiptExportCreateCubit.stateHandle(
                      dateExport: value,
                    );
                  }
                });
              },
              suffixIcon: SizedBox(
                width: 48,
                height: 48,
                child: Center(child: FaIcon(iconCode: 'f133')),
              ),
              validate: (value) {
                if (value == null || value == '') {
                  return 'Nhập ngày nhập';
                }
                return null;
              },
            ),
            16.height,
            BlocSelector<ReceiptExportCreateCubit, ReceiptExportCreateState,
                List<WarehouseModel>>(
              selector: (state) => state.listWareHouse,
              builder: (context, listWareHouse) {
                return CommonDropdown(
                  showIconRemove: false,
                  value: _receiptExportCreateCubit.state.warehouse,
                  borderColor: AppColors.input_borderDefault,
                  items: List.generate(
                    listWareHouse.length,
                    (index) => DropdownMenuItem(
                      value: listWareHouse[index],
                      child: Text(
                        listWareHouse[index].title ?? '',
                      ),
                    ),
                  ),
                  onChanged: (value) => _receiptExportCreateCubit.stateHandle(
                    warehouse: value,
                  ),
                  required: true,
                  label: 'Kho xuất',
                  hintText: 'Chọn kho xuất',
                  color: AppColors.white,
                );
              },
            ),
            16.height,
            InputColumn(
              label: 'Lý do xuất',
              padding: 0.pading,
              maxLength: 30,
              onChanged: (val) => _receiptExportCreateCubit.stateHandle(
                reasonExport: val,
              ),
            ),
            16.height,
            BlocSelector<ReceiptExportCreateCubit, ReceiptExportCreateState,
                List<UserDataModel>>(
              selector: (state) {
                return state.listUser;
              },
              builder: (context, listUser) {
                return CommonDropdown(
                  showIconRemove: false,
                  value: _receiptExportCreateCubit.state.userCheck,
                  borderColor: AppColors.input_borderDefault,
                  items: List.generate(
                    listUser.length,
                    (index) => DropdownMenuItem(
                      value: listUser[index],
                      child: Text(
                        listUser[index].fullName ?? '',
                      ),
                    ),
                  ),
                  onChanged: (value) => _receiptExportCreateCubit.stateHandle(
                    userCheck: value,
                  ),
                  required: true,
                  label: 'Người kiểm tra',
                  hintText: 'Chọn tài khoản',
                  color: AppColors.white,
                );
              },
            ),
          ],
        ).padding(16.pading),
      ),
    );
  }

  Widget get _shipmentsView {
    return Form(
      key: _shipmentKey,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocSelector<ReceiptExportCreateCubit, ReceiptExportCreateState,
                num>(
              selector: (state) => state.totalPrice,
              builder: (context, totalPrice) {
                return Row(
                  children: [
                    Text(
                      'Tổng giá trị phiếu nhập: ',
                      style: s14w400.copyWith(color: AppColors.text_tertiary),
                    ),
                    Text(
                      '${totalPrice.formatCurrency}đ',
                      style: s14w500.copyWith(color: mainColor),
                    ),
                  ],
                );
              },
            ),
            16.height,
            BlocSelector<ReceiptExportCreateCubit, ReceiptExportCreateState,
                List<ProductV2Model>>(
              selector: (state) {
                return state.products;
              },
              builder: (context, products) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return ReceiptExportProductItem(
                      product: item,
                      index: index,
                      callBack: (item) {
                        log('--- ReceiptExportProductItem/callback: ${item.toJson()}');
                        _receiptExportCreateCubit.addProductHandle(
                          product: item,
                          index: index,
                        );
                      },
                      deleteCallback: () {
                        _receiptExportCreateCubit.deleteProductHandle(index);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => 16.height,
                  itemCount: products.length,
                );
              },
            ),
            16.height,
            UploadButton(
              preIcon: FaIcon(iconCode: '2b', color: AppColors.blue60),
              title: 'Thêm lô',
              onTap: _receiptExportCreateCubit.addProductHandle,
            ),
          ],
        ).padding(16.pading),
      ),
    );
  }

  Widget get _bottomNavigationBar {
    return BaseBottomBar(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ExtraButton(
              borderRadius: 999,
              title: 'Hủy bỏ',
              event: () => context.pop(),
              borderColor: borderColor_2,
              largeButton: true,
              icon: null,
            ),
          ),
          sp16.width,
          Expanded(
            child: MainButton(
              radius: 999,
              title: 'Xác nhận',
              event: _confirmHandle,
              largeButton: true,
              icon: null,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmHandle() async {
    final isInforValid = _formInfoBaseKey.currentState!.validate();
    final isShipmentValid = _shipmentKey.currentState!.validate();
    if (!isInforValid || !isShipmentValid) {
      return;
    }
    if (_receiptExportCreateCubit.state.products.isEmpty) {
      _tabController.animateTo(1);
      return;
    }

    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo phiếu xuất',
    );
    final res = await _receiptExportCreateCubit.createExportReceiptHandle();
    if (!mounted) return;
    Navigator.of(context).pop();
    if (res != null) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Tạo phiếu xuất thành công, mã phiếu: $res',
        accept: () {
          context.router.replace(
            ReceiptExportDetailRoute(
              receiptId: res,
            ),
          );
        },
        close: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );
    }
  }
}
