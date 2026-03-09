import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../features/customer/data/models/customer_model.dart';
import '../../param/customer_param.dart';
import '../bg_action.dart';

class InforSubCustomer extends StatefulWidget {
  final CustomerModel? customer;
  final Function(AdditionData) onChange;
  const InforSubCustomer({
    super.key,
    required this.onChange,
    this.customer,
  });

  @override
  State<InforSubCustomer> createState() => _InforSubCustomerState();
}

class _InforSubCustomerState extends State<InforSubCustomer> {
  final param = AdditionData();

  final dayCccd = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dayCccd.text = widget.customer?.licenseDate?.fomatDefaulft ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BgAction(
      title: 'Thông tin thêm',
      click: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputColumn(
            label: 'Số CMND/CCCD',
            initialValue: widget.customer?.license,
            textInputType: TextInputType.number,
            onChanged: (p0) {
              param.identifyNumber = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Ngày cấp',
            prefixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: ColorApp.greyAA,
            ),
            controller: dayCccd,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                locale: const Locale('vi'),
              ).then((value) {
                if (value != null) {
                  param.providedDate = value.fomatCustom(fomat: 'yyyy-MM-dd');
                  dayCccd.text = value.fomatDefaulft;
                  widget.onChange(param);
                }
              });
            },
          ),
          InputColumn(
            label: 'Nơi cấp',
            initialValue: widget.customer?.issuedBy,
            onChanged: (p0) {
              param.providedPlace = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Xưng hô',
            initialValue: widget.customer?.title,
            onChanged: (p0) {
              param.prefixName = p0;
              widget.onChange(param);
            },
          ),
          Dimensions.sp16.height,
        ],
      ),
    );
  }
}
