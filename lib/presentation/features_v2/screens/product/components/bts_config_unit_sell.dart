import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/bg/bg_bts.dart';
import '../../../../config/app_style/init_app_style.dart';

class BtsConfigUnitSell extends StatefulWidget {
  const BtsConfigUnitSell({super.key, this.unit, this.isUpdate = false, required this.prev, required this.name});

  final UnitV2Model? unit;
  final bool isUpdate;
  final String prev;
  final List<String> name;

  @override
  State<BtsConfigUnitSell> createState() => _BtsConfigUnitSellState();
}

class _BtsConfigUnitSellState extends State<BtsConfigUnitSell> {
  final key = GlobalKey<FormState>();

  late int level;
  final unitText = TextEditingController();
  final valueText = TextEditingController();
  String cur = '';

  @override
  void initState() {
    super.initState();
    if(widget.isUpdate) {
      unitText.text = widget.unit?.name ?? '';
      valueText.text = widget.unit?.value?.toString() ?? '';
      level = widget.unit?.level ?? 0;
      cur = widget.unit?.name ?? '';
    }
    if(!widget.isUpdate) {
      level =  widget.unit?.level ?? 0;
      level++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: BgBts(
        label: 'Thiết lập đơn vị bán',
        cancelText: 'Huỷ',
        onCancel: () {
          context.pop();
        },
        confirmText: 'Xác nhận',
        onConfirm: () {
          if (!key.currentState!.validate()) {
            return;
          }
          if (widget.isUpdate) {
            context.pop(result: widget.unit);
          } else {
            context.pop(
              result: UnitV2Model(
                name: unitText.text,
                value: level > 1 ? valueText.text.removeAllDot().toInt : 1,
                level: level,
              ),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputColumn(
              label: 'Đơn vị tính cấp $level',
              controller: unitText,
              onChanged: (value) {
                if (widget.isUpdate) {
                  widget.unit?.name = value;
                } else {
                  unitText.text = value;
                }
              },
              isRequired: true,
              validate: (value) {
                if (value.isEmptyOrNull) {
                  return 'Vui lòng nhập đơn vị tính';
                }
                if(!widget.isUpdate && widget.name.contains(value)) {
                  return 'Đơn vị tính đã tồn tại';
                }
                if(widget.isUpdate && widget.name.contains(value) && cur != value) {
                  return 'Đơn vị tính đã tồn tại';
                }
                return null;
              },
              padding: 0.pading,
            ),
            if (level > 1) 16.height,
            if (level > 1)
              InputColumn(
                label: 'Giá trị quy đổi',
                padding: 0.pading,
                isRequired: true,
                controller: valueText,
                textInputType: TextInputType.number,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
                ],
                onChanged: (value) {
                  if (widget.isUpdate) {
                    widget.unit?.value = value.removeAllDot().toInt;
                  } else {
                    valueText.text = value;
                  }
                },
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    12.width,
                    const Text('1 '),
                    Text('${widget.prev} = '),
                    8.width,
                    const VerticalDivider(
                      color: AppColors.input_borderDefault,
                      thickness: 1,
                      width: 0,
                    ).size(height: 48),
                    8.width,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
