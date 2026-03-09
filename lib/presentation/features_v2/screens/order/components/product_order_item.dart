import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/input_qty.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../base/cache_image.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../features/warehouse/domain/entities/shipment_data_entity.dart';
import '../../../blocs/order_v2/product_selection_bloc.dart';
import '../../../models/product/product_v2_model.dart';
import 'bts/bst_shipment.dart';

class ProductOrderItem extends StatefulWidget {
  const ProductOrderItem({
    super.key,
    required this.bloc,
    required this.model,
    this.onUpdate,
    this.onDelete,
    this.ghiChu = false,
    this.isCheckStock = true,
    this.isShowShipmnet = true,
    this.editShipment = false,
  });

  final ProductSelectionBloc bloc;
  final ProductV2Model model;
  final Function(ProductV2Model)? onUpdate;
  final VoidCallback? onDelete;
  final bool ghiChu;
  final bool isCheckStock;
  final bool isShowShipmnet;
  final bool editShipment;

  @override
  State<ProductOrderItem> createState() => _ProductOrderItemState();
}

class _ProductOrderItemState extends State<ProductOrderItem> {
  final amountTec = TextEditingController();
  final ghiChuTec = TextEditingController();
  final shipmentSearch = TextEditingController();

  ProductV2Model get _product => widget.model;
  ProductSelectionBloc get _bloc => widget.bloc;

  @override
  void initState() {
    super.initState();

    amountTec.text = (widget.model.quantity ?? 1).formatCurrency;
  }

  double get stock {
    return (widget.model.shipment?.data ?? []).fold(0, (total, e) {
      total += e.currentQuantity ?? 0;
      return total;
    },);
    return (widget.model.unitSell?.stockChange ??
        widget.model.unit
            .firstWhere(
              (element) => element.level == widget.model.unitSell?.level,
              orElse: () => widget.model.unit.last,
            )
            .stockChange ??
        0);
  }

  @override
  Widget build(BuildContext context) {
    ghiChuTec.text = widget.model.ghiChu ?? '';
    final isCheckStock = widget.isCheckStock;

    return BlocConsumer<ProductSelectionBloc, CubitState>(
      bloc: _bloc,
      listener: (BuildContext context, CubitState<dynamic> state) {
        final product = _bloc.list.firstWhere((e) => e.id == widget.model.id);
        amountTec.text = product.quantity.formatCurrency;
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: 8.radius,
            border: Border.all(
              width: 1,
              color: (stock > 0 || !isCheckStock)
                  ? AppColors.border_tertiary
                  : AppColors.input_borderDisable,
            ),
            color: (stock > 0 || !isCheckStock)
                ? AppColors.bg_primary
                : AppColors.input_backgroundDisable,
          ),
          padding: 12.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfo(),
              4.height,
              _buildQuantity(),
              if (!widget.ghiChu && widget.isShowShipmnet) _buildShipmentView,
              if (widget.ghiChu) sp12.height,
              if (widget.ghiChu)
                Row(
                  children: [
                    InputColumn(
                      padding: const EdgeInsets.all(sp0),
                      hintText:
                          isCheckStock ? 'Nhập ghi chú' : 'Nhập liều dùng',
                      controller: ghiChuTec,
                      radius: 8,
                      minLines: 2,
                      onChanged: (value) {
                        widget.model.ghiChu = value;
                        widget.onUpdate?.call(widget.model);
                      },
                      label: isCheckStock ? 'Ghi chú' : 'Liều dùng',
                    ).expanded(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Row _buildInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseCacheImage(
          loadPharmagoLogo: true,
          url: widget.model.images?.firstOrNull?.url ?? '',
          width: 56,
          height: 56,
          borderRadius: 4.radius,
          fit: BoxFit.cover,
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.model.name ?? '',
              style: AppStyle.bodySmMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${(widget.model.unitSell?.realPrice ?? 0).formatCurrency} đ',
                        style: AppStyle.headingMd.copyWith(
                          color: AppColors.text_brand_primary_variant1,
                        ),
                      ),
                      if (widget.model.chietKhau.formatCurrency != '0')
                        TextSpan(
                          text: ' - ${widget.model.chietKhau.formatCurrency}đ',
                          style: AppStyle.bodySmRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                    ],
                  ),
                ).expanded(),
                if (stock != 0 && widget.isCheckStock)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tồn: ',
                          style: AppStyle.bodySmRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                        TextSpan(
                          text: (_product.totalShipmentQuantity).formatPrice(),
                          style: AppStyle.bodyBsMedium.copyWith(
                            color: stock < (widget.model.quantity.validator)
                                ? AppColors.ultility_negative_60
                                : AppColors.text_tertiary,
                          ),
                        ),
                        TextSpan(
                          text: ' ${_product.unitSell?.name}',
                          style: AppStyle.bodyBsMedium.copyWith(
                            color: stock < (widget.model.quantity.validator)
                                ? AppColors.ultility_negative_60
                                : AppColors.text_tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (stock == 0 && widget.isCheckStock)
                  Text(
                    'Hết hàng',
                    style: AppStyle.bodySmRegular.copyWith(
                      color: AppColors.text_negative,
                    ),
                  ),
              ],
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Row _buildQuantity() {
    final enabled = (stock.validator < widget.model.quantity.validator) &&
        widget.isCheckStock;
    return Row(
      children: [
        68.width,
        _buildSelectUnit().expanded(),
        stock != 0 ? 32.width : 100.width,
        if (stock != 0 || !widget.isCheckStock)
          InputQuantity(
            controller: amountTec,
            max: stock.toInt(),
            enabled: enabled,
            action: (value) => update(value),
            onChanged: (value) {},
            // onConfirm: (val) {
            //   final num = int.tryParse(val.removeAllDot()) ?? 1;
            //   if (num > stock.toInt()) {
            //     amountTec.text = stock.toInt().toString();
            //   }
            //   final value = num > stock.toInt() ? stock.toInt() : num;
            //   log('--- confirm: $value');
            //   widget.model.quantity = value;
            //   widget.onUpdate?.call(widget.model);
            // },
            onTapOutside: () {
              final num = int.tryParse(amountTec.text.removeAllDot()) ?? 1;
              if (num > stock.toInt()) {
                amountTec.text = stock.toInt().toString();
              }
              final value = num > stock.toInt() ? stock.toInt() : num;
              log('--- onTapOutside: $value');
              widget.model.quantity = value;
              widget.onUpdate?.call(widget.model);
            },
          ).expanded(),
        if (stock == 0 && widget.isCheckStock)
          ChipCustom(
            color: AppColors.text_negative,
            title: 'Xóa',
            perfixIcon: FaIcon(
              iconCode: 'f1f8',
              color: AppColors.text_negative,
            ),
            onTap: widget.onDelete,
          ),
      ],
    );
  }

  Widget _buildSelectUnit() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: 6.radius,
        border: Border.all(
          width: 1,
          color: AppColors.input_borderDefault,
        ),
      ),
      padding: 6.padingVer + 12.padingHor,
      child: PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return List.generate(widget.model.unit.length, (index) {
            return PopupMenuItem(
              child: Text('${widget.model.unit[index].name}'),
              onTap: () {
                widget.model.unitSell = widget.model.unit[index];
                widget.onUpdate?.call(widget.model);
              },
            );
          });
        },
        child: Row(
          children: [
            Text(
              widget.model.unitSell?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).expanded(),
            12.width,
            FaIcon(iconCode: 'f0d7', type: FaIconType.solid),
          ],
        ),
      ),
    );
  }

  Widget get _buildShipmentView {
    final listShipment = _product.listShipmentItemByQuantity;
    if (listShipment.isEmpty) {
      return const SizedBox();
    }
    final listFilter = _product.shipment?.data?.where(
      (e) {
        return e.code?.contains(shipmentSearch.text) ?? false;
      },
    ).toList();
    if (widget.editShipment) {
      return Column(
        children: [
          16.height,
          AppInputV2(
            controller: shipmentSearch,
            hintText: 'Tìm mã lô, mã phiếu nhập',
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: sp20,
            ),
            suffixIcon: GestureDetector(
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: sp20,
                color: AppColors.blue60,
              ),
            ),
          ),
          16.height,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = listFilter?[index];
              final isNearExp = (item?.endDate ?? DateTime.now())
                  .difference(DateTime.now())
                  .inDays;
              final textEctl = TextEditingController(
                text: (item!.selectedQuantity ~/ _product.valueUnitChange)
                    .toString(),
              );
              return Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: item.selectedQuantity > 0
                        ? mainColor
                        : AppColors.bg_border1,
                  ),
                  borderRadius: BorderRadius.circular(sp12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(
                        //   child: Text(
                        //     item.code ?? '',
                        //     style: s18w700,
                        //     overflow: TextOverflow.ellipsis,
                        //     maxLines: 1,
                        //   ),
                        // ),
                        Text(
                          item.code ?? '',
                          style: s18w700,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        sp8.width,
                        CircleAvatar(
                          radius: sp4,
                          backgroundColor: item.typeWarehouse?.code == 'KGD'
                              ? green_1
                              : yellow_1,
                        ),
                        const Spacer(),
                        16.width,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: sp4,
                            horizontal: sp8,
                          ),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(color: AppColors.bg_border1),
                            borderRadius: BorderRadius.circular(sp12),
                          ),
                          child: Text(
                            isNearExp < 30
                                ? isNearExp < 0
                                    ? 'Hết hạn'
                                    : 'Sắp hết hạn'
                                : 'Còn hạn',
                            style: s12w500.copyWith(
                              color: isNearExp < 30
                                  ? isNearExp < 0
                                      ? AppColors.red60
                                      : AppColors.yellow60
                                  : AppColors.green60,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mã phiếu',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ),
                        Text(
                          'Hạn sử dụng',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.importReceiptData?.code.toString() ?? '',
                          style:
                              s14w500.copyWith(color: AppColors.text_secondary),
                        ),
                        Text(
                          item.endDate.fomatDefaulft,
                          style:
                              s14w500.copyWith(color: AppColors.text_secondary),
                        ),
                      ],
                    ),
                    12.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tồn kho: ${(item.currentQuantity?.toInt() ?? 0) ~/ _product.valueUnitChange} ${_product.unitSell?.name}',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ).expanded(flex: 2),
                        16.width,
                        InputQuantity(
                          controller: textEctl,
                          max: item.currentQuantity?.toInt() ?? 0,
                          // enabled: enabled,
                          action: (value) {
                            updateShipmentItem(value, item);
                          },
                          onChanged: (value) {
                            // widget.model.quantity = value;
                            // _product.shipment
                            // widget.onUpdate?.call(widget.model);
                          },
                          onTapOutside: () {
                            final index = _product.shipment!.data!
                                .indexWhere((e) => e.id == item.id);
                            final quantityChange =
                                int.tryParse(textEctl.text.removeAllDot()) ?? 1;
                            final quantityCurrent = _product
                                .shipment!.data![index].selectedQuantity;
                            int amount = int.tryParse(amountTec.text) ?? 0;
                            amount += quantityChange - quantityCurrent;
                            amountTec.text = amount.toString();
                            widget.model.quantity = amount;
                            widget.onUpdate?.call(widget.model);
                            _product.shipment!.data![index] =
                                _product.shipment!.data![index].copyWith(
                              selectedQuantity: quantityChange,
                            );
                            widget.onUpdate?.call(_product);
                          },
                        ).expanded(),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => sp16.height,
            itemCount: listFilter?.length ?? 0,
          ),
        ],
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width - sp32 * 2,
      margin: const EdgeInsets.only(top: sp16),
      padding: const EdgeInsets.symmetric(horizontal: sp16),
      decoration: BoxDecoration(
        color: AppColors.brand5,
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: sp24,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.all(sp4),
                        decoration: BoxDecoration(
                          color: AppColors.bg_black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(sp4),
                        ),
                        child: Text(
                          'Lô: ${listShipment[index].code} - SL: ${listShipment[index].selectedQuantity ~/ _product.valueUnitChange} ${_product.unitSell?.name}',
                        ),
                      ),
                      separatorBuilder: (context, index) => sp4.width,
                      itemCount:
                          listShipment.length > 2 ? 2 : listShipment.length,
                    ),
                  ),
                ),
                if (listShipment.length > 2)
                  GestureDetector(
                    onTap: () => BtsShipmentInProduct.show(
                      context,
                      bloc: _bloc,
                      product: _product,
                      onUpdate: (value) {
                        amountTec.text = (value.quantity ?? 0).formatCurrency;
                        setState(() {});
                        widget.onUpdate?.call(value);
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: sp8, vertical: sp2),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.border_secondary),
                        borderRadius: BorderRadius.circular(sp24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.bg_black.withOpacity(0.05),
                            blurRadius: sp4,
                            spreadRadius: sp4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        '+${listShipment.length - 2}',
                        style: s14w500.copyWith(
                          color: AppColors.brand,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          sp12.width,
          TextButton(
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.all(sp0),
              ),
            ),
            onPressed: () => BtsShipmentInProduct.show(
              context,
              bloc: _bloc,
              product: _product,
              onUpdate: (value) {
                amountTec.text = (value.quantity ?? 0).formatCurrency;
                setState(() {});
                widget.onUpdate?.call(value);
              },
            ),
            child: const Text(
              'Chọn lô',
              // style: s12w400,
            ),
          ),
        ],
      ),
    );
  }

  void update(bool isPlus) {
    int amount = int.tryParse(amountTec.text) ?? 0;
    if (isPlus && amount > stock && widget.isCheckStock) {
      amount = stock.toInt();
    } else if (isPlus) {
      amount++;
    } else if (!isPlus && amount > 1) {
      amount--;
    }
    amountTec.text = amount.toString();
    widget.model.quantity = amount;
    widget.onUpdate?.call(widget.model);
  }

  void updateShipmentItem(bool isPlus, ShipmentItemEntity item) {
    update(isPlus);
    int amount = item.selectedQuantity;
    if (isPlus && amount >= (item.currentQuantity ?? 0)) {
      amount = item.currentQuantity?.toInt() ?? 0;
    } else if (isPlus) {
      amount++;
    } else if (!isPlus && amount > 1) {
      amount--;
    }
    // amountTec.text = amount.toString();
    if (_product.shipment?.data == null) return;
    final index = _product.shipment!.data!.indexWhere((e) => e.id == item.id);
    _product.shipment!.data![index] = _product.shipment!.data![index].copyWith(
      selectedQuantity: amount * _product.valueUnitChange,
    );
    widget.onUpdate?.call(_product);
  }
}
