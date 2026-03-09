import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/image_picker/domain/entities/image_receipt_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
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
import '../../image_picker/presentation/cubits/image_picker_cubit/image_picker_cubit.dart';
import '../../image_picker/presentation/cubits/image_picker_cubit/image_picker_state.dart';
import '../../image_picker/presentation/widgets/invoice_ai_extract_loading_popup.dart';
import '../../image_picker/presentation/widgets/invoice_ai_extract_response_popup.dart';
import '../cubit/receipt_import_create_cubit/receipt_import_create_cubit.dart';
import '../cubit/receipt_import_create_cubit/receipt_import_create_state.dart';
import '../data/models/receipt_import_detail_model.dart';
import '../data/models/receipt_import_model.dart';
import '../data/models/warehouse_model.dart';
import '../domain/entities/shipment_data_entity.dart';
import '../widgets/receipt_import_create_item.dart';
import 'create_warehouse_receipt_page.dart';

@RoutePage()
class ReceiptImportCreatePage extends StatefulWidget {
  const ReceiptImportCreatePage({
    super.key,
    this.receiptDetail,
    this.listReceiptItem,
  });

  final ReceitExportModel? receiptDetail;
  final List<ReceiptImportDetailModel>? listReceiptItem;

  @override
  State<ReceiptImportCreatePage> createState() =>
      _ReceiptImportCreatePageState();
}

class _ReceiptImportCreatePageState extends State<ReceiptImportCreatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GlobalKey<FormState> _formInfoBaseKey;
  late GlobalKey<FormState> _shipmentKey;
  late TextEditingController _inputDateCtrl;

  late ReceiptImportCreateCubit _receiptImportCreateCubit;
  late ImagePickerCubit _imagePickerCubit;

  @override
  void initState() {
    super.initState();
    _receiptImportCreateCubit = getIt.get<ReceiptImportCreateCubit>();
    _imagePickerCubit = getIt.get<ImagePickerCubit>();

    _tabController = TabController(vsync: this, length: 2)
      ..addListener(
        () {
          // _receiptImportCreateCubit.stateHandle(indexTab: 1);
        },
      );
    _formInfoBaseKey = GlobalKey<FormState>();
    _shipmentKey = GlobalKey<FormState>();
    _inputDateCtrl = TextEditingController(
      text: DateTime.now().fomatCustom(),
    );

    _initShipments();
    _initReceipt();
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
    _inputDateCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReceiptImportCreateCubit>(
          create: (context) => _receiptImportCreateCubit,
        ),
        BlocProvider(
          create: (context) => _imagePickerCubit,
        ),
      ],
      child: BlocListener<ReceiptImportCreateCubit, ReceiptImportCreateState>(
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBarCustom(
              onBack: () => context.pop(),
              height: 90,
              title: 'Quản lý phiếu nhập kho',
              subTitle: widget.receiptDetail == null
                  ? 'Tạo mới phiếu nhập kho'
                  : 'Chỉnh sửa phiếu nhập kho',
            ),
            body: Column(
              children: [
                TabBar(
                  onTap: (value) {
                    _receiptImportCreateCubit.stateHandle(indexTab: value);
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
                BlocSelector<ReceiptImportCreateCubit, ReceiptImportCreateState,
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
              controller: _inputDateCtrl,
              readOnly: true,
              label: 'Ngày nhập',
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
                    _receiptImportCreateCubit.stateHandle(
                      dateImport: value,
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
            BlocSelector<ReceiptImportCreateCubit, ReceiptImportCreateState,
                List<WarehouseModel>>(
              selector: (state) => state.listWareHouse,
              builder: (context, listWareHouse) {
                return CommonDropdown(
                  showIconRemove: false,
                  value: _receiptImportCreateCubit.state.warehouse,
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
                  onChanged: (value) => _receiptImportCreateCubit.stateHandle(
                    warehouse: value,
                  ),
                  required: true,
                  label: 'Kho nhập',
                  hintText: 'Chọn kho nhập',
                  color: AppColors.white,
                );
              },
            ),
            16.height,
            InputColumn(
              label: 'Lý do nhập',
              padding: 0.pading,
              maxLength: 30,
              onChanged: (val) => _receiptImportCreateCubit.stateHandle(
                reason: val,
              ),
            ),
            16.height,
            InputColumn(
              label: 'Người cung cấp',
              hintText: 'Nhập tên nhà cung cấp',
              padding: 0.pading,
              maxLength: 30,
              onChanged: (val) => _receiptImportCreateCubit.stateHandle(
                provider: val,
              ),
            ),
            16.height,
            BlocSelector<ReceiptImportCreateCubit, ReceiptImportCreateState,
                List<UserDataModel>>(
              selector: (state) {
                return state.listUser;
              },
              builder: (context, listUser) {
                return CommonDropdown(
                  showIconRemove: false,
                  value: _receiptImportCreateCubit.state.userCheck,
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
                  onChanged: (value) => _receiptImportCreateCubit.stateHandle(
                    userCheck: value,
                  ),
                  required: true,
                  label: 'Người kiểm tra',
                  hintText: 'Chọn tài khoản',
                  color: AppColors.white,
                );
              },
            ),
            16.height,
            _imagePickerView,
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
            BlocSelector<ReceiptImportCreateCubit, ReceiptImportCreateState,
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
            BlocSelector<ReceiptImportCreateCubit, ReceiptImportCreateState,
                List<ShipmentItemEntity>>(
              selector: (state) {
                return state.shipments;
              },
              builder: (context, shipments) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = shipments[index];
                    return ReceiptImportCreateItem(
                      index: index,
                      shipment: item,
                      callBack: (item) {
                        _receiptImportCreateCubit.shipmentItemChangeInfoHandle(
                          index,
                          item,
                        );
                      },
                      deleteCallback: () {
                        _receiptImportCreateCubit.deleteShipmentHandle(index);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => 16.height,
                  itemCount: shipments.length,
                );
              },
            ),
            16.height,
            UploadButton(
              preIcon: FaIcon(iconCode: '2b', color: AppColors.blue60),
              title: 'Thêm lô',
              onTap: _receiptImportCreateCubit.addShipmentHandle,
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
              title: widget.receiptDetail == null ? 'Xác nhận' : 'Cập nhật',
              event: _confirmHandle,
              largeButton: true,
              icon: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _imagePickerView {
    return BlocListener<ImagePickerCubit, ImagePickerState>(
      listener: (context, state) {
        // TODO: implement listener
        final shipments =
            state.products.map((e) => e.toShipmentItemEntity).toList();
        _receiptImportCreateCubit.addListShipmentHandle(shipments);
      },
      listenWhen: (previous, current) {
        return previous.products != current.products;
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tài liệu đi kèm',
                  style: s14w500.copyWith(
                    color: AppColors.input_label,
                  ),
                ),
              ),
              16.width,
              InkWell(
                onTap: () {
                  InvoiceAiExtractLoadingPopup.show(context);
                  _imagePickerCubit.receiptAiExtractHanel().then((_) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      InvoiceAiExtractResponsePopup.show(
                        context,
                        images: _imagePickerCubit.state.images,
                        callBack: () {
                          _tabController.animateTo(1);
                          _receiptImportCreateCubit.stateHandle(indexTab: 1);
                        },
                      );
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp8,
                    horizontal: sp12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.button_neutral_solid_backgroundDefault,
                    borderRadius: BorderRadius.circular(sp48),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        iconCode: 'f8f3',
                        color: AppColors.button_neutral_solid_textDefault,
                      ),
                      sp8.width,
                      Text(
                        'Quét ảnh',
                        style: s12w500.copyWith(
                          color: AppColors.button_neutral_solid_textDefault,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sp12.width,
              InkWell(
                onTap: () {
                  _imagePickerCubit.imagePickerHandle(
                    ImageReceiptSourceEnum.gallery,
                    isMulti: true,
                  );
                },
                child: CircleAvatar(
                  radius: sp16,
                  backgroundColor: AppColors.green50,
                  child: FaIcon(
                    iconCode: 'f093',
                    color: AppColors.white,
                  ),
                ),
              ),
              sp12.width,
              InkWell(
                onTap: () {
                  _imagePickerCubit.imagePickerHandle(
                    ImageReceiptSourceEnum.camera,
                  );
                },
                child: CircleAvatar(
                  radius: sp16,
                  backgroundColor: AppColors.blue50,
                  child: FaIcon(
                    iconCode: 'f030',
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          sp12.height,
          BlocSelector<ImagePickerCubit, ImagePickerState,
              List<ImageReceiptEntity>>(
            selector: (state) {
              return state.images;
            },
            builder: (context, images) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = images[index];
                  return BaseContainer(
                    padding: const EdgeInsets.all(sp12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(sp12),
                          child: Image.file(
                            File(item.path!),
                            width: sp48,
                            height: sp48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        sp16.width,
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Ảnh tài liệu ${index + 1}',
                                    style: s12w500.copyWith(
                                      color: AppColors.text_secondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () =>
                                        _imagePickerCubit.deleteImage(index),
                                    child: CircleAvatar(
                                      radius: sp12,
                                      backgroundColor: AppColors
                                          .button_neutral_alpha_backgroundDefault,
                                      child: FaIcon(
                                        iconCode: 'f068',
                                        color: AppColors
                                            .button_neutral_alpha_iconDefault,
                                        size: sp12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sp8.height,
                              Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    '${index + 1}/${images.length}',
                                    style: s12w500.copyWith(
                                      color: AppColors.text_quaternary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => sp12.height,
                itemCount: images.length,
              );
            },
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

    DialogUtils.showLoadingDialog(
      context,
      widget.receiptDetail == null
          ? 'Đang tạo phiếu nhập'
          : 'Đang cập nhập phiếu',
    );
    final res = widget.receiptDetail == null
        ? await _receiptImportCreateCubit.createReceiptHandle(
            file: _imagePickerCubit.state.images,
          )
        : await _receiptImportCreateCubit.updateReceiptHandle(
            file: _imagePickerCubit.state.images,
          );
    if (!mounted) return;
    Navigator.of(context).pop();
    if (res != null) {
      DialogUtils.showSuccessDialog(
        context,
        content: widget.receiptDetail == null
            ? 'Tạo phiếu nhập thành công, mã phiếu: $res'
            : 'Cập nhập thành công, mã phiếu: $res',
        accept: () {
          context.router.replace(
            ReceiptImportDetailRoute(
              id: res,
              warehouseId: _receiptImportCreateCubit.state.warehouse!.id!,
            ),
          );
        },
        close: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.receiptDetail == null
                ? 'Có lỗi trong quá trình tạo phiếu'
                : 'Có lỗi trong quá trình cập nhật phiếu',
          ),
        ),
      );
    }
  }

  void _initShipments() {
    if (widget.listReceiptItem == null) {
      return;
    }
    final shipments = widget.listReceiptItem!
        .map(
          (e) => e.shipmentItemEntity,
        )
        .toList();
    _receiptImportCreateCubit.initShipments(shipments);
  }

  void _initReceipt() {
    if (widget.receiptDetail == null) {
      return;
    }
    _receiptImportCreateCubit.initReceipt(widget.receiptDetail!);
  }
}
