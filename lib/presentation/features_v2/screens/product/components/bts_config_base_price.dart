import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/input_column.dart';
import '../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/product/config_sell_bloc.dart';

class BtsConfigBasePrice extends StatefulWidget {
  const BtsConfigBasePrice({super.key, required this.bloc});

  final ConfigSellBloc bloc;

  @override
  State<BtsConfigBasePrice> createState() => _BtsConfigBasePriceState();
}

class _BtsConfigBasePriceState extends State<BtsConfigBasePrice> {
  final key = GlobalKey<FormState>();
  final sell = TextEditingController();
  final import = TextEditingController();
  final vat = TextEditingController();

  @override
  void initState() {
    final base = widget.bloc.findBase;
    level = base?.level ?? 1;
    if (base != null) {
      sell.text = base.sellPrice.formatPrice();
      //import.text = base.importPrice.formatPrice();
    }
    import.text = widget.bloc.import_price.formatCurrency;
    vat.text = widget.bloc.vat.formatCurrency;
    super.initState();
  }

  int? level;

  @override
  Widget build(BuildContext context) {
    print('level $level');
    return Form(
      key: key,
      child: BgBts(
        label: 'Thiết lập giá cơ sở',
        cancelText: 'Huỷ',
        onCancel: () {
          context.pop();
        },
        confirmText: 'Xác nhận',
        onConfirm: () {
          if (!key.currentState!.validate()) {
            return;
          }
          final double sellPrice =
              double.tryParse(sell.text.removeAllDot()) ?? 0;
          final double importPrice =
              double.tryParse(import.text.removeAllDot()) ?? 0;
          final double vatPrice = double.tryParse(vat.text) ?? 0;
          widget.bloc
              .updatePrice(level ?? -1, sellPrice, importPrice, vatPrice);
          context.pop();
        },
        child: BlocBuilder<ConfigSellBloc, CubitState>(
          bloc: widget.bloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropDownColumn(
                  label: 'Đơn vị tính giá cơ sở',
                  isRequired: true,
                  padding: 0.pading,
                  items: List.generate(
                    widget.bloc.list.length,
                    (index) => DropdownMenuItem(
                      value: widget.bloc.list[index].level,
                      child: Text(widget.bloc.list[index].name ?? ''),
                    ),
                  ),
                  value: level,
                  onChanged: (value) {
                    level = value as int;
                  },
                ),
                16.height,
                _buildPrice(),
                4.height,
                FormField(
                  validator: (val) {
                    final double sellPrice =
                        double.tryParse(sell.text.removeAllDot()) ?? 0;
                    if (sellPrice.toInt() % 100 != 0) {
                      return 'Giá bán phải là bội số của 100đ';
                    }
                    final double importPrice =
                        double.tryParse(import.text.removeAllDot()) ?? 0;
                    if (sellPrice <= importPrice) {
                      return 'Giá bán phải lớn hơn giá nhập';
                    }
                    return null;
                  },
                  builder: (field) => Column(
                    children: [
                      Text(
                        'Giá bán là bội số của 100đ',
                        style: AppStyle.bodySmRegular.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ),
                      if (field.hasError) 4.height,
                      if (field.hasError)
                        Text(
                          field.errorText ?? '',
                          style: AppStyle.bodySmRegular.copyWith(
                            color: AppColors.red50,
                          ),
                        ),
                    ],
                  ),
                ),
                16.height,
                DropDownColumn(
                  label: 'Thuế VAT (%)',
                  isRequired: true,
                  padding: 0.pading,
                  items: vats
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text('$e%'),
                        ),
                      )
                      .toList(),
                  value: widget.bloc.vat.toInt(),
                  onChanged: (value) {
                    widget.bloc.vat = value?.toDouble() ?? 0;
                  },
                ),
                // FormField(
                //   validator: (value) {
                //     if(widget.bloc.vat < 0 || widget.bloc.vat > 100) {
                //       return 'Thuế VAT không hợp lệ';
                //     }
                //   },
                //   builder: (field) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         InputColumn(
                //           label: 'Thuế VAT (%)',
                //           padding: 0.pading,
                //           controller: vat,
                //           prefixIcon: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               16.width,
                //               Text(
                //                 '%',
                //                 style: AppStyle.bodyBsRegular.copyWith(
                //                   color: AppColors.input_textDefault,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           inputFormatters: [
                //             CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
                //           ],
                //           textInputType: TextInputType.number,
                //           onChanged: (p0) {
                //             widget.bloc.vat = p0.removeAllDot().toDouble ?? 0;
                //           },
                //         ),
                //         if(field.hasError)
                //           4.height,
                //         if(field.hasError)
                //           Text(
                //             field.errorText ?? '',
                //             style: AppStyle.bodySmRegular.copyWith(
                //               color: AppColors.red50,
                //             ),
                //           ),
                //       ],
                //     );
                //   },
                // )
              ],
            );
          },
        ),
      ),
    );
  }

  _buildPrice() {
    return Row(
      children: [
        InputColumn(
          label: 'Giá bán',
          isRequired: true,
          controller: sell,
          padding: 0.pading,
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.width,
              FaIcon(
                iconCode: 'e169',
                color: AppColors.input_iconDefault,
              ),
            ],
          ),
          textInputType: TextInputType.number,
          onChanged: (p0) {
            // widget.bloc.basePrice = p0.removeAllDot().toInt;
          },
        ).expanded(),
        12.width,
        InputColumn(
          label: 'Giá nhập ban đầu',
          hintText: 'Nhập giá nhập',
          isRequired: true,
          padding: 0.pading,
          controller: import,
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.width,
              FaIcon(
                iconCode: 'e169',
                color: AppColors.input_iconDefault,
              ),
            ],
          ),
          textInputType: TextInputType.number,
          onChanged: (p0) {
             widget.bloc.import_price = p0.removeAllDot().toDouble ?? 0;
          },
        ).expanded(),
      ],
    );
  }

  List<int> vats = [0, 5, 8, 10];
}
