import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/button/switch_label.dart';
import '../../../../../../shared/components/input/input_column.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../models/service/service.dart';

class BtsPriceTreatment extends StatefulWidget {
  final PriceTypeService? price;
  final List<ServiceTypeV2Model> namePrice;
  final bool isDefault;
  const BtsPriceTreatment({
    super.key,
    this.price,
    this.isDefault = false,
    required this.namePrice,
  });

  @override
  State<BtsPriceTreatment> createState() => _BtsPriceTreatmentState();
}

class _BtsPriceTreatmentState extends State<BtsPriceTreatment> {
  PriceTypeService value = PriceTypeService();
  final _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.price != null) {
      value = widget.price!;
    } else {
      value.isActive = widget.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Dịch vụ liệu trình',
      cancelText: 'Huỷ bỏ',
      confirmText: 'Xác nhận',
      onCancel: () => context.pop(),
      onConfirm: () {
        if (_keyForm.currentState!.validate()) {
          context.pop(result: value);
        }
      },
      child: Form(
        key: _keyForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropDownColumn<ServiceTypeV2Model>(
              label: 'Tên đơn giá',
              isRequired: true,
              padding: 0.pading,
              value: value.type,
              items: List.generate(
                widget.namePrice.length,
                (index) {
                  return DropdownMenuItem(
                    value: widget.namePrice[index],
                    child: Text(
                      widget.namePrice[index].title ?? '',
                      style: AppStyle.bodyBsRegular,
                    ),
                  );
                },
              ),
              onChanged: (p0) {
                value.priceName = p0?.title ?? 'Vé giờ';
                value.valueName = 'liệu trình';
                value.type = p0;
              },
            ),
            16.height,
            InputColumn(
              label: 'Đơn giá',
              isRequired: true,
              hintText: 'Nhập giá',
              padding: 0.pading,
              initialValue: value.price.formatPercent(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '/liệu trình',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.input_textDefault,
                    ),
                  ),
                  12.width,
                ],
              ),
              inputFormatters: [
                CurrencyTextInputFormatter.currency(
                  locale: 'vi',
                  symbol: '',
                  maxValue: PrefKeys.maxPrice,
                ),
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
                value.price = int.tryParse(p0.replaceAll('.', '')) ?? 0;
              },
            ),
            16.height,
            InputColumn(
              label: 'Số buổi',
              isRequired: true,
              padding: 0.pading,
              hintText: 'Nhập tổng số buổi',
              textInputType: TextInputType.number,
              initialValue: '${value.count ?? ''}',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'buổi',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.input_textDefault,
                    ),
                  ),
                ],
              ),
              onChanged: (p0) {
                value.count = int.tryParse(p0) ?? 0;
              },
            ),
            const Divider(
              height: 32,
            ),
            SwitchLabel(
              label: 'Chọn làm Giá dịch vụ cơ sở',
              value: value.isActive,
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.ultility_carrot_60,
              ),
              onChanged: (val) {
                value.isActive = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
