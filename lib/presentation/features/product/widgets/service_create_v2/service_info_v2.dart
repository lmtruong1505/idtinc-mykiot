import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/switch_row.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../cubit/service_create_cubit/service_create_state.dart';
import '../service_create/bts_chose_emp.dart';

class ServiceInfoV2 extends StatefulWidget {
  const ServiceInfoV2({
    super.key,
    required this.formKey,
    required this.myBloc,
  });

  final GlobalKey<FormState> formKey;
  final ServiceCreateCubit myBloc;

  @override
  State<ServiceInfoV2> createState() => _ServiceInfoV2State();
}

class _ServiceInfoV2State extends State<ServiceInfoV2>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.all(sp16),
      margin: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: 8.radius,
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInputSupport(
                    label: 'Tên dịch vụ',
                    required: true,
                    initialValue: state.servicePayload.title,
                    hintText: 'Nhập tên dịch vụ',
                    backgroundColor: whiteColor,
                    borderColor: greyColor,
                    textInputType: TextInputType.text,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng điền tên dịch vụ';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        widget.myBloc.infoFormChange(title: value.trim()),
                  ),
                  gapHeight(sp16),
                  if (!state.isUpdate)
                    AppInputSupport(
                      label: 'Mã dịch vụ',
                      initialValue: state.servicePayload.code,
                      hintText: 'Nhập mã dịch vụ',
                      backgroundColor: whiteColor,
                      borderColor: greyColor,
                      textInputType: TextInputType.text,
                      onChanged: (value) =>
                          widget.myBloc.infoFormChange(code: value),
                    ),
                  const Divider(),
                  AppInputSupport(
                    label: 'Đơn vị',
                    required: true,
                    initialValue: state.servicePayload.unit,
                    hintText: 'Nhập tên đơn vị',
                    backgroundColor: whiteColor,
                    borderColor: greyColor,
                    textInputType: TextInputType.text,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Nhập đơn vị cơ bản';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      widget.myBloc.infoFormChange(unit: value.trim());
                    },
                  ),
                  gapHeight(sp16),
                  AppInputSupport(
                    label: 'Đơn giá',
                    required: true,
                    hintText: 'Nhập giá bán',
                    initialValue: state.servicePayload.price?.toInt().toString().formatCurrency(),
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                        locale: 'vi',
                        symbol: '',
                      ),
                    ],
                    backgroundColor: whiteColor,
                    borderColor: greyColor,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Nhập đơn vị cơ bản';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        widget.myBloc.infoFormChange(price: null);
                        return;
                      }
                      widget.myBloc
                          .infoFormChange(price: double.parse(value.removeAllNonNumeric()));
                    },
                  ),
                  gapHeight(sp16),
                  AppInputSupport(
                    required: false,
                    controller: TextEditingController(
                      text: state.staffSelected?.fullName ?? '',
                    ),
                    hintText: 'Chọn nhân viên',
                    label: 'Người thực hiện',
                    backgroundColor: whiteColor,
                    borderColor: greyColor,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp12),
                          ),
                        ),
                        enableDrag: false,
                        context: context,
                        builder: (context) => BTSChoseEmp(
                          staffSelected: state.staffSelected,
                          onConfirm: (value) {
                            widget.myBloc.selectStaff(value);
                            FocusScope.of(context).unfocus();
                          },
                          onRemove: () {
                            widget.myBloc.selectStaff(null);
                          },
                        ),
                      );
                    },
                  ),
                  gapHeight(sp16),
                  SwitchRow(
                    title: "Đang hoạt động",
                    value: state.servicePayload.active ?? false,
                    onChanged: widget.myBloc.changeIsActive,
                  ),
                  gapHeight(sp16),
                  AppInputSupport(
                    label: 'Mô tả',
                    hintText: 'Nhập mô tả',
                    initialValue: state.servicePayload.description,
                    backgroundColor: whiteColor,
                    borderColor: greyColor,
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      widget.myBloc.infoFormChange(description: value.trim());
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
