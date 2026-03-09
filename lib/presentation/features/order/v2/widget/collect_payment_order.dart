import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/order/domain/entities/payment_v2_entity.dart';
import 'package:pharmago/presentation/features/order/widgets/order_create_payment.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_string.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/button.dart';
import '../../../../base/row_item.dart';
import '../../../../base/select.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../cubit/order_detail_cubit/order_detail_cubit.dart';
import '../../cubit/order_list_cubit/order_list_cubit.dart';

// ignore: must_be_immutable
class CollectPaymentOrder extends StatefulWidget {
  CollectPaymentOrder({
    super.key,
    required this.myBloc,
    this.onPaymentSuccess,
    required this.context,
    required this.amount,
  });

  final OrderDetailCubit myBloc;
  Function? onPaymentSuccess;
  BuildContext context;
  final double amount;

  @override
  State<CollectPaymentOrder> createState() => _CollectPaymentOrderState();
}

class _CollectPaymentOrderState extends State<CollectPaymentOrder> {
  var paymentMethod = PaymentMethod.cash;
  var _amount = 0.0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _amount = widget.amount;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radiusTop,
      ),
      padding: 16.pading.copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
          ),
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState!.validate();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: 16.padingHor,
              child: AppInputSupport(
                hintText: 'Nhập số tiền',
                label: 'Số tiền đã thu',
                textInputType: TextInputType.number,
                initialValue: _amount.formatCurrency,
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'vi',
                    decimalDigits: 0,
                    symbol: '',
                  ),
                ],
                onChanged: (value) {
                  _amount = double.parse(
                    value.isEmpty ? '0' : value.removeAllNonNumeric(),
                  );
                },
                validate: (value) {
                  if(value == null || value.isEmpty){
                    return 'Vui lòng nhập số tiền';
                  }
                  try {
                    final amount = double.parse(value.removeAllDot());
                    if(amount > widget.myBloc.havePaid){
                      return 'Số tiền đã thu không được lớn hơn số tiền cần thu';
                    }
                    if(amount <= 0){
                      return 'Số tiền không hợp lệ';
                    }
                    return null;
                  }
                  catch(e){
                    return 'Số tiền không hợp lệ';
                  }
                },
              ),
            ),
            16.height,
            Padding(
              padding: 16.padingHor,
              child: CommonDropdown(
                value: paymentMethod,
                showIconRemove: false,
                items: List.generate(
                  PaymentMethod.values.length,
                  (index) => DropdownMenuItem(
                    value: PaymentMethod.values[index],
                    child: Text(PaymentMethod.values[index].name),
                  ),
                ),
                hintText: PaymentType.values.isNotEmpty
                    ? PaymentType.values[0].title
                    : '',
                onChanged: (value) {
                  paymentMethod = value as PaymentMethod;
                },
                radius: 8,
              ),
            ),
            16.height,
            Container(
              padding: 16.padingHor.copyWith(bottom: sp16),
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    offset: const Offset(0, -1), //
                  ),
                ],
              ),
              child: Column(
                children: [
                  16.height,
                  RowItem(
                    title: 'Tổng tiền',
                    content: '${widget.myBloc.havePaid.formatCurrency}đ',
                  ),
                  16.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ExtraButton(
                          title: 'Xóa',
                          event: () {},
                          borderColor: borderColor_2,
                          largeButton: true,
                          icon: null,
                        ),
                      ),
                      const SizedBox(width: sp16),
                      Expanded(
                        flex: 1,
                        child: MainButton(
                          title: 'Thu tiền',
                          event: () {
                            _handlePayment(context);
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
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop();
    DialogUtils.showLoadingDialog(widget.context, 'Đang xử lý...');
    widget.myBloc.payOrder(_amount, paymentMethod).then((value) {
      Navigator.of(widget.context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(widget.context,
            content: 'Thanh toán thành công', barrierDismissible: true,);
        
        getIt.get<OrderListCubit>().infiniteListController.onRefresh();
        Navigator.of(widget.context).pop();
        widget.onPaymentSuccess?.call();
      } else {
        DialogUtils.showErrorDialog(context,
            content: 'Thanh toán thất bại, vui lòng thử lại');
      }
    });
  }
}
