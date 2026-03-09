import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_cubit.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../../constants/typography.dart';
import '../cubit/order_create_cubit/order_create_state.dart';

enum PaymentType {
  cash(
    code: 'CASH',
    title: 'Tiền mặt',
    image: '/payment_type/ic_banking.svg',
  ),
  banking(
    code: 'BANKING',
    title: 'Chuyển khoản',
    image: '/payment_type/ic_cash.svg',
  ),
  debit(
    code: 'DEBIT',
    title: 'Ghi nợ',
    image: '/payment_type/ic_debit.svg',
  );

  final String code;
  final String title;
  final String image;
  const PaymentType({
    required this.code,
    required this.image,
    required this.title,
  });
}

class OrderCreatePayment extends StatelessWidget {
  const OrderCreatePayment({
    super.key,
    required this.myBloc,
  });

  final OrderCreateCubit myBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      bloc: myBloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Có thể chọn nhiều phương thức',
                  style: h6.copyWith(color: blackColor),
                ),
                gapHeight(sp16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: sp16,
                    crossAxisSpacing: sp16,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final type = state.paymentType[index];
                    return InkWell(
                      onTap: () => myBloc.selectPaymentType(type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: sp16,
                          horizontal: sp8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(sp12),
                          border: Border.all(
                            color: state.paymentTypeSelected.contains(type)
                                ? mainColor
                                : borderColor_2,
                          ),
                          color: whiteColor,
                        ),
                        child: Column(
                          children: [
                            IcSvg.asset(type.image, width: sp20, height: sp20),
                            gapHeight(sp8),
                            Text(
                              type.title,
                              style: p7.copyWith(
                                color: state.paymentTypeSelected.contains(type)
                                    ? mainColor
                                    : blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: state.paymentType.length,
                ),
                gapHeight(sp24),
                Container(
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số tiền khách phải trả',
                        style: h6.copyWith(color: blackColor),
                      ),
                      gapHeight(sp24),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: state.paymentItems.map((e) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: sp16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppInput(
                                    label: e.title,
                                    hintText: 'Nhập số tiền',
                                    backgroundColor: bg_5,
                                    borderColor: bg_5,
                                    textInputType: TextInputType.number,
                                    suffixIcon: Visibility(
                                      visible: e.type != PaymentType.debit.code,
                                      child: InkWell(
                                        onTap: () =>
                                            myBloc.paymentItemFormChange(
                                          e,
                                          isPaid: true,
                                        ),
                                        child: SizedBox(
                                          height: 52,
                                          width: 100,
                                          child: Center(
                                            child: !e.isPaid
                                                ? Text(
                                                    'Thanh toán',
                                                    style: p7.copyWith(
                                                      color: blue_1,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    color: green_1,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        myBloc.paymentItemFormChange(
                                      e,
                                      value: double.tryParse(value),
                                    ),
                                  ),
                                ),
                                gapWidth(sp12),
                                IconButton(
                                  onPressed: () => myBloc.selectPaymentType(
                                    state.paymentType
                                        .firstWhere((i) => i.code == e.type),
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: red_1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      AppInput(
                        controller: TextEditingController(
                          text:
                              '${FormatCurrency(state.orderPayment.mustPaid)} VNĐ',
                        ),
                        label: 'khách phải trả',
                        hintText: '0 VNĐ',
                        backgroundColor: bg_4,
                        borderColor: bg_4,
                        readOnly: true,
                      ),
                      gapHeight(sp12),
                      AppInput(
                        controller: TextEditingController(
                          text:
                              '${FormatCurrency(state.orderPayment.hadPaid)} VNĐ',
                        ),
                        label: 'Tổng khách đưa',
                        hintText: '0 VNĐ',
                        backgroundColor: bg_4,
                        borderColor: bg_4,
                        readOnly: true,
                      ),
                      gapHeight(sp12),
                      AppInput(
                        controller: TextEditingController(
                          text:
                              '${FormatCurrency(state.orderPayment.needPay)} VNĐ',
                        ),
                        label: 'Còn lại cần thanh toán',
                        hintText: '0 VNĐ',
                        backgroundColor: bg_4,
                        borderColor: bg_4,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
