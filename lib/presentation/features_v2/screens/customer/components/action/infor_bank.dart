import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../features/customer/data/models/customer_model.dart';
import '../../param/customer_param.dart';
import '../bg_action.dart';

class InforBankCustomer extends StatefulWidget {
  final Function(BankData) onChange;
  final CustomerModel? customer;
  InforBankCustomer({
    Key? key,
    required this.onChange,
    this.customer,
  }) : super(key: key);

  @override
  State<InforBankCustomer> createState() => _InforBankCustomerState();
}

class _InforBankCustomerState extends State<InforBankCustomer> {
  final param = BankData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgAction(
      title: 'Thông tin tài khoản ngân hàng',
      click: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputColumn(
            label: 'Số tài khoản',
            initialValue: widget.customer?.accountNumber,
            onChanged: (p0) {
              param.bankNumber = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Tên ngân hàng',
            initialValue: widget.customer?.bankName,
            onChanged: (p0) {
              param.bankName = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Cơ sở',
            initialValue: widget.customer?.bankBranch,
            onChanged: (p0) {
              param.bankBranch = p0;
              widget.onChange(param);
            },
          ),
          Dimensions.sp16.height,
        ],
      ),
    );
  }
}
