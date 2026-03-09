import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../base/cache_image.dart';
import '../../../../../base/svg.dart';
import '../../../../../base/text_field.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../shared/utils/event.dart';

class ServiceOrderItem extends StatefulWidget {
  const ServiceOrderItem({
    super.key,
    required this.item,
    this.isSelected,
    this.onRemove,
    this.onUpdate,
  });

  final ServiceEntity item;
  final bool? isSelected;
  final Function()? onRemove;
  final Function(ServiceEntity)? onUpdate;

  @override
  State<ServiceOrderItem> createState() => _ServiceOrderItemState();
}

class _ServiceOrderItemState extends State<ServiceOrderItem> {
  late ServiceEntity _item;
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
                      url: ((widget.item.images ?? []).isNotEmpty
                              ? widget.item.images?.first
                              : '') ??
                          '',
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
                          widget.item.title ?? '',
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
                      '${FormatCurrency((widget.item.price.validator) - widget.item.directDiscount.validator)}đ',
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
      mainAxisSize: MainAxisSize.min,
      children: [
        (widthDevice(context) / 3).width,
        _buildInput(),
      ],
    );
  }

  void _changeAmount(ServiceEntity variant, int value) {
    if (value < 1) {
      return;
    }
    setState(() {
      _item = _item.copyWith(amount: value);
      widget.onUpdate?.call(_item);
    });
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
          onTapOutside: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          fn: focusNode,
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
