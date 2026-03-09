import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/switch_label.dart';
import '../../../../../shared/components/input/input_column.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/product/config_sell_bloc.dart';
import '../../../blocs/product/params/prod_create_param.dart';

class WarehouseTab extends StatefulWidget {
  const WarehouseTab({super.key, required this.param, required this.bloc});

  final ProdCreateParam param;
  final ConfigSellBloc bloc;

  @override
  State<WarehouseTab> createState() => _WarehouseTabState();
}

class _WarehouseTabState extends State<WarehouseTab>
    with AutomaticKeepAliveClientMixin {
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: key,
      onChanged: () {
        key.currentState?.validate();
      },
      child: SingleChildScrollView(
        padding: 24.padingTop + 16.padingHor,
        child: Column(
          children: [
            InputColumn(
              label: 'Mã sản phẩm KAFA',
              padding: 0.pading,
              hintText: 'Nhập mã sản phẩm',
              initialValue: widget.param.product?.kafaCode,
              onChanged: (val) {
                widget.param.product?.kafaCode = val;
              },
            ),
            16.height,
            BlocBuilder<ConfigSellBloc, CubitState>(
              bloc: widget.bloc,
              builder: (context, state) {
                final base = widget.bloc.findBase;
                return FormField(
                  validator: (value) {
                    return base == null
                        ? 'Vui lòng thiết lập đơn vị tính'
                        : null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputColumn(
                          label: 'Số lượng nhập kho ban đầu',
                          padding: 0.pading,
                          hintText: 'Nhập số lượng',
                          initialValue:
                          widget.param.product?.availableStock?.toString(),
                          textInputType: TextInputType.number,
                          readOnly:!(widget.param.product?.canEditStock ?? true),
                          fillColor: !(widget.param.product?.canEditStock ?? true) ? AppColors.bg_disable : null,
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                              locale: 'vi',
                              decimalDigits: 0,
                              symbol: '',
                            ),
                          ],
                          suffixIcon:  SizedBox(
                            height: 48,
                            width: 48,
                            child: Center(
                              child: Text(
                                base?.name ?? '',
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            if(!key.currentState!.validate()) {
                              return;
                            }
                            widget.param.warehouse?.initialStock =
                                int.tryParse(val.removeAllDot());
                            widget.param.product?.stockQuantity =
                                int.tryParse(val.removeAllDot());
                          },
                        ),
                        if (field.hasError)
                          4.height,
                        if (field.hasError)
                          Text(
                            field.errorText ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
            16.height,
            SwitchLabel(
              label: 'Đang bán',
              value: widget.param.product?.active ?? false,
              onChanged: (val) {
                widget.param.product?.active = val;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
