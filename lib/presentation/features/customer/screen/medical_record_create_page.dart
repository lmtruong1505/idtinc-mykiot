import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/widget/bts_chose_customer.dart';

import '../../../base/button.dart';
import '../../../base/dialog.dart';
import '../../../constants/colors.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../product/widgets/service_create/bts_chose_emp.dart';
import '../cubit/medical_record_create_cubit/medical_record_create_cubit.dart';
import '../cubit/medical_record_create_cubit/medical_record_create_state.dart';

@RoutePage()
class MedicalRecordCreatePage extends StatefulWidget {
  const MedicalRecordCreatePage({
    super.key,
    this.customer,
  });

  final int? customer;

  @override
  State<MedicalRecordCreatePage> createState() =>
      _MedicalRecordCreatePageState();
}

class _MedicalRecordCreatePageState extends State<MedicalRecordCreatePage> {
  final myBloc = getIt.get<MedicalRecordCreateCubit>();

  // final myCustomerCubit = getIt.get<CustomerCubit>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc
        ..infoFormChange(customer: widget.customer)
        ..getDetail(context, widget.customer),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: const BaseAppBar(title: 'Tạo phiếu khám bệnh'),
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp16,
          ),
          width: widthDevice(context),
          height: heightDevice(context),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin khách hàng',
                    style: p5.copyWith(color: blackColor),
                  ),
                  gapHeight(sp16),
                  BlocBuilder<MedicalRecordCreateCubit,
                      MedicalRecordCreateState>(
                    builder: (context, state) {
                      return AppInput(
                        required: true,
                        controller: TextEditingController(
                          text: state.customerSelected?.name ?? '',
                        ),
                        hintText: 'Chọn khách hàng',
                        label: 'Khách hàng',
                        backgroundColor: bg_4,
                        borderColor: bg_4,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        validate: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Vui lòng chọn khách hàng';
                          }
                        },
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
                            builder: (context) => BTSChoseCustomer(
                              customerSelected: state.customerSelected,
                              onConfirm: (value) {
                                myBloc.selectCustomer(value!);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  gapHeight(sp16),
                  Text(
                    'Thông tin nhân viên',
                    style: p5.copyWith(color: blackColor),
                  ),
                  gapHeight(sp12),
                  BlocBuilder<MedicalRecordCreateCubit,
                      MedicalRecordCreateState>(
                    builder: (context, state) {
                      return AppInput(
                        required: true,
                        controller: TextEditingController(
                          text: state.doctorSelected?.fullName ?? '',
                        ),
                        hintText: 'Chọn nhân viên',
                        label: 'Nhân viên phòng khám',
                        backgroundColor: bg_4,
                        borderColor: bg_4,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        validate: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Vui lòng chọn nhân viên';
                          }
                        },
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
                              staffSelected: state.doctorSelected,
                              onConfirm: (value) {
                                myBloc.selectDoctor(value);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  gapHeight(sp24),
                  Text(
                    'Thông tin bệnh nhân',
                    style: p5.copyWith(color: blackColor),
                  ),
                  gapHeight(sp12),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          label: 'Cân nặng',
                          hintText: '0.0',
                          // prefixIcon: const Icon(
                          //   Icons.monitor_weight_rounded,
                          //   size: sp16,
                          // ),
                          suffixIcon: SizedBox(
                            width: sp24,
                            child: Center(
                              child: Text(
                                'kg',
                                style: p8.copyWith(color: greyTextColor),
                              ),
                            ),
                          ),
                          textInputType: TextInputType.number,
                          backgroundColor: bg_4,
                          borderColor: bg_4,
                          onChanged: (value) => myBloc.infoFormChange(
                              weight: double.parse(value),),
                        ),
                      ),
                      gapWidth(sp16),
                      Expanded(
                        child: AppInput(
                          label: 'Chiều cao',
                          hintText: '0.0',
                          // prefixIcon: const Icon(
                          //   Icons.ruler,
                          //   size: sp16,
                          // ),
                          suffixIcon: SizedBox(
                            width: sp24,
                            child: Center(
                              child: Text(
                                'cm',
                                style: p8.copyWith(color: greyTextColor),
                              ),
                            ),
                          ),
                          textInputType: TextInputType.number,
                          backgroundColor: bg_4,
                          borderColor: bg_4,
                          onChanged: (value) =>
                              myBloc.infoFormChange(long: double.parse(value)),
                        ),
                      ),
                    ],
                  ),
                  gapHeight(sp16),
                  AppInput(
                    label: 'Triệu chứng bệnh',
                    hintText: 'Nhập ...',
                    backgroundColor: bg_4,
                    borderColor: bg_4,
                    maxLines: 3,
                    required: true,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng điền triệu chứng bệnh';
                      }
                    },
                    onChanged: (value) => myBloc.infoFormChange(symptom: value),
                  ),
                  gapHeight(sp16),
                  AppInput(
                    label: 'Chuẩn đoán',
                    hintText: 'Nhập ...',
                    backgroundColor: bg_4,
                    borderColor: bg_4,
                    maxLines: 3,
                    required: true,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng điền chuẩn đoán';
                      }
                    },
                    onChanged: (value) =>
                        myBloc.infoFormChange(diagnostic: value),
                  ),
                  gapHeight(sp16),
                  AppInput(
                    label: 'Kết luận',
                    hintText: 'Nhập ...',
                    backgroundColor: bg_4,
                    borderColor: bg_4,
                    maxLines: 3,
                    required: true,
                    validate: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng điền kết luận';
                      }
                    },
                    onChanged: (value) => myBloc.infoFormChange(result: value),
                  ),
                  gapHeight(sp16),
                  AppInput(
                    label: 'Ghi chú',
                    hintText: 'Nhập ...',
                    backgroundColor: bg_4,
                    borderColor: bg_4,
                    maxLines: 3,
                    onChanged: (value) => myBloc.infoFormChange(note: value),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(0, -1),
                blurRadius: sp4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(sp16),
          width: double.infinity,
          child: MainButton(
            title: 'Xác nhận',
            event: _createMedicalRecordHandle,
          ),
        ),
      ),
    );
  }

  void _createMedicalRecordHandle() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang tạo phiếu khám bệnh...');
    myBloc.createMedicalRecord().then((value) {
      Navigator.pop(context);
      if(value?.code == 200){
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo phiếu khám bệnh thành công',
          barrierDismissible: true,
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo sản phẩm thất bại \n ${value?.message}',
      );
    });
  }
}
