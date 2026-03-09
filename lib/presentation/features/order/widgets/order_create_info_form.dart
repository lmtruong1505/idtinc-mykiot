import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/order/widgets/bts_select_customer.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../../constants/typography.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';

@injectable
class OrderCreateInfoForm extends StatefulWidget {
  const OrderCreateInfoForm({
    super.key,
    required this.myBloc,
  });

  final OrderCreateCubit myBloc;

  @override
  State<OrderCreateInfoForm> createState() => _OrderCreateInfoFormState();
}

class _OrderCreateInfoFormState extends State<OrderCreateInfoForm> {
  final _discountKey = GlobalKey<FormState>();
  final _vatKey = GlobalKey<FormState>();

  late TextEditingController _discountTec;

  @override
  void initState() {
    super.initState();

    _discountTec = TextEditingController(
      text: '${widget.myBloc.state.orderInfo.servicePrice?.round() ?? ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp16,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(sp16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp12),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.2),
                  blurRadius: sp4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin đơn hàng',
                    style: h6.copyWith(color: blackColor),
                  ),
                  gapHeight(sp24),
                  AppInput(
                    controller: TextEditingController(
                      text: state.customerSelected?.name ?? '',
                    ),
                    label: 'khách hàng',
                    hintText: 'Chọn khách hàng',
                    backgroundColor: bg_5,
                    borderColor: bg_5,
                    textInputType: TextInputType.text,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    readOnly: true,
                    onTap: () => showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(sp12),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BtsSelectCustomer(
                        initValue: state.customerSelected,
                        onConfirm: (value) {
                          widget.myBloc.selectCustomer(value);
                          FocusScope.of(context).unfocus();
                        },
                        hasRetailCustomer: true,
                      ),
                    ),
                  ),
                  gapHeight(sp12),
                  AppInput(
                    controller: state.customerSelected != null
                        ? TextEditingController(
                            text: state.customerSelected?.phone ??
                                state.orderInfo.customerPhone,
                          )
                        : null,
                    label: 'Số điện thoại',
                    hintText: 'Tự động điền khi chọn khách hàng',
                    backgroundColor:
                        state.customerSelected != null ? bg_4 : bg_5,
                    borderColor: state.customerSelected != null ? bg_4 : bg_5,
                    textInputType: TextInputType.phone,
                    readOnly: state.customerSelected != null ? true : false,
                    onChanged: (value) => widget.myBloc.orderInfoChange(
                      phone: value,
                    ),
                  ),
                  gapHeight(sp12),
                  Form(
                    key: _vatKey,
                    child: AppInput(
                      initialValue: '${state.orderInfo.vat?.round() ?? ''}',
                      label: 'Thuế tổng đơn',
                      hintText: 'Nhập thuế tổng đơn',
                      backgroundColor: bg_5,
                      borderColor: bg_5,
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        _vatKey.currentState?.validate();
                        widget.myBloc.orderInfoChange(
                          vat: double.tryParse(value) ?? 0,
                        );
                      },
                      suffixIcon: const Icon(Icons.percent),
                      validate: (value) {
                        if ((double.tryParse(value ?? '') ?? 0) > 100) {
                          return 'Giá trị thuế không hợp lệ';
                        }
                      },
                    ),
                  ),
                  gapHeight(sp12),
                  Form(
                    key: _discountKey,
                    child: AppInput(
                      initialValue: state.orderInfo.discount ?? '',
                      label: 'Chiết khấu',
                      hintText: 'Nhập chiết khấu (VD: 12%, 100.000)',
                      backgroundColor: bg_5,
                      borderColor: bg_5,
                      textInputType: TextInputType.text,
                      onChanged: (value) {
                        final validate = _discountKey.currentState?.validate();
                        if (validate ?? true) {
                          widget.myBloc.orderInfoChange(
                            discount: value,
                          );
                        } else {
                          return;
                        }
                      },
                      validate: (value) {
                        if (value?.isNotEmpty ?? false) {
                          if (!_isValidInput(value)) {
                            return 'Giá trị không hợp lệ';
                          }
                        }
                      },
                    ),
                  ),
                  gapHeight(sp12),
                  InputCurrency(
                    controller: _discountTec,
                    label: 'Phí dịch vụ',
                    hintText: 'Nhập phí dịch vụ',
                    backgroundColor: bg_5,
                    borderColor: bg_5,
                    onChanged: (value) {
                      widget.myBloc.orderInfoChange(
                        servicePrice: double.tryParse(value) ?? 0,
                      );
                    },
                  ),
                  gapHeight(sp12),
                  AppInput(
                    controller: TextEditingController(
                      text: FormatCurrency(state.orderInfo.totalPrice),
                    ),
                    label: 'Tổng tiền',
                    hintText: '0',
                    backgroundColor: bg_4,
                    borderColor: bg_4,
                    readOnly: true,
                    suffixIcon: SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          'VNĐ',
                          style: p5.copyWith(color: greyColor),
                        ),
                      ),
                    ),
                  ),
                  gapHeight(sp12),
                  AppInput(
                    controller: TextEditingController(
                      text: FormatCurrency(state.orderInfo.mustPaid),
                    ),
                    label: 'Khách phải trả',
                    hintText: '0 VNĐ',
                    backgroundColor: bg_4,
                    borderColor: bg_4,
                    readOnly: true,
                    suffixIcon: SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          'VNĐ',
                          style: p5.copyWith(color: greyColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isValidInput(String? input) {
    // Biểu thức chính quy để kiểm tra chuỗi chỉ chứa số hoặc số với dấu %
    final RegExp regex = RegExp(r'^(\d+|\d+\s?%)$');

    // Sử dụng hàm test để kiểm tra xem chuỗi có khớp với biểu thức chính quy không
    return regex.hasMatch(input ?? '');
  }
}
