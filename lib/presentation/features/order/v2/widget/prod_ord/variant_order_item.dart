import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/constants/pref_key.dart';
import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../base/cache_image.dart';
import '../../../../../base/svg.dart';
import '../../../../../base/text_field.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../shared/utils/event.dart';
import '../../../../product/domain/entities/variant_entity.dart';

class VariantOrderItem extends StatefulWidget {
  const VariantOrderItem({
    super.key,
    required this.item,
    this.isSelected,
    this.onRemove,
    this.onUpdate,
  });

  final VariantEntity item;
  final bool? isSelected;
  final Function()? onRemove;
  final Function(VariantEntity)? onUpdate;

  @override
  State<VariantOrderItem> createState() => _VariantOrderItemState();
}

class _VariantOrderItemState extends State<VariantOrderItem> {
  late VariantEntity _item;
  TextEditingController amountTec = TextEditingController();

  final focusNode = FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus && amountTec.text.isEmpty) {
        setState(() {
          amountTec.text = '1';
          _changeAmount.call(
            _item,
            1,
          );
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    amountTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _item = widget.item;
    amountTec.text = (_item.amount).toString();
    return Container(
      padding: const EdgeInsets.all(sp12),
      margin: 16.padingBottom,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(color: ColorApp.greyE2),
        color: ColorApp.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: sp12),
                child: SizedBox(
                  height: 65,
                  width: 65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sp8),
                    child: BaseCacheImage(
                      url: widget.item.media ?? PrefKeys.imgProductDefault,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: sp12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.item.name ?? '',
                          style: StyleApp.bold(
                            fontSize: 14,
                            color: ColorApp.black,
                          ),
                        ).expanded(),
                        16.width,
                        InkWell(
                          onTap: () {
                            widget.onRemove?.call();
                          },
                          child: IcSvg.asset('/ic_delete_2.svg'),
                        ),
                      ],
                    ),
                    Text(
                      '${FormatCurrency((widget.item.unit?.sellPrice.validator ?? 0) - widget.item.discount.validator)}đ',
                      style: StyleApp.semibold(
                        fontSize: 14,
                        color: ColorApp.main,
                      ),
                    ),
                    _buildQuantity(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdown(),
        _buildInput(),
      ],
    );
  }

  void _changeAmount(VariantEntity variant, int value) {
    if (value < 1) {
      return;
    }
    setState(() {
      _item = _item.copyWith(amount: value);
      widget.onUpdate?.call(_item);
    });
  }

  Widget _buildDropdown() {
    return PopupMenuButton(
      child: Row(
        children: [
          Text(
            _item.unit?.name ?? '',
            style: StyleApp.bold(
              fontSize: 14,
              color: ColorApp.black,
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: ColorApp.black,
          ),
        ],
      ),
      itemBuilder: (context) {
        return List.generate(widget.item.units?.length ?? 0, (index) {
          return PopupMenuItem(
            child: Text(
              widget.item.units?[index].name ?? '',
              style: StyleApp.normal(
                fontSize: 14,
                color: ColorApp.black,
              ),
            ),
            onTap: () {
              print(
                  '===> ${_item.discount.validator} - ${widget.item.units?[index].sellPrice.validator}');
              if (_item.discount.validator >=
                  (widget.item.units?[index].sellPrice.validator ?? 0)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: ColorApp.red,
                    content:
                        Text('Giảm giá trên đơn vị không được lớn hơn giá bán'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
                return;
              }
              setState(() {
                _item = _item.copyWith(
                  unit: widget.item.units?[index],
                );
                widget.onUpdate?.call(_item);
              });
            },
          );
        });
      },
    ).expanded(flex: 1);
  }

  Widget _buildInput() {
    return Stack(
      children: [
        AppInputSupport(
          controller: amountTec,
          textInputType: TextInputType.number,
          hintText: 'Nhập số lượng',
          textAlign: TextAlign.center,
          onChanged: (value) => _changeAmount.call(
            _item,
            int.tryParse(value) ?? 0,
          ),
          fn: focusNode,
          onTapOutside: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          backgroundColor: bg_4,
          borderColor: bg_4,
          radius: 9999,
          maxLines: 1,
          padding: 4.pading,
          isDense: true,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: InkWell(
            onTap: () {
              if (_item.amount == 1) {
                return;
              }
              _changeAmount.call(
                _item,
                _item.amount - 1,
              );
              amountTec.text = '${_item.amount - 1}';
              context.unFocus();
            },
            child: const SizedBox(
              height: 28,
              width: 28,
              child: Center(
                child: Icon(
                  Icons.remove,
                  size: sp16,
                  color: borderColor_4,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              _changeAmount.call(
                _item,
                _item.amount + 1,
              );
              amountTec.text = '${_item.amount + 1}';
              context.unFocus();
            },
            child: const SizedBox(
              height: 28,
              width: 28,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: sp16,
                  color: borderColor_4,
                ),
              ),
            ),
          ),
        ),
      ],
    ).flexible(flex: 1);
  }
}
