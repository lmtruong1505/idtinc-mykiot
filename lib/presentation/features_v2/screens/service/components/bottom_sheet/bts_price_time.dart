import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/button/switch_label.dart';
import '../../../../../../shared/components/input/input_column.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../models/service/service.dart';

class BtsPriceTime extends StatefulWidget {
  final PriceTypeService? price;
  final List<ServiceTypeV2Model> namePrice;
  final bool isDefault;
  const BtsPriceTime({
    super.key,
    this.price,
    this.isDefault = false,
    required this.namePrice,
  });

  @override
  State<BtsPriceTime> createState() => _BtsPriceTimeState();
}

class _BtsPriceTimeState extends State<BtsPriceTime> {
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
      label: 'Dịch vụ theo thời gian',
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
                value.valueName = p0?.title?.replaceAll('Vé ', '') ?? 'giờ';
                value.type = p0;
              },
            ),
            16.height,
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
              textInputType: TextInputType.number,
              onChanged: (p0) {
                value.price = int.tryParse(p0.replaceAll('.', '')) ?? 0;
              },
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
            ),
            16.height,
            SwitchLabel(
              label: 'Giới hạn số lượt',
              value: value.isLimit ?? false,
              onChanged: (val) {
                value.isLimit = val;
                setState(() {});
              },
            ),
            ExpandedSection(
              isSelected: value.isLimit == true,
              child: Column(
                children: [
                  16.height,
                  InputColumn(
                    initialValue: "${value.count ?? ""}",
                    label: 'Số lượt tối đa',
                    isRequired: value.isLimit == true,
                    padding: 0.pading,
                    textInputType: TextInputType.number,
                    onChanged: (p0) {
                      value.count = int.tryParse(p0) ?? 0;
                    },
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'lượt',
                          style: AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.input_textDefault,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 32,
            ),
            SwitchLabel(
              label: 'Chọn làm Giá dịch vụ cơ sở',
              value: value.isActive,
              onChanged: (val) {
                value.isActive = val;
              },
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
