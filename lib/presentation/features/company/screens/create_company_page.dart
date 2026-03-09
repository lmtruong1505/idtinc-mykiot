import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/color_app.dart';
import '../../address/screens/select_address.dart';
import '../cubit/create_company_cubit/create_company_cubit.dart';
import '../cubit/create_company_cubit/create_company_state.dart';

@RoutePage()
class CreateCompanyPage extends StatefulWidget {
  const CreateCompanyPage({
    super.key,
    this.onSuccess,
  });

  final VoidCallback? onSuccess;

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  final myBloc = getIt.get<CreateCompanyCubit>();
  final _key = GlobalKey<FormState>();

  late TextEditingController _openTime;
  late TextEditingController _closeTime;
  late TextEditingController _accNumber;
  // BackAddress? _addressModel;

  @override
  void initState() {
    super.initState();
    _openTime = TextEditingController();
    _closeTime = TextEditingController();
    _accNumber = TextEditingController();
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showDialogType();
    // });
  }

  @override
  void dispose() {
    _openTime.dispose();
    _closeTime.dispose();
    _accNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateCompanyCubit>(
      create: (context) => myBloc..init(),
      lazy: false,
      child: BlocBuilder<CreateCompanyCubit, CreateCompanyState>(
        builder: (context, state) {
          if (state.nameAccount != null) {
            _accNumber.text = state.nameAccount ?? '';
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: whiteColor,
              appBar: const BaseAppBar(title: 'Thông tin chung'),
          
              body: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                ).copyWith(bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: 16.radius,
                  color: whiteColor,
                ),
                width: widthDevice(context),
                height: heightDevice(context),
                margin: 16.pading,
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Thông tin ${state.type?.title ?? ''}',
                        //       style: p3.copyWith(color: blackColor),
                        //     ),
                        //     Visibility(
                        //       visible: state.type != null,
                        //       child: InkWell(
                        //         onTap: _showDialogType,
                        //         child: const Icon(
                        //           Icons.change_circle_rounded,
                        //           color: greyTextColor,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        CommonDropdown(
                          items: List.generate(
                            state.companyTypes.length,
                            (index) => DropdownMenuItem(
                              value: state.companyTypes[index],
                              child: Text(
                                state.companyTypes[index].name ?? '',
                              ),
                            ),
                          ),
                          onChanged: (value) => myBloc.formChange(type: value),
                          required: true,
                          label: 'Loại hình',
                          hintText: 'Chọn loại hình',
                          color: whiteColor,
                        ),
                        gapHeight(16),
                        AppInputSupport(
                          label: 'Tên Workspace',
                          required: true,
                          hintText: 'Nhập tên Workspace',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          onChanged: (value) => myBloc.formChange(name: value),
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Nhập tên ${state.type?.name ?? ''}';
                            }
                            return null;
                          },
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          controller: TextEditingController(
                            text: SelectAddressView.formatAddress(
                              state.addressEntity,
                            ),
                          ),
                          label: 'Vị trí',
                          required: true,
                          hintText: 'Chọn vị trí',
                          backgroundColor: ColorApp.white,
                          borderColor: borderColor_2,
                          readOnly: true,
                          suffixIcon: const Icon(
                            Icons.location_on_outlined,
                            size: sp20,
                            color: greyColor,
                          ),
                          maxLines: 1,
                          // onTap: () {
                          //   context
                          //       .pushRoute(AddressRoute(model: _addressModel))
                          //       .then(
                          //     (value) {
                          //       if (value is BackAddress) {
                          //         _addressModel = value;
                          //       }
                          //     },
                          //   );
                          // },
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sp16),
                              ),
                            ),
                            builder: (context) => SizedBox(
                              height: 0.9 * heightDevice(context),
                              child: SelectAddressView(
                                onConfirm: myBloc.updateAddress,
                                province: state.addressEntity?.province,
                                district: state.addressEntity?.district,
                                ward: state.addressEntity?.ward,
                                detail: state.addressEntity?.detail,
                              ),
                            ),
                          ),
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Chọn vị trí ${state.type?.name ?? ''}';
                            }
                            return null;
                          },
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          label: 'Số điện thoại',
                          required: true,
                          initialValue: getPhone,
                          hintText: 'Điền số điện thoại',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          textInputType: TextInputType.phone,
                          onChanged: (value) => myBloc.formChange(phone: value),
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Nhập số điện thoại';
                            }
                            return null;
                          },
                        ),
                        gapHeight(sp16),
                        Row(
                          children: [
                            Expanded(
                              child: AppInputSupport(
                                label: 'Mở cửa',
                                hintText: '00:00',
                                controller: _openTime,
                                backgroundColor: whiteColor,
                                borderColor: borderColor_2,
                                suffixIcon: const Icon(
                                  Icons.access_time_rounded,
                                  size: sp20,
                                  color: greyColor,
                                ),
                                readOnly: true,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime:
                                        state.timeOpen ?? TimeOfDay.now(),
                                  ).then(
                                    (value) {
                                      if (value != null) {
                                        _openTime.text = value.format(context);
                                        myBloc.changeTime(
                                          open: value,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            gapWidth(sp16),
                            Expanded(
                              child: AppInputSupport(
                                label: 'Đóng cửa',
                                hintText: '00:00',
                                controller: _closeTime,
                                backgroundColor: whiteColor,
                                borderColor: borderColor_2,
                                suffixIcon: const Icon(
                                  Icons.access_time_rounded,
                                  size: sp20,
                                  color: greyColor,
                                ),
                                readOnly: true,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime:
                                        state.timeClose ?? TimeOfDay.now(),
                                  ).then(
                                    (value) {
                                      if (value != null) {
                                        _closeTime.text = value.format(context);
                                        myBloc.changeTime(
                                          close: value,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          label: 'Mã số thuế',
                          hintText: 'Điền mã số thuế',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          textInputType: TextInputType.number,
                          onChanged: (value) => myBloc.formChange(phone: value),
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          label: 'Ghi chú',
                          hintText: 'Thêm mô tả',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          onChanged: (value) => myBloc.formChange(phone: value),
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          label: 'Mã Khách hàng từ KAFA',
                          hintText: 'Thêm mô tả',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          onChanged: (value) => myBloc.formChange(kafa: value),
                        ),
                        gapHeight(sp16),
                        CommonDropdown(
                          label: 'Ngân hàng',
                          items: List.generate(state.banks.length, (index) {
                            return DropdownMenuItem(
                              value: state.banks[index],
                              child:
                                  Text(state.banks[index].shortName.validator),
                            );
                          }),
                          hintText: 'Chọn ngân hàng',
                          color: whiteColor,
                          onChanged: (value) {
                            if (value == null) return;
                            myBloc.changeBank(value);
                          },
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          label: 'Số tài khoản',
                          hintText: 'Điền số tài khoản',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          suffixIcon: Icon(
                            Icons.check_circle,
                            color: state.nameAccount != null
                                ? ColorApp.main
                                : ColorApp.greyA7,
                            size: 20,
                          ),
                          onChanged: (value) => myBloc.changeAccNumber(value),
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          controller: _accNumber,
                          label: 'Tên chủ tài khoản',
                          hintText: 'Điền tên chủ tài khoản',
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(sp16),
                color: whiteColor,
                width: double.infinity,
                child: MainButton(
                  title: 'Tạo cửa hàng',
                  event: _createCompany,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _createCompany() {
    final validate = _key.currentState!.validate();
    if (!validate) return;
    DialogUtils.showLoadingDialog(context, 'Đang tạo WorkSpace vui lòng đợi!');
    myBloc.createCompany().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo WorkSpace thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Truy cập',
          close: () {
            widget.onSuccess?.call();
            context.router.popUntil(
              (route) => route.settings.name == 'WorkSpaceRoute',
            );
          },
          accept: () {
            widget.onSuccess?.call();
            context.router.popUntil(
              (route) => route.settings.name == 'WorkSpaceRoute',
            );
          },
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo WorkSapce thất bại',
      );
    });
  }

  // void _showDialogType() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return DialogSelectTypeCompany(
  //         onSelect: (value) => myBloc.formChange(type: value),
  //       );
  //     },
  //   ).then((value) {
  //     if (myBloc.state.type == null) {
  //       Navigator.of(context).pop();
  //     }
  //   });
  // }
}
