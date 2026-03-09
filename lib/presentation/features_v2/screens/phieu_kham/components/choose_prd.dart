import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/param/param_create_prescription.dart';
import 'package:pharmago/presentation/features_v2/components/bottom_sheet/bts_prd.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';

class ChoosePrdPk extends StatefulWidget {
  final ItemsPrdData? item;
  final Function(ItemsPrdData?)? onChanged;
  final Function()? onRemove;
  const ChoosePrdPk({
    super.key,
    this.item,
    this.onChanged,
    this.onRemove,
  });

  @override
  State<ChoosePrdPk> createState() => _ChoosePrdPkState();
}

class _ChoosePrdPkState extends State<ChoosePrdPk> {
  final name = TextEditingController();
  final qty = TextEditingController();
  final note = TextEditingController();

  setData() {
    name.text = widget.item?.variantName ?? '';
    qty.text = widget.item?.quantity.formatPrice() ?? '';
    note.text = widget.item?.lieuDung ?? '';
  }

  VariantEntity? prd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputColumn(
              onTap: () {
                context
                    .bottomSheet(
                  BtsPrd(
                    id: widget.item?.variantId,
                  ),
                )
                    .then(
                  (value) {
                    if (value is VariantEntity) {
                      prd = value;
                      widget.item?.variantId = value.id;
                      widget.item?.variantName = value.name;
                      name.text = value.name ?? '';
                      widget.item?.units = value.units;
                      widget.item?.unit = value.units.validator.isEmpty
                          ? null
                          : value.units?.first.id;
                      widget.item?.level = value.units.validator.isEmpty
                          ? null
                          : value.units?.first.level;
                      widget.onChanged?.call(widget.item);
                    }
                  },
                );
              },
              padding: EdgeInsets.zero,
              label: 'Sản phẩm',
              controller: name,
              isRequired: true,
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
            ),
            sp16.height,
            InputColumn(
              padding: EdgeInsets.zero,
              label: 'Số lượng',
              textInputType: TextInputType.number,
              controller: qty,
              isRequired: true,
              inputFormatters: [
                CurrencyTextInputFormatter.currency(
                  locale: 'vi',
                  decimalDigits: 0,
                  symbol: '',
                ),
              ],
              onChanged: (p0) {
                widget.item?.quantity = int.tryParse(p0.replaceAll('.', ''));
                widget.onChanged?.call(widget.item);
              },
            ),
            sp16.height,
            DropDownColumn<int>(
              label: 'Đơn vị',
              value: widget.item?.unit,
              padding: EdgeInsets.zero,
              onChanged: (p0) {
                widget.item?.unit = p0;
                widget.item?.level = widget.item?.units
                    ?.where(
                      (element) => element.id == p0,
                    )
                    .toList()
                    .first
                    .level;
              },
              items: widget.item?.units
                      ?.map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(
                            e.name ?? '',
                            style: StyleApp.normal(),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),
            sp16.height,
            InputColumn(
              padding: EdgeInsets.zero,
              label: 'Ghi chú sản phẩm',
              controller: note,
              isRequired: true,
              onChanged: (p0) {
                widget.item?.lieuDung = p0;
                widget.onChanged?.call(widget.item);
              },
            ),
          ],
        ).container(),
        Positioned(
          top: 10,
          right: 10,
          child: InkWell(
            onTap: widget.onRemove,
            child: const Icon(
              Icons.close,
              color: ColorApp.black,
            ),
          ),
        ),
      ],
    );
  }
}
