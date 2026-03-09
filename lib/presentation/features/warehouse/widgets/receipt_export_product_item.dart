import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/input/input_column.dart';
import '../../../../shared/components/input/overlay_input.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/base_container.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/select.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../../../features_v2/blocs/order_v2/product_selection_bloc.dart';
import '../../../features_v2/models/product/product_v2_model.dart';
import '../../../features_v2/models/product/unit_v2_model.dart';
import '../../../features_v2/screens/order/scan_page.dart';
import '../../../features_v2/screens/product/components/product_list_item.dart';
import '../../order/widgets/scan_view.dart';
import '../domain/entities/shipment_data_entity.dart';
import 'create_receipt_shipment_widget.dart';

class ReceiptExportProductItem extends StatefulWidget {
  const ReceiptExportProductItem({
    super.key,
    required this.product,
    required this.index,
    this.callBack,
    this.deleteCallback,
  });

  final ProductV2Model product;
  final int index;
  final Function(ProductV2Model)? callBack;
  final Function()? deleteCallback;

  @override
  State<ReceiptExportProductItem> createState() =>
      _ReceiptExportProductItemState();
}

class _ReceiptExportProductItemState extends State<ReceiptExportProductItem> {
  int get _index => widget.index;

  // late ProductV2Model _product;
  ProductV2Model get _product => widget.product;
  late ExpandableController _expandableController;
  late ProductSelectionBloc _productSelectionBloc;

  @override
  void initState() {
    super.initState();

    _expandableController = ExpandableController(initialExpanded: true);
    _productSelectionBloc = getIt.get<ProductSelectionBloc>();
    // _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: _expandableController,
      child: BaseContainer(
        padding: 16.pading,
        child: ExpandablePanel(
          controller: _expandableController,
          header: Row(
            children: [
              Text(
                'Lô hàng ${_index + 1}',
                style: s20w700,
              ),
              const Spacer(),
              8.width,
              GestureDetector(
                onTap: () {
                  DialogUtils.showWarningDialog(
                    context,
                    content: 'Bạn có muốn xoá lô không?',
                    accept: () {
                      context.router.pop();
                      widget.deleteCallback?.call();
                    },
                    close: () => context.router.pop(),
                  );
                },
                child: FaIcon(
                  iconCode: 'f1f8',
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
          collapsed: const SizedBox(),
          expanded: _product.id == null ? _buildSearch() : _bodyView,
        ),
      ),
    );
  }

  Widget get _bodyView {
    return Column(
      children: [
        _buildInfo,
        _buildShipmentSelectView,
        if (_product.shipment?.data?.firstWhereOrNull((e) => e.isSelected) !=
            null)
          _formShipmentView,
      ],
    );
  }

  Row get _buildInfo {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseCacheImage(
          loadPharmagoLogo: true,
          url: _product.images?.firstOrNull?.url ?? '',
          width: 43,
          height: 43,
          borderRadius: 4.radius,
          fit: BoxFit.cover,
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _product.name ?? '',
              style: AppStyle.bodySmMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _product.barcode ?? '',
              style: s12w400.copyWith(color: AppColors.text_tertiary),
            ),
          ],
        ).expanded(),
      ],
    );
  }

  OverlayInput<ProductV2Model> _buildSearch() {
    return OverlayInput<ProductV2Model>(
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) async {
        await _productSelectionBloc.addProduct(item);
        widget.callBack?.call(
            _productSelectionBloc.list.firstWhere((e) => e.id == item.id));
      },
      hintText: 'Tìm tên, mã sản phẩm',
      itemHeight: 105,
      lazyLoad: (isMore) {
        return _productSelectionBloc.getList('', isMore: isMore);
      },
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
                _callScan(type, value);
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
                child: FaIcon(iconCode: 'f465', type: FaIconType.solid),
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
    );
  }

  CommonDropdown<ShipmentItemEntity> get _buildShipmentSelectView {
    return CommonDropdown<ShipmentItemEntity>(
      showIconRemove: false,
      value: _product.shipment?.data?.firstWhereOrNull((e) => e.isSelected),
      borderColor: AppColors.input_borderDefault,
      items: List.generate(
        _product.shipment?.data?.length ?? 0,
        (index) => DropdownMenuItem(
          value: _product.shipment?.data?[index],
          child: Row(
            children: [
              BaseCacheImage(
                loadPharmagoLogo: true,
                url: _product.images?.firstOrNull?.url ?? '',
                width: 28,
                height: 28,
                borderRadius: 4.radius,
                fit: BoxFit.cover,
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lô ${_product.shipment?.data?[index].id} - HSD: ${_product.shipment?.data?[index].endDate.fomatCustom()}',
                    style: AppStyle.bodySmMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Tồn: ${(_product.shipment?.data?[index].currentQuantity ?? 0) ~/ _product.valueUnitChange} ${_product.unitSell?.name}',
                    style: s12w400.copyWith(color: AppColors.text_tertiary),
                  ),
                ],
              ).expanded(),
            ],
          ),
        ),
      ),
      onChanged: _shipmentSelectedHandle,
      required: true,
      label: 'Mã lô',
      hintText: 'Chọn mã lô',
      color: AppColors.white,
    );
  }

  Widget get _formShipmentView {
    final item = _product.shipment?.data?.firstWhere((e) => e.isSelected);
    final textEctl = TextEditingController(
      text: item?.selectedQuantity.formatCurrency,
    );
    final priceExportEctl = TextEditingController(
      text: _product.unitSell?.sellPrice.formatCurrency,
    );
    return BaseContainer(
      margin: const EdgeInsets.only(top: sp12),
      color: AppColors.bg_primary_hover,
      borderColor: AppColors.bg_primary_hover,
      padding: 8.pading,
      child: Column(
        children: [
          Row(
            children: [
              InputColumn(
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                controller: textEctl,
                textInputType: TextInputType.number,
                fillColor: AppColors.white,
                label: 'Số lượng xuất',
                isRequired: true,
                padding: 0.pading,
                maxLength: 30,
                onConfirm: (p0) => _formEditHandle(
                  quantity: int.tryParse(p0.removeAllDot()),
                ),
                onTapOutside: () {
                  _formEditHandle(
                    quantity: int.tryParse(textEctl.text.removeAllDot()),
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
              CommonDropdown<UnitV2Model>(
                showIconRemove: false,
                value: _product.unit.first,
                radius: 8,
                borderColor: AppColors.border_primary,
                items: List.generate(
                  _product.unit.length,
                  (index) => DropdownMenuItem(
                    value: _product.unit[index],
                    child: Text(
                      _product.unit[index].name ?? '',
                    ),
                  ),
                ),
                onChanged: _unitSelectHandle,
                required: true,
                label: 'Đơn vị',
                hintText: 'Chọn đơn vị',
                color: AppColors.white,
              ).flexible(),
            ],
          ),
          8.height,
          InputColumn(
            controller: priceExportEctl,
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'vi',
                symbol: '',
              ),
            ],
            textInputType: TextInputType.number,
            fillColor: AppColors.white,
            prefixIcon: moneyPrefix(),
            label: 'Đơn giá xuất',
            isRequired: true,
            padding: 0.pading,
            maxLength: 30,
            onConfirm: (p0) => _formEditHandle(
              price: double.tryParse(p0.removeAllDot()),
            ),
            onTapOutside: () {
              _formEditHandle(
                price: double.tryParse(priceExportEctl.text.removeAllDot()),
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
            suffixIcon: Container(
              width: 150,
              margin: const EdgeInsets.all(sp4),
              padding:
                  const EdgeInsets.symmetric(vertical: sp4, horizontal: sp8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp4),
                color: AppColors.bg_disable,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'x${item?.selectedQuantity}',
                      style: s12w400.copyWith(color: AppColors.text_tertiary),
                    ),
                    Text(
                      ' = ${((item?.selectedQuantity ?? 0) * (_product.unitSell?.sellPrice ?? 0)).formatCurrency}đ',
                      style: s12w400.copyWith(color: mainColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          8.height,
        ],
      ),
    );
  }

  void _callScan(TypeScanView type, String value) async {
    if (type == TypeScanView.barcodeShipment) {
      // widget.bloc.scanShipmentDetail(value);
    }
  }

  void _shipmentSelectedHandle(ShipmentItemEntity? value) {
    final shipments = List<ShipmentItemEntity>.from(
      _product.shipment?.data ?? [],
    );
    for (var i = 0; i < shipments.length; i++) {
      final item = shipments[i];
      shipments[i] = shipments[i].copyWith(
        isSelected: item.id == value?.id,
        selectedQuantity: shipments[i].selectedQuantity == 0
            ? 1
            : shipments[i].selectedQuantity,
      );
    }
    _product.shipment = _product.shipment?.copyWith(data: shipments);
    widget.callBack?.call(_product.copyWith());
    setState(() {});
  }

  void _unitSelectHandle(UnitV2Model? value) {
    _product.unitSell = value;
    widget.callBack?.call(_product.copyWith());
    setState(() {});
  }

  void _formEditHandle({int? quantity, double? price}) {
    log('--- _formEditHandle: $quantity , $price');
    final shipments = List<ShipmentItemEntity>.from(
      _product.shipment?.data ?? [],
    );
    final indexShipment = shipments.indexWhere((e) => e.isSelected);
    shipments[indexShipment] = shipments[indexShipment].copyWith(
      selectedQuantity: quantity ?? shipments[indexShipment].selectedQuantity,
    );
    _product.shipment = _product.shipment?.copyWith(data: shipments);
    _product.unitSell = _product.unitSell?.copyWith(
      sellPrice: price ?? _product.unitSell?.sellPrice,
    );
    widget.callBack?.call(_product.copyWith());
    setState(() {});
  }
}
