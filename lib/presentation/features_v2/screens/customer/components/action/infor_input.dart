import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../../shared/style_app/init_style.dart';
import '../../../../blocs/customer/customer_gender_bloc.dart';
import '../../../../../features/address/cubit/location/location_bloc.dart';
import '../../../../blocs/state/init_state.dart';
import '../../../../components/bottom_sheet/bottom_sheet_location.dart';
import '../../param/customer_param.dart';
import '../bg_action.dart';
import 'box_choose_form_field.dart';

class InforInput extends StatefulWidget {
  final CustomerModel? customer;
  final Function(CustomerData) onChange;
  const InforInput({
    super.key,
    required this.onChange,
    this.customer,
  });

  @override
  State<InforInput> createState() => _InforInputState();
}

class _InforInputState extends State<InforInput> {
  final param = CustomerData();
  final birthday = TextEditingController();
  final genderBloc = CustomerGenderBloc();

  BackAddress? backAddress;

  @override
  void initState() {
    super.initState();
    genderBloc.getList();
    if (widget.customer != null) {
      birthday.text = widget.customer?.birthday?.fomatDefaulft ?? '';
      genderBloc.setValueById(widget.customer?.gender);

      if (widget.customer?.address != null) {
        backAddress = BackAddress.mapData(widget.customer?.address);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgAction(
      title: 'Thông tin khách hàng',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputColumn(
            label: 'Mã khách hàng',
            initialValue: widget.customer?.code,
            onChanged: (p0) {
              param.customerCode = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Tên khách hàng',
            initialValue: widget.customer?.fullName,
            isRequired: true,
            onChanged: (p0) {
              param.customerName = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Số điện thoại',
            initialValue: widget.customer?.phone,
            isRequired: true,
            textInputType: TextInputType.phone,
            onChanged: (p0) {
              param.customerPhone = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Email',
            textInputType: TextInputType.emailAddress,
            initialValue: widget.customer?.email,
            onChanged: (p0) {
              param.email = p0;
              widget.onChange(param);
            },
          ),
          InputColumn(
            label: 'Ngày sinh',
            controller: birthday,
            prefixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: ColorApp.greyAA,
            ),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                locale: const Locale('vi'),
              ).then((value) {
                if (value != null) {
                  param.dateOfBirth = value.fomatCustom(fomat: 'yyyy-MM-dd');
                  birthday.text = value.fomatDefaulft;
                  widget.onChange(param);
                }
              });
            },
          ),
          BlocBuilder<CustomerGenderBloc, CubitState>(
            bloc: genderBloc,
            builder: (context, state) {
              return DropDownColumn<GenderEnum>(
                label: 'Giới tính',
                value: genderBloc.value,
                items: List.generate(
                  genderBloc.list.length,
                  (index) => DropdownMenuItem(
                    value: genderBloc.list[index],
                    child: Text(
                      genderBloc.list[index].name,
                      style: StyleApp.normal(),
                    ),
                  ),
                ),
                onChanged: (p0) {
                  param.gender = p0?.code;
                  genderBloc.setValue(p0);
                  widget.onChange(param);
                },
              );
            },
          ),
          BoxChooseFormField(
            icon: Icons.location_on,
            label: 'Địa chỉ',
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
