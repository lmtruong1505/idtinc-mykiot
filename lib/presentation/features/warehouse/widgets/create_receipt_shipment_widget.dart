import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/dotted_border_button.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/create_warehouse_receipt_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/order/scan_page.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/input/overlay_input.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../order/widgets/scan_view.dart';

class CreateReceiptShipmentWidget extends StatefulWidget {
  const CreateReceiptShipmentWidget({
    super.key,
    required this.bloc,
    required this.shipmentKey,
  });
  final CreateWarehouseReceiptCubit bloc;
  final GlobalKey<FormState> shipmentKey;

  @override
  State<CreateReceiptShipmentWidget> createState() =>
      _CreateReceiptShipmentWidgetState();
}

class _CreateReceiptShipmentWidgetState
    extends State<CreateReceiptShipmentWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = widget.bloc;
    return BlocConsumer<CreateWarehouseReceiptCubit, CubitState>(
      listener: (context, state) {
        if (state.status == BlocStatus.submitSuccess) {
          // lotPriceCtrl.clear();
        } else if (state.status == BlocStatus.reload) {
          bloc.totalPrice = bloc.listShipment.fold<num>(
            0,
            (pre, element) => pre + (element.productData?.shipmentPrice ?? 0),
          );
        }
        // lotPriceCtrl.text = bloc.totalPrice.formatCurrency;
      },
      builder: (context, state) {
        return Form(
          key: widget.shipmentKey,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputColumn(
                  key: UniqueKey(),
                  initialValue: bloc.totalPrice.formatCurrency,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      symbol: '',
                    ),
                  ],
                  fillColor: AppColors.white,
                  prefixIcon: moneyPrefix(),
                  label: 'Giá trị phiếu nhập',
                  isRequired: true,
                  padding: 0.pading,
                  maxLength: 30,
                  onChanged: (val) {
                    bloc.totalPrice = num.tryParse(val.removeAllDot())!;
                  },
                ),
                16.height,
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final shipment = bloc.listShipment[index];
                    return ShipmentInfor(
                      shipment: shipment,
                      index: index,
                      bloc: bloc,
                    );
                  },
                  separatorBuilder: (context, index) => 16.height,
                  itemCount: bloc.listShipment.length,
                ),
                16.height,
                UploadButton(
                  preIcon: FaIcon(iconCode: '2b', color: AppColors.blue60),
                  title: 'Thêm lô',
                  onTap: () {
                    DialogUtils.showWarningDialog(
                      context,
                      content: 'Bạn có muốm thêm mới lô không?',
                      accept: () {
                        context.pop();
                        bloc.addLot();
                      },
                      close: () => context.pop(),
                    );
                  },
                ),
              ],
            ).padding(16.pading),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ShipmentInfor extends StatefulWidget {
  const ShipmentInfor({
    super.key,
    required this.shipment,
    required this.index,
    required this.bloc,
  });
  final ReceiptImportDetailModel shipment;
  final int index;
  final CreateWarehouseReceiptCubit bloc;

  @override
  State<ShipmentInfor> createState() => _ShipmentInforState();
}

class _ShipmentInforState extends State<ShipmentInfor> {
  final textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final shipment = widget.shipment;
    return BaseContainer(
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Lô hàng ${widget.index + 1}',
                style: s20w700,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  bloc.updateShipment(
                    widget.index,
                    isShow: !(shipment.isExpand),
                  );
                },
                child: Icon(
                  shipment.isExpand == true
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_up,
                ),
              ),
              8.width,
              GestureDetector(
                onTap: () {
                  DialogUtils.showWarningDialog(
                    context,
                    content: 'Bạn có muốn xoá lô không?',
                    accept: () {
                      context.router.pop();
                      bloc.deleteShipment(widget.index);
                    },
                    close: () => context.router.pop(),
                  );
                },
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
          Visibility(
            visible: shipment.isExpand,
            child: Column(
              children: [
                Visibility(
                  visible: false,
                  child: InputColumn(
                    initialValue: shipment.code,
                    label: 'Mã lô',
                    padding: 0.pading,
                    maxLength: 30,
                    onChanged: (value) {
                      bloc.updateShipment(widget.index, shipmentCode: value);
                    },
                  ),
                ),
                16.height,
                Row(
                  children: [
                    InputColumn(
                      key: UniqueKey(),
                      initialValue: shipment.startDate.fomatDefaulft,
                      readOnly: true,
                      label: 'Ngày sản xuất',
                      isRequired: true,
                      padding: 0.pading,
                      maxLength: 30,
                      onTap: () {
                        final date = shipment.startDate;
                        showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          locale: const Locale('vi'),
                        ).then((value) {
                          if (value != null) {
                            bloc.updateShipment(
                              widget.index,
                              startDate: value,
                              endDate: shipment.endDate ??
                                  value.add(const Duration(days: 365 * 3)),
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
                          return 'Nhập ngày sản xuất';
                        }
                        return null;
                      },
                    ).expanded(),
                    16.width,
                    InputColumn(
                      key: UniqueKey(),
                      initialValue: shipment.endDate.fomatDefaulft,
                      readOnly: true,
                      label: 'Hạn sử dụng',
                      isRequired: true,
                      padding: 0.pading,
                      maxLength: 30,
                      onTap: () {
                        // final date = inputDateCtrl.text.toDateV2;
                        showDatePicker(
                          context: context,
                          initialDate: shipment.endDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          locale: const Locale('vi'),
                        ).then((value) {
                          if (value != null) {
                            bloc.updateShipment(widget.index, endDate: value);
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
                          return 'Nhập hạn sử dụng';
                        }
                        return null;
                      },
                    ).expanded(),
                  ],
                ),
                16.height,
                if (shipment.productData == null)
                  Row(
                    children: [
                      OverlayInput<ProductV3Model>(
                        itemBuilder: (context, item, index) {
                          return Row(
                            children: [
                              Row(
                                children: [
                                  BaseCacheImage(
                                    url: item.images?.firstOrNull?.url ?? '',
                                    width: 56,
                                    height: 56,
                                    borderRadius: 4.radius,
                                    fit: BoxFit.cover,
                                  ).padding(8.padingHor),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.name ?? '',
                                    maxLines: 2,
                                    style: s14w500,
                                  ),
                                  Text(
                                    item.code ?? '',
                                    style: s14w400.copyWith(
                                      color: AppColors.text_tertiary,
                                    ),
                                  ),
                                ],
                              ).expanded(),
                            ],
                          );
                        },
                        onChanged: (item) {
                          bloc.addProd(widget.index, item);
                        },
                        hintText: 'Tìm tên, mã sản phẩm',
                        itemHeight: 65,
                        lazyLoad: (isMore) => bloc.getListWarehouseProduct(
                          textCtrl.text,
                          isMore: isMore,
                        ),
                        controller: textCtrl,
                        borderRadius: 999,
                        header: Text(
                          'Chọn sản phẩm',
                          style: AppStyle.headingMd.copyWith(
                            color: AppColors.text_quaternary,
                          ),
                        ).padding(16.pading.copyWith(top: 12, bottom: 6)),
                        elevation: 1,
                        prefix: InkWell(
                          onTap: () {
                            context.push(
                              ScanPage(
                                onScan: (type, value) async {
                                  if (type == TypeScanView.barcode) {
                                    final res = await widget.bloc
                                        .getListWarehouseProduct(value);
                                    if (res.isNotEmpty) {
                                      bloc.addProd(
                                        widget.index,
                                        res.firstOrNull,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Sản phẩm không tồn tại',
                                          ),
                                          backgroundColor:
                                              AppColors.ultility_positive_60,
                                          duration: 2.seconds,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
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
                                  child: FaIcon(
                                    iconCode: 'f465',
                                    type: FaIconType.solid,
                                  ),
                                ),
                              ),
                              const VerticalDivider(
                                color: AppColors.input_borderDefault,
                                thickness: 1,
                                width: 0,
                              ).size(height: 48),
                              8.width,
                              const Icon(
                                Icons.search,
                                color: AppColors.input_iconDefault,
                              ),
                              4.width,
                            ],
                          ),
                        ),
                      ).expanded(),
                      16.width,
                      const BaseContainer(
                        borderRadius: 999,
                        borderColor: ColorApp.greyF5,
                        color: ColorApp.greyF5,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                else
                  _productInfor(
                    widget.index,
                    shipment.productData,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productInfor(int shipmentIndex, ProductV3Model? item) {
    final bloc = widget.bloc;
    return BaseContainer(
      padding: 8.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BaseCacheImage(
                borderRadius: 4.radius,
                url: item?.images?.firstOrNull?.url ?? '',
                width: 43,
                height: 43,
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: s14w500,
                  ),
                  Text(
                    item?.code ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: s12w400.copyWith(color: ColorApp.grey79),
                  ),
                ],
              ).expanded(),
              GestureDetector(
                onTap: () {
                  DialogUtils.showWarningDialog(
                    titleClose: 'Huỷ bỏ',
                    context,
                    content: 'Bạn có muốn xoá sản phẩm này?',
                    accept: () {
                      context.pop();
                      bloc.updateShipment(widget.index, isDelete: true);
                    },
                    close: () => context.pop(),
                  );
                },
                child: const Icon(
                  Icons.cancel,
                  color: AppColors.bg_disable,
                ),
              ),
            ],
          ),
          16.height,
          BaseContainer(
            color: AppColors.bg_primary_hover,
            borderColor: AppColors.bg_primary_hover,
            padding: 8.pading,
            child: Column(
              children: [
                Row(
                  children: [
                    InputColumn(
                      initialValue: item?.inputQuantity.formatCurrency,
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: 'vi',
                          symbol: '',
                        ),
                      ],
                      textInputType: TextInputType.number,
                      fillColor: AppColors.white,
                      label: 'Số lượng nhập',
                      isRequired: true,
                      padding: 0.pading,
                      maxLength: 30,
                      onChanged: (val) {
                        final value = int.tryParse(val.removeAllDot()) ?? 0;
                        bloc.updateShipment(
                          shipmentIndex,
                          inputQuantity: value,
                        );
                      },
                      validate: (value) {
                        if (value == null || value == '') {
                          return 'Nhập số lượng';
                        } else if ((double.tryParse(value) ?? 0) <= 0) {
                          return 'Số lượng >0';
                        }
                        return null;
                      },
                    ).expanded(flex: 2),
                    8.width,
                    CommonDropdown(
                      showIconRemove: false,
                      value: item?.units?.firstOrNull,
                      radius: 8,
                      borderColor: AppColors.border_primary,
                      items: List.generate(
                        item?.units?.length ?? 0,
                        (index) => DropdownMenuItem(
                          value: item?.units?[index],
                          child: Text(
                            item?.units?[index].name ?? '',
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        bloc.updateShipment(shipmentIndex, unit: value);
                      },
                      required: true,
                      label: 'Đơn vị',
                      hintText: 'Chọn đơn vị',
                      color: AppColors.white,
                    ).flexible(),
                  ],
                ),
                16.height,
                InputColumn(
                  initialValue: item?.inputPrice.formatCurrency,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      symbol: '',
                    ),
                  ],
                  textInputType: TextInputType.number,
                  fillColor: AppColors.white,
                  prefixIcon: moneyPrefix(),
                  label: 'Đơn giá nhập',
                  isRequired: true,
                  padding: 0.pading,
                  maxLength: 30,
                  onChanged: (val) {
                    final value = int.tryParse(val.removeAllDot()) ?? 0;
                    bloc.updateShipment(
                      shipmentIndex,
                      inputPrice: value,
                    );
                  },
                  validate: (value) {
                    if (value == null || value == '') {
                      return 'Nhập đơn giá';
                    } else if ((double.tryParse(value) ?? 0) <= 0) {
                      return 'Đơn giá > 0';
                    }
                    return null;
                  },
                ),
                16.height,
                InputColumn(
                  key: UniqueKey(),
                  initialValue: item?.shipmentPrice.formatCurrency,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      symbol: '',
                    ),
                  ],
                  textInputType: TextInputType.number,
                  fillColor: AppColors.white,
                  prefixIcon: moneyPrefix(),
                  label: 'Giá trị lô hàng',
                  padding: 0.pading,
                  maxLength: 30,
                  onChanged: (val) {
                    final value = int.tryParse(val.removeAllDot()) ?? 0;
                    bloc.updateShipment(
                      shipmentIndex,
                      shipmentPrice: value,
                    );
                  },
                ),
                16.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container moneyPrefix() {
  return Container(
    height: 48,
    width: 48,
    child: Center(
      child: Text(
        'đ',
        style: s16w400.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  );
}
