import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../base/button.dart';
import '../../../../../base/row_item.dart';
import '../../../../../base/text_field.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/size_device.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../constants/typography.dart';
import '../../../../../shared/utils/event.dart';
import '../../../../blocs/order/order_detail_v2_bloc.dart';

class BtsCreatePayment extends StatefulWidget {
  const BtsCreatePayment({
    super.key,
    required this.totalMoney,
    this.onConfirm,
  });

  final num totalMoney;
  final Function(num value, PaymentMethod type)? onConfirm;

  @override
  State<BtsCreatePayment> createState() => _BtsCreatePaymentState();
}

class _BtsCreatePaymentState extends State<BtsCreatePayment> {
  late TextEditingController ctl;
  PaymentMethod paymentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();

    ctl = TextEditingController(
      text: FormatCurrency(widget.totalMoney),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthDevice(context),
      height: heightDevice(context) / 2,
      padding: const EdgeInsets.all(sp16).copyWith(top: sp8),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: sp40,
                    height: sp4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      color: greyFF3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => context.router.maybePop(),
                      child: const CircleAvatar(
                        radius: sp20,
                        backgroundColor: greyFF3,
                        child: Icon(
                          Icons.close_rounded,
                          color: blackColor,
                          size: sp16,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Thu tiền đơn hàng',
                    style: p1.copyWith(color: greyTextColor),
                  ),
                  gapHeight(sp16),
                  Container(
                    padding: const EdgeInsets.all(sp12),
                    decoration: BoxDecoration(
                      color: greyFF3,
                      borderRadius: BorderRadius.circular(sp12),
                    ),
                    child: RowItem(
                      title: 'Còn lại phải thu',
                      titleStyle: p5.copyWith(color: greyTextColor),
                      content: '${FormatCurrency(widget.totalMoney)} đ',
                      contetnStyle: h4.copyWith(color: mainColor),
                    ),
                  ),
                  gapHeight(sp16),
                  SizedBox(
                    width: widthDevice(context),
                    child: InputCurrency(
                      label: 'Số tiền đã thu',
                      hintText: 'Nhập số tiền đã thu',
                      required: true,
                      controller: ctl,
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                            locale: 'vi', symbol: ''),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  gapHeight(sp16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phương thức thanh toán',
                      style: p5.copyWith(color: greyTextColor),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.all(sp0),
                          value: PaymentMethod.cash,
                          groupValue: paymentMethod,
                          title: Text(
                            PaymentMethod.cash.title,
                            style: p5,
                          ),
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value ?? PaymentMethod.cash;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.all(sp0),
                          value: PaymentMethod.banking,
                          groupValue: paymentMethod,
                          title: Text(
                            PaymentMethod.banking.title,
                            style: p5,
                          ),
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value ?? PaymentMethod.cash;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: sp24),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ExtraButton(
                  backgroundColor: bg_4,
                  title: 'Huỷ bỏ',
                  borderRadius: sp24,
                  event: () => context.router.maybePop(),
                ),
              ),
              gapWidth(sp16),
              Expanded(
                child: MainButton(
                  title: 'Xác nhận',
                  radius: sp24,
                  event: () async {
                    widget.onConfirm?.call(
                      num.parse(ctl.text.replaceAll('.', '')),
                      paymentMethod,
                    );
                    context.router.maybePop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
