import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../features/customer/data/models/customer_model.dart';
import '../../../../../features/address/cubit/location/location_bloc.dart';
import '../../../../components/bottom_sheet/bottom_sheet_location.dart';
import '../../param/customer_param.dart';
import '../bg_action.dart';
import 'box_choose_form_field.dart';

class InforContactCustomer extends StatefulWidget {
  final CustomerModel? customer;
  final Function(RelationData) onChange;
  const InforContactCustomer({
    super.key,
    required this.onChange,
    this.customer,
  });

  @override
  State<InforContactCustomer> createState() => _InforContactCustomerState();
}

class _InforContactCustomerState extends State<InforContactCustomer> {
  final param = RelationData();
  BackAddress? backAddress;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.customer?.address != null) {
      backAddress = BackAddress.mapData(widget.customer?.contactAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgAction(
      title: 'Thông tin người liên hệ',
      click: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputColumn(
            label: 'Họ và tên người liên hệ',
            initialValue: widget.customer?.contactName,
            onChanged: (p0) {
              param.fullname = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Chức danh người liên hệ',
            initialValue: widget.customer?.contactTitle,
            onChanged: (p0) {
              param.prefixName = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Số điện thoại người liên hệ',
            initialValue: widget.customer?.contactPhone,
            textInputType: TextInputType.phone,
            onChanged: (p0) {
              param.phoneNumber = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Email người liên hệ',
            initialValue: widget.customer?.contactEmail,
            textInputType: TextInputType.emailAddress,
            onChanged: (p0) {
              param.email = p0;
              widget.onChange(param);
            },
          ),
          BoxChooseFormField(
            icon: Icons.location_on,
            label: 'Địa chỉ người liên hệ',
            value: backAddress?.addressDetail,
            onTap: () {
              context
                  .bottomSheet(
                BottomSheetLocationPage(
                  value: backAddress,
                ),
              )
                  .then((value) {
                if (value is BackAddress) {
                  backAddress = value;

                  final address = Address();

                  address.address = value;

                  param.address = address;
                  widget.onChange(param);
                  setState(() {});
                }
              });
            },
          ),
          Dimensions.sp16.height,
        ],
      ),
    );
  }
}
