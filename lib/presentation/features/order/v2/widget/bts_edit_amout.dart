import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_string.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/color_app.dart';
import '../../../../../shared/style_app/style_text.dart';
import '../../../../base/button.dart';
import '../../../../base/text_field.dart';
import '../../../../base/v2/text_row.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../shared/utils/event.dart';

class BtsEditAmount extends StatefulWidget {
  const BtsEditAmount({
    super.key,
    required this.variant,
    this.onConfirm,
    this.offset,
  });

  final VariantEntity variant;
  final Function(VariantEntity value)? onConfirm;
  final int? offset;

  @override
  State<BtsEditAmount> createState() => _BtsEditAmountState();
}

class _BtsEditAmountState extends State<BtsEditAmount> {
  TextEditingController amountTec = TextEditingController();
  late VariantEntity _variant;
  final _keyForm = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _variant = widget.variant;
    focusNode.addListener(() {
      if (!focusNode.hasFocus && amountTec.text.isEmpty) {
        setState(() {
          amountTec.text = '1';
          _changeAmount.call(
            _variant,
            1,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    amountTec.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    amountTec.text = (_variant.amount).toString();
    return Container(
      padding: const EdgeInsets.only(top: sp12),
      width: widthDevice(context),
      height: heightDevice(context) - (widget.offset ?? (40 + 100 + 70)),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.2),
            offset: const Offset(0, -1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: _bodyBuild,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.2),
                offset: const Offset(0, -1),
                blurRadius: sp4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextRow2(
                title: 'Tổng hóa đơn',
                content: '${FormatCurrency(_getTotalPrice())}đ',
                titleStyle: p5.copyWith(color: greyColor),
              ),
              8.height,
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor_2),
                      borderRadius: BorderRadius.circular(sp12),
                    ),
                    width: sp48,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: IconButton(
                        onPressed: () => context.router.pop(),
                        icon: const Icon(Icons.close_rounded, size: sp20),
                      ),
                    ),
                  ),
                  const SizedBox(width: sp16),
                  Expanded(
                    child: MainButton(
                      title: 'Xác nhận',
                      event: () {
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }
                        widget.onConfirm?.call(_variant);
                        context.router.pop();
                      },
                      largeButton: true,
                      icon: null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _bodyBuild => Padding(
        padding: const EdgeInsets.symmetric(horizontal: sp16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 2,
              color: borderColor_4,
              indent: widthDevice(context) / 2 - sp32,
              endIndent: widthDevice(context) / 2 - sp32,
            ),
            const SizedBox(height: sp16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildDirectDiscount(),
                    8.height,
                    const Divider(),
                    8.height,
                    Row(
                      children: [
                        _buildInfo(),
                        _buildDropdown(),
                        12.width,
                        _buildInput(),
                      ],
                    ),
                    _buildTotalPrice(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void _changeAmount(VariantEntity variant, int value) {
    if (value < 1) {
      return;
    }
    setState(() {
      _variant = _variant.copyWith(amount: value);
    });
  }

  Widget _buildInfo() {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mua lẻ',
            style: p5.copyWith(color: blackColor),
          ),
          const SizedBox(height: sp4),
          Text(
            '${FormatCurrency(_variant.unit?.sellPrice.validator)}đ',
            style: p5.copyWith(color: mainColor),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          AppInputSupport(
            controller: amountTec,
            textInputType: TextInputType.number,
            hintText: 'Nhập số lượng',
            textAlign: TextAlign.center,
            onChanged: (value) => _changeAmount.call(
              _variant,
              int.tryParse(value) ?? 0,
            ),
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
                if (_variant.amount == 1) {
                  return;
                }
                _changeAmount.call(
                  _variant,
                  _variant.amount - 1,
                );
                amountTec.text = '${_variant.amount - 1}';
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
                  _variant,
                  _variant.amount + 1,
                );
                amountTec.text = '${_variant.amount + 1}';
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
      ),
    );
  }

  Widget _buildDropdown() {
    return PopupMenuButton(
      child: Row(
        children: [
          Text(
            _variant.unit?.name ?? '',
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
        return List.generate(_variant.units?.length ?? 0, (index) {
          return PopupMenuItem(
            child: Text(
              _variant.units?[index].name ?? '',
              style: StyleApp.normal(
                fontSize: 14,
                color: ColorApp.black,
              ),
            ),
            onTap: () {
              setState(() {
                _variant = _variant.copyWith(
                  unit: _variant.units?[index],
                );
              });
              _keyForm.currentState?.validate();
            },
          );
        });
      },
    ).expanded(flex: 1);
  }

  Widget _buildTotalPrice() {
    return Column(
      children: [
        8.height,
        Row(
          children: [
            const Expanded(child: Divider()),
            8.width,
            Text(
              'Đã chọn: ${_variant.amount}SP - ${FormatCurrency(_getTotalPrice())}đ',
              style: p5.copyWith(color: blackColor),
            ),
            8.width,
            const Expanded(child: Divider()),
          ],
        ),
        TextRow2(
          title: 'Số tiền',
          content: '${FormatCurrency(_getTotalPrice())}đ',
        ),
        16.height,
      ],
    );
  }

  Widget _buildDirectDiscount() {
    return Form(
      key: _keyForm,
      onChanged: () {
        _keyForm.currentState?.validate();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giảm giá trực tiếp',
            style: p5.copyWith(color: blackColor),
          ),
          4.height,
          Text(
            '${FormatCurrency(_variant.discount)}đ',
            style: p5.copyWith(color: mainColor),
          ),
          8.height,
          AppInputSupport(
            hintText: 'Giảm giá trực tiếp',
            textInputType: TextInputType.number,
            initialValue: _variant.discount.toInt().toString().formatCurrency(),
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'vi',
                symbol: '',
              ),
            ],
            onChanged: (value) {
              try {
                _variant = _variant.copyWith(
                  discount: double.parse(
                    value.isEmpty ? '0' : value.removeAllNonNumeric(),
                  ),
                );
                setState(() {});
              } catch (e) {}
            },
            validate: (value) {
              if (int.tryParse(value.removeAllNonNumeric()).validator >
                  (_variant.unit?.sellPrice.validator ?? 0)) {
                return 'Giảm giá không được lớn hơn giá bán';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  num _getTotalPrice() {
    final total = _variant.amount *
        ((_variant.unit?.sellPrice.validator ?? 0) -
            _variant.discount.validator);

    return total > 0 ? total : 0;
  }
}
