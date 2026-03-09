import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/expandable.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/screens/select_address.dart';
import 'package:pharmago/presentation/shared/utils/validate.dart';

import '../cubit/employee_cubit.dart';
import '../cubit/employee_state.dart';

@RoutePage()
class EmployeeUpdatePage extends StatefulWidget {
  final int? id;
  const EmployeeUpdatePage({super.key, this.id});

  @override
  State<EmployeeUpdatePage> createState() => _EmployeeUpdatePageState();
}

class _EmployeeUpdatePageState extends State<EmployeeUpdatePage> {
  final myBloc = getIt.get<EmployeeCubit>();
  final _keyForm = GlobalKey<FormState>();
  final _shadow = <BoxShadow>[];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg_4,
        appBar: BaseAppBar(
          title:
              widget.id != null ? 'Chỉnh sửa nhân viên' : 'Tạo mới nhân viên',
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            margin: const EdgeInsets.all(sp16),
            child: BlocProvider<EmployeeCubit>(
              create: (context) => myBloc
                ..getDetail(context, widget.id)
                ..getRoles(),
              child: BlocBuilder<EmployeeCubit, EmployeeState>(
                builder: (context, state) {
                  if (widget.id != null && state.employee.id == null) {
                    return Container();
                  }
                  return SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: Form(
                      key: _keyForm,
                      child: Column(
                        children: [
                          Expandable(
                            header: 'Thông tin tài khoản',
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(
                                    sp12,
                                    sp6,
                                    0,
                                    sp6,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(sp12),
                                    ),
                                    color: bg_6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Đang hoạt động', style: p5),
                                          ],
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: state.employee.active,
                                          onChanged: myBloc.changeActive,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'Mã nhân viên',
                                  hintText: 'Nhập mã nhân viên',
                                  initialValue: state.employee.code,
                                  onChanged: myBloc.changeCode,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'Tên nhân viên',
                                  hintText: 'Nhập tên nhân viên',
                                  required: true,
                                  initialValue: state.employee.fullName,
                                  onChanged: myBloc.changeName,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  radius: sp12,
                                  validate: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Vui lòng nhập';
                                    }
                                    return null;
                                  },
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'Tên đăng nhập',
                                  hintText: 'Nhập đăng nhập',
                                  required: true,
                                  initialValue: state.employee.username,
                                  onChanged: myBloc.changePhone,
                                  textInputType: TextInputType.phone,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  radius: sp12,
                                  validate: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Vui lòng nhập';
                                    } else if (!isPhoneNumberValid(value ?? '')) {
                                      return 'Nhập đúng định sđt';
                                    }
                                    return null;
                                  },
                                  suffixIcon: Visibility(
                                    visible: state.isCheckPhone,
                                    child: const Icon(
                                      Icons.warning_rounded,
                                      color: yellow_1,
                                    ),
                                  ),
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'Mật khẩu',
                                  hintText: 'Nhập mật khẩu',
                                  required: true,
                                  initialValue: state.employee.password,
                                  onChanged: myBloc.changePassword,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  radius: sp12,
                                  show: false,
                                  maxLines: 1,
                                  isPassword: true,
                                  validate: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Vui lòng nhập';
                                    }
                                    return null;
                                  },
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'Nhập lại mật khẩu',
                                  hintText: 'Nhập lại mật khẩu',
                                  required: true,
                                  onChanged: myBloc.changePassword,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  radius: sp12,
                                  show: false,
                                  maxLines: 1,
                                  isPassword: true,
                                  validate: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Vui lòng nhập';
                                    } else if (value !=
                                        state.employee.password) {
                                      return 'Mật khẩu nhập lại không chính xác';
                                    }
                                    return null;
                                  },
                                ),
                                gapHeight(sp12),
                                CommonDropdown<int>(
                                  label: 'Vai trò nhân viên',
                                  items: state.roles,
                                  required: true,
                                  hintText: 'Chọn vai trò',
                                  onChanged: myBloc.roleChange,
                                  boxShadow: _shadow,
                                ),
                                gapHeight(sp12),
                              ],
                            ),
                          ),
                          gapHeight(sp20),
                          Expandable(
                            header: 'Thông tin cá nhân',
                            child: Column(
                              children: [
                                AppInputSupport(
                                  label: 'Email',
                                  hintText: 'Nhập email',
                                  initialValue: state.employee.email,
                                  onChanged: myBloc.changeEmail,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  required: true,
                                  radius: sp12,
                                  suffixIcon: Visibility(
                                    visible: state.isCheckEmail,
                                    child: const Icon(
                                      Icons.warning_rounded,
                                      color: yellow_1,
                                    ),
                                  ),
                                  validate: (value) {
                                    if(value == null || value.isEmpty){
                                      return 'Vui lòng nhập';
                                    }
                                    if (value.isNotEmpty && !isEmailValid(value)) {
                                      return 'Email không hợp lệ';
                                    }
                                    return null;
                                  },
                                ),
                                gapHeight(sp12),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Ngày sinh',
                                    style: p5.copyWith(color: blackColor),
                                  ),
                                ),
                                gapHeight(sp8),
                                InkWell(
                                  onTap: () async {
                                    final date = await DialogUtils
                                        .showCalendarDatePicker(
                                      context,
                                    );
                                    myBloc.dateChange(date);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: sp12,
                                      horizontal: sp16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(color: borderColor_2),
                                      borderRadius: BorderRadius.circular(sp8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.employee.dob != null
                                                ? DateFormat('dd/M/y')
                                                    .format(state.employee.dob!)
                                                : 'Chọn ngày sinh',
                                            style: p6.copyWith(
                                              color: state.employee.dob == null
                                                  ? greyColor
                                                  : blackColor,
                                            ),
                                          ),
                                        ),
                                        gapWidth(sp12),
                                        const Icon(
                                          Icons.calendar_month,
                                          size: sp20,
                                          color: greyColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                gapHeight(sp12),
                                CommonDropdown(
                                  label: 'Giới tính',
                                  color: bg_2,
                                  borderColor: bg_2,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'nam',
                                      child: Text('Nam', style: p6),
                                    ),
                                    DropdownMenuItem(
                                      value: 'nữ',
                                      child: Text('Nữ', style: p6),
                                    ),
                                    DropdownMenuItem(
                                      value: 'khác',
                                      child: Text('Khác', style: p6),
                                    ),
                                  ],
                                  hintText: 'Chọn giới tính',
                                  onChanged: (value) {
                                    // return myBloc.changGender(value ?? 1);
                                  },
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'CCCD/CMT',
                                  hintText: 'Nhập số',
                                  initialValue: state.employee.licence,
                                  onChanged: myBloc.licenceChange,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  radius: sp12,
                                ),
                                gapHeight(sp12),
                                AppInputSupport(
                                  label: 'Địa chỉ',
                                  hintText: 'Nhập địa chỉ',
                                  readOnly: true,
                                  backgroundColor: whiteColor,
                                  borderColor: bg_2,
                                  boxShadow: _shadow,
                                  radius: sp12,
                                  controller: TextEditingController(
                                    text: SelectAddressView.formatAddress(
                                      state.employee.address,
                                    ),
                                  ),
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
                                      ),
                                    ),
                                  ),
                                ),
                                gapHeight(sp12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
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
          child: Row(
            children: [
              Expanded(
                child: ExtraButton(
                  title: 'Huỷ bỏ',
                  event: () => context.router.maybePop(),
                  backgroundColor: bg_2,
                  borderColor: borderColor_2,
                ),
              ),
              gapWidth(sp12),
              Expanded(
                child: MainButton(
                  title: widget.id != null ? 'Lưu lại' : 'Tạo mới',
                  event: () =>
                      widget.id != null ? myBloc.update(context) : _create(),
                ),
              ),
            ],
          ),
        ),
      );

  void _create() {
    final validate = _keyForm.currentState!.validate();
    if (!validate) return;
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo vui lòng đợi',
    );
    myBloc.create(context).then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo nhân viên thành công',
          barrierDismissible: true,
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Tạo nhân viên thất bại',
        );
      }
    });
  }
}
