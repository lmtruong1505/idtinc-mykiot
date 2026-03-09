import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';

import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../../product/domain/entities/variant_entity.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';

class CardVariantCreateOrder extends StatefulWidget {
  const CardVariantCreateOrder({
    super.key,
    required this.variant,
    required this.myBloc,
    required this.index,
  });

  final VariantEntity variant;
  final OrderCreateCubit myBloc;
  final int index;

  @override
  State<CardVariantCreateOrder> createState() => _CardVariantCreateOrderState();
}

class _CardVariantCreateOrderState extends State<CardVariantCreateOrder> {
  final _ctl = TextEditingController()..text;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceCtl;

  @override
  void initState() {
    super.initState();
    _priceCtl =
        TextEditingController(text: FormatCurrency(widget.variant.discount));
    _ctl.text = '1';
    widget.myBloc.variantChange(
      widget.index,
      amountUnit: '1',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(sp16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp12),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  // leading: SizedBox(
                  //   height: sp48,
                  //   width: sp48,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(sp8),
                  //     child: BaseCacheImage(
                  //       url: widget.variant.media ?? PrefKeys.imgProductDefault,
                  //     ),
                  //   ),
                  // ),
                  title: Text(
                    widget.variant.name ?? 'Chưa có dữ liệu',
                    style: p5.copyWith(color: blackColor),
                  ),
                  subtitle: Text(
                    '${FormatCurrency(widget.variant.priceSell)}đ',
                    style: p6.copyWith(color: green_1),
                  ),
                  subtitleTextStyle: p5.copyWith(
                    color: blackColor,
                  ),
                  trailing: IconButton(
                    onPressed: () => widget.myBloc.removeVariant(widget.index),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: red_1,
                    ),
                  ),
                ),
                gapHeight(sp12),
                // RowItem(
                //   title: 'Số lượng tồn',
                //   content: FormatCurrency(widget.variant.quantityInStock),
                // ),
                //gapHeight(sp12),

                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        controller: _priceCtl,
                        label: 'Khuyến mãi',
                        hintText: '',
                        backgroundColor: bg_5,
                        borderColor: bg_5,
                        suffixIcon: const Icon(
                          Icons.percent_sharp,
                        ),
                        onChanged: (value) => widget.myBloc.variantChange(
                          widget.index,
                          //priceSell: double.tryParse(value),
                          discount: value,
                        ),
                      ),
                    ),
                    gapWidth(sp12),
                    Expanded(
                      child: AppInput(
                        controller: _ctl,
                        // label: 'Số lượng',
                        //hintText: 'Nhập số lượng'
                        //required: true,
                        backgroundColor: bg_5,
                        borderColor: bg_5,
                        validate: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Nhập số lượng bán';
                          } else if (widget.variant.amount >
                              widget.variant.quantityInStock) {
                            return 'Số lượng bán quá tồn kho';
                          }
                        },
                        onChanged: (value) => widget.myBloc.variantChange(
                          widget.index,
                          amountUnit: value,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => _showDialog(
                            CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: sp32,
                              scrollController: FixedExtentScrollController(
                                initialItem: widget.variant.units?.indexWhere(
                                      (e) =>
                                          e.id ==
                                          widget.variant.unitSelected?.id,
                                    ) ??
                                    0,
                              ),
                              onSelectedItemChanged: (int index) {
                                widget.myBloc.variantChange(
                                  widget.index,
                                  unitSelected: widget.variant.units?[index],
                                );
                              },
                              children: List<Widget>.generate(
                                  widget.variant.units?.length ?? 0,
                                  (int index) {
                                return Center(
                                  child: Text(
                                      widget.variant.units?[index].name ?? ''),
                                );
                              }),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.variant.unitSelected?.name ?? '',
                                style: p5.copyWith(
                                  color: (widget.variant.units?.length ?? 0) > 1
                                      ? blue_1
                                      : blackColor,
                                ),
                              ),
                              gapWidth(sp8),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: (widget.variant.units?.length ?? 0) > 1
                                    ? blue_1
                                    : blackColor,
                              ),
                              gapWidth(sp12),
                            ],
                          ),
                        ),
                        hintText: '',
                      ),
                    )
                  ],
                ),
                gapHeight(sp12),
                // InputCurrency(
                //   controller: _ctl,
                //   label: 'Số lượng',
                //   hintText: 'Nhập số lượng',
                //   required: true,
                //   backgroundColor: bg_5,
                //   borderColor: bg_5,
                //   validate: (value) {
                //     if (value?.isEmpty ?? true) {
                //       return 'Nhập số lượng bán';
                //     } else if (widget.variant.amount > widget.variant.quantityInStock) {
                //       return 'Số lượng bán quá tồn kho';
                //     }
                //   },
                //   onChanged: (value) => widget.myBloc.variantChange(
                //     widget.index,
                //     amountUnit: value,
                //   ),
                //   suffixIcon: InkWell(
                //     onTap: () => _showDialog(
                //       CupertinoPicker(
                //         magnification: 1.22,
                //         squeeze: 1.2,
                //         useMagnifier: true,
                //         itemExtent: sp32,
                //         scrollController: FixedExtentScrollController(
                //           initialItem: widget.variant.units?.indexWhere(
                //                 (e) => e.id == widget.variant.unitSelected?.id,
                //               ) ??
                //               0,
                //         ),
                //         onSelectedItemChanged: (int index) {
                //           widget.myBloc.variantChange(
                //             widget.index,
                //             unitSelected: widget.variant.units?[index],
                //           );
                //         },
                //         children: List<Widget>.generate(
                //             widget.variant.units?.length ?? 0, (int index) {
                //           return Center(
                //             child: Text(widget.variant.units?[index].name ?? ''),
                //           );
                //         }),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Text(
                //           widget.variant.unitSelected?.name ?? '',
                //           style: p5.copyWith(
                //             color: (widget.variant.units?.length ?? 0) > 1
                //                 ? blue_1
                //                 : blackColor,
                //           ),
                //         ),
                //         gapWidth(sp8),
                //         Icon(
                //           Icons.arrow_drop_down_rounded,
                //           color: (widget.variant.units?.length ?? 0) > 1
                //               ? blue_1
                //               : blackColor,
                //         ),
                //         gapWidth(sp12),
                //       ],
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: !(widget.variant.unitSelected?.isDefault ?? true),
                  child: Container(
                    margin: const EdgeInsets.only(top: sp12, left: sp24),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: p9.copyWith(color: blackColor),
                        children: [
                          const TextSpan(text: '~ Số lượng quy đổi: '),
                          TextSpan(
                            text: FormatCurrency(widget.variant.amount),
                            style: p7.copyWith(color: mainColor),
                          ),
                          TextSpan(
                            text:
                                ' ${widget.variant.units?.firstWhere((e) => e.isDefault).name}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: sp12),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: whiteColor,
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
