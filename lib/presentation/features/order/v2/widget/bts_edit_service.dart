import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/button.dart';
import '../../../../base/text_field.dart';
import '../../../../base/v2/text_row.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../shared/utils/event.dart';

class BtsEditService extends StatefulWidget {
  const BtsEditService({
    super.key,
    required this.service,
    this.onConfirm,
    this.offset,
  });

  final ServiceEntity service;
  final Function(ServiceEntity value)? onConfirm;
  final int? offset;

  @override
  State<BtsEditService> createState() => _BtsEditServiceState();
}

class _BtsEditServiceState extends State<BtsEditService> {
  late TextEditingController amountTec;
  late ServiceEntity _service;
  final _keyForm = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    amountTec = TextEditingController();
    _service = widget.service;
    focusNode.addListener(() {
      if (!focusNode.hasFocus && amountTec.text.isEmpty) {
        setState(() {
          amountTec.text = '1';
          _changeAmount.call(
            _service,
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
    amountTec.text = (_service.amount).toString();
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
                        widget.onConfirm?.call(_service);
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(
              thickness: 2,
              color: borderColor_4,
              indent: widthDevice(context) / 2 - sp32,
              endIndent: widthDevice(context) / 2 - sp32,
            ),
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
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dùng lẻ',
                                style: p5.copyWith(color: blackColor),
                              ),
                              const SizedBox(height: sp4),
                              Text(
                                '${FormatCurrency(_service.price)}đ',
                                style: p5.copyWith(color: mainColor),
                              ),
                            ],
                          ),
                        ),
                        // -------- input quantity --------
                        Expanded(
                          flex: 2,
                          child: Stack(
                            children: [
                              AppInputSupport(
                                controller: amountTec,
                                textInputType: TextInputType.number,
                                hintText: 'Nhập số lượng',
                                validate: (value) {
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                onChanged: (value) => _changeAmount.call(
                                  _service,
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
                                    if (_service.amount == 1) {
                                      return;
                                    }
                                    _changeAmount.call(
                                      _service,
                                      _service.amount - 1,
                                    );
                                    amountTec.text = '${_service.amount - 1}';
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
                                      _service,
                                      _service.amount + 1,
                                    );
                                    amountTec.text = '${_service.amount + 1}';
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
                        ),
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

  void _changeAmount(ServiceEntity variant, int value) {
    if (value < 1) {
      return;
    }
    setState(() {
      _service = _service.copyWith(amount: value);
    });
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
            '${FormatCurrency(_service.directDiscount)}đ',
            style: p5.copyWith(color: mainColor),
          ),
          8.height,
          AppInputSupport(
            hintText: 'Giảm giá trực tiếp',
            textInputType: TextInputType.number,
            initialValue:
                _service.directDiscount?.toInt().toString().formatCurrency(),
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'vi',
                symbol: '',
              ),
            ],
            onChanged: (value) {
              try {
                _service = _service.copyWith(
                  directDiscount: double.parse(
                    value.isEmpty ? '0' : value.removeAllNonNumeric(),
                  ),
                );
                setState(() {});
              } catch (e) {}
            },
            validate: (value) {
              if (int.tryParse(value.removeAllNonNumeric()).validator >
                  (_service.price.validator)) {
                return 'Giảm giá không được lớn hơn giá bán';
              }
              return null;
            },
          ),
        ],
      ),
    );
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
              'Đã chọn: ${_service.amount}SP - ${FormatCurrency(_getTotalPrice())}đ',
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

  num _getTotalPrice() {
    final total = _service.amount *
        (_service.price.validator - _service.directDiscount.validator);
    return total;
  }
}
