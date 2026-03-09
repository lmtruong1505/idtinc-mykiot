import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/input/input_column.dart';
import '../../../../shared/components/input/overlay_input.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/base_container.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/select.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../../features_v2/blocs/order_v2/product_selection_bloc.dart';
import '../../../features_v2/models/product/product_v2_model.dart';
import '../../../features_v2/models/product/unit_v2_model.dart';
import '../../../features_v2/screens/product/components/product_list_item.dart';
import '../domain/entities/shipment_data_entity.dart';
import 'create_receipt_shipment_widget.dart';

class ReceiptImportCreateItem extends StatefulWidget {
  const ReceiptImportCreateItem({
    super.key,
    required this.index,
    required this.shipment,
    this.deleteCallback,
    this.callBack,
  });

  final int index;
  final ShipmentItemEntity shipment;
  final Function? deleteCallback;
  final Function(ShipmentItemEntity)? callBack;

  @override
  State<ReceiptImportCreateItem> createState() =>
      _ReceiptImportCreateItemState();
}

class _ReceiptImportCreateItemState extends State<ReceiptImportCreateItem> {
  int get _index => widget.index;
  late ShipmentItemEntity _shipment;
  late ExpandableController _expandableController;
  late ProductSelectionBloc _productSelectionBloc;
  late TextEditingController _nameProductCtrl;

  @override
  void initState() {
    super.initState();

    _shipment = widget.shipment;
    _expandableController = ExpandableController(initialExpanded: true);
    _productSelectionBloc = getIt.get<ProductSelectionBloc>();
    _nameProductCtrl =
        TextEditingController(text: _shipment.productData?.name ?? '')
          ..addListener(
            () {
              _infoShipmentHandle(
                productData: _shipment.productData?.copyWith(
                      id: null,
                      name: _nameProductCtrl.text,
                    ) ??
                    ProductV2Model(
                      id: null,
                      name: _nameProductCtrl.text,
                    ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: _expandableController,
      child: BaseContainer(
        color: AppColors.ultility_brand_10,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            hasIcon: false,
          ),
          controller: _expandableController,
          header: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: sp8,
              horizontal: sp16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Lô hàng ${_index + 1}',
                    style: s20w700,
                  ),
                ),
                16.width,
                Expanded(
                  child: AppInputV2(
                    initialValue: _shipment.code,
                    hintText: 'Nhập mã lô',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: sp2,
                      horizontal: sp12,
                    ),
                    backgroundColor: AppColors.input_backgroundDefault,
                    borderColor: AppColors.input_borderDefault,
                    onChanged: (val) {
                      _infoShipmentHandle(
                        code: val,
                      );
                    },
                  ),
                ),
                16.width,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandableController.toggle();
                    });
                  },
                  child: FaIcon(
                    iconCode: _expandableController.expanded ? 'f106' : 'f107',
                    color: AppColors.text_tertiary,
                  ),
                ),
                16.width,
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
          ),
          collapsed: const SizedBox(),
          expanded: _bodyView,
        ),
      ),
    );
  }

  Widget get _bodyView {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: sp8,
        horizontal: sp8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.input_backgroundDefault,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
            sp12,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildInfo,
          // _buildShipmentSelectView,
        ],
      ),
    );
  }

  Widget get _buildInfo {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InputColumn(
                controller: TextEditingController(
                  text: _shipment.startDate.fomatDefaulft,
                ),
                readOnly: true,
                label: 'Ngày sản xuất',
                hintText: 'Chọn ngày',
                padding: 0.pading,
                maxLength: 30,
                onTap: () {
                  final date = _shipment.startDate;
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    locale: const Locale('vi'),
                  ).then((value) {
                    if (value != null) {
                      _infoShipmentHandle(
                        startDate: value,
                      );
                    }
                  });
                },
                suffixIcon: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: FaIcon(iconCode: 'f133')),
                ),
              ),
            ),
            sp8.width,
            Expanded(
              child: InputColumn(
                controller: TextEditingController(
                  text: _shipment.endDate.fomatDefaulft,
                ),
                readOnly: true,
                label: 'Hạn sử dụng',
                hintText: 'Chọn ngày',
                isRequired: true,
                padding: 0.pading,
                maxLength: 30,
                onTap: () {
                  final date = _shipment.startDate;
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    locale: const Locale('vi'),
                  ).then((value) {
                    if (value != null) {
                      _infoShipmentHandle(
                        endDate: value,
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
                    return 'Nhập HSD';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        12.height,
        InputColumn(
          controller: TextEditingController(
            text: _shipment.receiptName,
          ),
          label: 'Tên hóa đơn',
          hintText: 'Nhập tên hóa đơn',
          padding: 0.pading,
          maxLength: 1,
          onChanged: (val) => _infoShipmentHandle(
            receiptName: val,
          ),
        ),
        12.height,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Tên sản phẩm',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.input_label,
                ),
                children: [
                  TextSpan(
                    text: ' *',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
                ],
              ),
            ),
            sp8.height,
            _buildSearch(),
            sp4.height,
            Text(
              'Hệ thống sẽ tự động tạo mới sản phẩm nếu bạn không chọn sản phẩm có sẵn.',
              style: s10w400.copyWith(
                color: AppColors.text_quaternary,
              ),
            ),
          ],
        ),
        12.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: InputColumn(
                controller: _shipment.productData?.id != null
                    ? TextEditingController(
                        text: _shipment
                            .productData?.unitSell?.sellPrice.formatCurrency,
                      )
                    : null,
                initialValue: _shipment.productData?.id != null
                    ? null
                    : _shipment.productData?.unitSell?.sellPrice.formatCurrency,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                onTap: _shipment.productData?.id != null ? () {} : null,
                textInputType: TextInputType.number,
                fillColor: _shipment.productData?.id != null
                    ? AppColors.grey10
                    : AppColors.white,
                prefixIcon: moneyPrefix(),
                label: 'Đơn giá bán',
                padding: 0.pading,
                maxLength: 30,
                onChanged: (val) {
                  final unitSell =
                      _shipment.productData?.unitSell ?? UnitV2Model();
                  final unit = unitSell.copyWith(
                    sellPrice: double.tryParse(val.removeAllDot()) ?? 0,
                  );
                  _infoShipmentHandle(
                    productData: _shipment.productData?.copyWith(
                      unitSell: unit,
                    ),
                  );
                },
              ),
            ),
            sp8.width,
            Expanded(
              child: CommonDropdown(
                showIconRemove: false,
                value: _shipment.productData?.unitSell?.name,
                borderColor: AppColors.input_borderDefault,
                items: (_shipment.productData?.id == null
                        ? unitsMetaData
                        : (_shipment.productData?.unit ?? []))
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.name,
                        child: Text(
                          e.name ?? '',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _shipment.productData?.id == null
                    ? (value) {
                        final unitSell =
                            _shipment.productData?.unitSell ?? UnitV2Model();
                        final unit = unitSell.copyWith(
                          name: value as String,
                        );
                        _infoShipmentHandle(
                          productData: _shipment.productData?.copyWith(
                            unitSell: unit,
                          ),
                        );
                      }
                    : null,
                hintText: 'Đơn vị',
                radius: sp8,
                color: _shipment.productData?.id != null
                    ? AppColors.grey10
                    : AppColors.white,
              ),
            ),
          ],
        ),
        12.height,
        InputColumn(
          initialValue: _shipment.importPrice.formatCurrency,
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
          padding: 0.pading,
          maxLength: 30,
          onChanged: (val) {
            _infoShipmentHandle(
              importPrice: double.tryParse(val.removeAllDot()) ?? 0,
            );
          },
        ),
        12.height,
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InputColumn(
                initialValue: _shipment.inputQuantity.formatCurrency,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                textInputType: TextInputType.number,
                fillColor: AppColors.white,
                label: 'Số lượng nhập',
                padding: 0.pading,
                isRequired: true,
                maxLength: 30,
                onChanged: (val) {
                  _infoShipmentHandle(
                    inputQuantity: double.tryParse(val.removeAllDot()) ?? 0,
                  );
                },
                validate: (value) {
                  if (value == null || value == '') {
                    return 'Nhập số lượng';
                  } else if ((double.tryParse(value) ?? 0) <= 0) {
                    return 'Số lượng > 0';
                  }
                  return null;
                },
              ),
            ),
            sp8.width,
            Expanded(
              child: CommonDropdown(
                label: '',
                showIconRemove: false,
                value: _shipment.productData?.id == null
                    ? _shipment.productData?.unitSell?.name
                    : _shipment.inputUnitData,
                borderColor: AppColors.input_borderDefault,
                items: (_shipment.productData?.id == null
                        ? unitsMetaData
                        : (_shipment.productData?.unit ?? []))
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.name,
                        child: Text(
                          e.name ?? '',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (_shipment.productData?.id == null) {
                    final unitSell =
                        _shipment.productData?.unitSell ?? UnitV2Model();
                    final unit = unitSell.copyWith(
                      name: value as String,
                    );
                    _infoShipmentHandle(
                      productData: _shipment.productData?.copyWith(
                        unitSell: unit,
                      ),
                    );
                  } else {
                    final unit = (_shipment.productData?.id == null
                            ? unitsMetaData
                            : (_shipment.productData?.unit ?? []))
                        .firstWhere((e) => e.name == value);
                    _infoShipmentHandle(
                      unitImport: unit,
                    );
                  }
                },
                required: true,
                hintText: 'Đơn vị',
                radius: sp8,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        12.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InputColumn(
                initialValue: _shipment.discount.formatCurrency,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                textInputType: TextInputType.number,
                fillColor: AppColors.white,
                prefixIcon: moneyPrefix(),
                label: 'Chiết khấu',
                hintText: '',
                padding: 0.pading,
                onChanged: (val) {
                  _infoShipmentHandle(
                    discount: double.tryParse(val.removeAllDot()) ?? 0,
                  );
                },
              ),
            ),
            sp8.width,
            Expanded(
              child: InputColumn(
                initialValue: _shipment.vat.formatCurrency,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                textInputType: TextInputType.number,
                fillColor: AppColors.white,
                prefixIcon: Container(
                  height: 48,
                  width: 48,
                  child: Center(
                    child: Text(
                      '%',
                      style: s16w400.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                label: 'VAT',
                padding: 0.pading,
                maxLength: 30,
                onChanged: (val) {
                  _infoShipmentHandle(
                    vat: double.tryParse(val.removeAllDot()) ?? 0,
                  );
                },
              ),
            ),
          ],
        ),
        16.height,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Thành tiền',
                  style: s14w400.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                sp4.width,
                Tooltip(
                  message: 'Giá trị lô hàng trước thuế',
                  child: FaIcon(
                    iconCode: 'f05a',
                  ),
                ),
                const Spacer(),
                Text(
                  '${_shipment.totalMoneyBeforeVat.formatCurrency}đ',
                  style: s16w400.copyWith(
                    color: AppColors.text_primary,
                  ),
                ),
              ],
            ),
            sp8.height,
            Row(
              children: [
                Text(
                  'Giá trị lô hàng',
                  style: s14w400.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                sp4.width,
                Tooltip(
                  message: 'Giá trị lô hàng sau thuế',
                  child: FaIcon(
                    iconCode: 'f05a',
                  ),
                ),
                const Spacer(),
                Text(
                  '${_shipment.totalMoneyAfterVat.formatCurrency}đ',
                  style: s16w500.copyWith(
                    color: AppColors.brand,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  OverlayInput<ProductV2Model> _buildSearch() {
    return OverlayInput<ProductV2Model>(
      controller: _nameProductCtrl,
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) async {
        _infoShipmentHandle(
          productData: item,
        );
      },
      hintText: 'Nhập tên sản phẩm',
      itemHeight: 105,
      lazyLoad: (isMore) {
        return _productSelectionBloc.getList(
          _nameProductCtrl.text,
          isMore: isMore,
        );
      },
      borderRadius: 8,
      header: Text(
        'Chọn sản phẩm',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: _shipment.productData?.id == null
          ? null
          : Row(
              children: [
                16.width,
                InkWell(
                  onTap: () {
                    _infoShipmentHandle(
                      productData: ProductV2Model(
                        name: _nameProductCtrl.text,
                      ),
                    );
                  },
                  child: FaIcon(
                    iconCode: 'f00d',
                  ),
                ),
                8.width,
                ClipRRect(
                  borderRadius: BorderRadius.circular(sp12),
                  child: BaseCacheImage(
                    loadPharmagoLogo: true,
                    url: _shipment.productData?.images?.firstOrNull?.url ?? '',
                    width: sp32,
                    height: sp32,
                    fit: BoxFit.cover,
                  ),
                ),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _shipment.productData?.name ?? '',
                      style: s12w500.copyWith(
                        color: AppColors.text_primary,
                      ),
                    ),
                    Text(
                      _shipment.productData?.code ?? '',
                      style: s10w500.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      suffix: SizedBox(
        width: sp48,
        child: Center(
          child: FaIcon(
            iconCode: 'f107',
            color: AppColors.text_tertiary,
          ),
        ),
      ),
    );
  }

  void _infoShipmentHandle({
    String? code,
    String? receiptName,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? updatedAt,
    ProductV2Model? productData,
    num? importPrice,
    num? inputQuantity,
    UnitV2Model? unitImport,
    num? discount,
    num? vat,
  }) {
    setState(() {
      final product = productData ?? _shipment.productData;
      if (product?.id != _shipment.productData?.id) {
        final unit =
            (product?.id == null ? unitsMetaData : (product?.unit ?? [])).first;
        _shipment = _shipment.copyWith(
          inputUnit: unit.id,
          inputUnitData: unit.name,
        );
      }
      _shipment = _shipment.copyWith(
        code: code ?? _shipment.code,
        startDate: startDate ?? _shipment.startDate,
        endDate: endDate ?? _shipment.endDate,
        updatedAt: updatedAt ?? _shipment.updatedAt,
        productData: product,
        importPrice: importPrice ?? _shipment.importPrice,
        inputQuantity: inputQuantity ?? _shipment.inputQuantity,
        inputUnit: unitImport?.id ?? _shipment.inputUnit,
        inputUnitData: unitImport?.name ?? _shipment.inputUnitData,
        discount: discount ?? _shipment.discount,
        vat: vat ?? _shipment.vat,
        receiptName: receiptName ?? _shipment.receiptName,
      );
    });
    widget.callBack?.call(_shipment);
  }
}

List<UnitV2Model> get unitsMetaData => [
      UnitV2Model(name: 'Viên'),
      UnitV2Model(name: 'Ống'),
      UnitV2Model(name: 'Chai'),
      UnitV2Model(name: 'Lọ'),
      UnitV2Model(name: 'Vỉ'),
      UnitV2Model(name: 'Tuýp'),
      UnitV2Model(name: 'Hộp'),
      UnitV2Model(name: 'Gói'),
      UnitV2Model(name: 'Túi'),
      UnitV2Model(name: 'Bịch'),
      UnitV2Model(name: 'Thùng'),
      UnitV2Model(name: 'Miếng'),
      UnitV2Model(name: 'Cái'),
      UnitV2Model(name: 'Chiếc'),
      UnitV2Model(name: 'Que'),
      UnitV2Model(name: 'Lít'),
      UnitV2Model(name: 'ml'),
      UnitV2Model(name: 'mg'),
      UnitV2Model(name: 'g'),
      UnitV2Model(name: 'kg'),
      UnitV2Model(name: 'mcg'),
      UnitV2Model(name: 'IU'),
      UnitV2Model(name: 'Thanh'),
      UnitV2Model(name: 'Bình'),
      UnitV2Model(name: 'Dây'),
      UnitV2Model(name: 'Cuộn'),
      UnitV2Model(name: 'Bộ'),
      UnitV2Model(name: 'Kit'),
      UnitV2Model(name: 'Test'),
    ];
