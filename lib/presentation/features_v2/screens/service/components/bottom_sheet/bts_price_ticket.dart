import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/shared/components/button/switch_label.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../config/app_style/init_app_style.dart';

class BtsPriceTicket extends StatefulWidget {
  final PriceTypeService? price;
  final bool isDefault;
  const BtsPriceTicket({
    super.key,
    this.price,
    this.isDefault = false,
  });

  @override
  State<BtsPriceTicket> createState() => _BtsPriceTicketState();
}

class _BtsPriceTicketState extends State<BtsPriceTicket> {
  PriceTypeService value = PriceTypeService();
  final _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.price != null) {
      value.price = widget.price?.price ?? 0;
      value.isActive = widget.price?.isActive ?? false;
    } else {
      value.isActive = widget.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Dịch vụ theo lượt',
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
            InputColumn(
              label: 'Đơn giá',
              isRequired: true,
              hintText: 'Nhập giá',
              padding: 0.pading,
              initialValue: value.price.formatPrice(),
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
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '/lượt',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.input_textDefault,
                    ),
                  ),
                ],
              ),
              textInputType: TextInputType.number,
              onChanged: (p0) {
                value.price = int.tryParse(p0.replaceAll('.', '')) ?? 0;
              },
            ),
            const Divider(
              height: 32,
            ),
            SwitchLabel(
              value: value.isActive,
              onChanged: (val) {
                value.isActive = val;
              },
              label: 'Chọn làm Giá dịch vụ cơ sở',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.ultility_carrot_60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
