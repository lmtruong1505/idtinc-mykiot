import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../cubit/product_create_cubit/product_create_cubit.dart';
import '../../cubit/product_create_cubit/product_create_state.dart';

class UnitChangeItem extends StatefulWidget {
  const UnitChangeItem({
    super.key,
    required this.myBloc,
    required this.index,
    //required this.formKey,
    this.onRemove,
  });

  final ProductCreateCubit myBloc;
  final int index;
  //final GlobalKey<FormState> formKey;
  final Function()? onRemove;

  @override
  State<UnitChangeItem> createState() => _UnitChangeItemState();
}

class _UnitChangeItemState extends State<UnitChangeItem> {
  late TextEditingController priceSellCtl;
  late TextEditingController priceImportCtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: blue_2,
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thông tin quy đổi',
                style: p5.copyWith(color: blackColor),
              ),
              InkWell(
                onTap: () {
                  widget.onRemove?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: yellow_1,
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Đã xoá đơn vị quy đổi',
                        style: p5.copyWith(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: sp48 - sp8,
                  height: sp48 - sp8,
                  decoration: BoxDecoration(
                    color: red_2.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(sp8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: sp16,
                      color: red_1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          gapHeight(sp16),
          AppInput(
            label: 'Tên quy đổi',
            required: true,
            hintText: 'Nhập tên quy đổi',
            backgroundColor: whiteColor,
            initialValue:
                widget.myBloc.state.unitChangesPayload[widget.index].name,
            borderColor: whiteColor,
            textInputType: TextInputType.text,
            onChanged: (value) {
              widget.myBloc.unitChangeFormChange(
                index: widget.index,
                name: value,
              );
            },
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Nhập tên quy đổi';
              }
            },
          ),
          gapHeight(sp12),
          AppInput(
            label: 'Giá trị quy đổi',
            required: true,
            hintText: 'Nhập giá trị quy đổi',
            initialValue: widget.myBloc.state.unitChangesPayload[widget.index]
                        .value !=
                    null
                ? widget.myBloc.state.unitChangesPayload[widget.index].value
                    ?.toInt()
                    .toString()
                    .formatCurrency()
                : '',
            backgroundColor: whiteColor,
            borderColor: whiteColor,
            textInputType: TextInputType.number,
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'vi',
                decimalDigits: 0,
                symbol: '',
              ),
            ],
            onChanged: (value) {
              final price =
                  (widget.myBloc.state.unitsPayload.sellPrice ?? 0) *
                      (int.tryParse(value) ?? 0);
              widget.myBloc.unitChangeFormChange(
                index: widget.index,
                value: int.parse(value.removeAllNonNumeric()),
                priceSell: price.toString(),
              );
            },
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Nhập giá trị quy đổi';
              }
            },
          ),
          gapHeight(sp12),
          BlocBuilder<ProductCreateCubit, ProductCreateState>(
            bloc: widget.myBloc,
            builder: (context, state) {
              final price =
                  (widget.myBloc.state.unitsPayload.sellPrice ?? 0) *
                      (widget.myBloc.state.unitChangesPayload[widget.index]
                              .value ??
                          0);
              priceSellCtl = TextEditingController(
                text: FormatCurrency(price),
              );
              return InputCurrency(
                controller: priceSellCtl,
                label: 'Giá bán',
                required: true,
                hintText: 'Nhập giá bán',
                backgroundColor: whiteColor,
                borderColor: whiteColor,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                validate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nhập giá bán';
                  }
                },
                onChanged: (value) {
                  widget.myBloc.unitChangeFormChange(
                    index: widget.index,
                    priceSell: value,
                  );
                },
              );
            },
          ),
          gapHeight(sp12),
          BlocBuilder<ProductCreateCubit, ProductCreateState>(
            bloc: widget.myBloc,
            builder: (context, state) {
              final price =
                  (widget.myBloc.state.unitsPayload.importPrice ?? 0) *
                      (widget.myBloc.state.unitChangesPayload[widget.index]
                              .value ??
                          0);
              priceImportCtl = TextEditingController(
                text: FormatCurrency(price),
              );
              return InputCurrency(
                controller: priceImportCtl,
                label: 'Giá nhập',
                required: true,
                hintText: 'Nhập giá nhập',
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    symbol: '',
                  ),
                ],
                backgroundColor: whiteColor,
                borderColor: whiteColor,
                validate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nhập giá nhập';
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
