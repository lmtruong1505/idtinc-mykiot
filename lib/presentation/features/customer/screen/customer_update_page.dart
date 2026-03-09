import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/screens/select_address.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_cubit.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_state.dart';

import '../../../shared/utils/event.dart';

@RoutePage()
class CustomerUpdatePage extends StatefulWidget {
  final int? id;

  const CustomerUpdatePage({super.key, this.id});

  @override
  State<CustomerUpdatePage> createState() => _CustomerUpdatePageState();
}

class _CustomerUpdatePageState extends State<CustomerUpdatePage> {
  final myBloc = getIt.get<CustomerCubit>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_5,
          appBar: BaseAppBar(
            title: widget.id != null
                ? 'Chỉnh sửa khách hàng'
                : 'Tạo mới khách hàng',
          ),
          body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            padding: const EdgeInsets.all(sp24),
            child: BlocProvider<CustomerCubit>(
              create: (context) => myBloc..getDetail(context, widget.id),
              child: BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  if (widget.id != null && state.customer.id == null) {
                    return Container();
                  }
                  return SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _inforView(state),
                        gapHeight(sp16),
                        _contactInforView(state),
                        gapHeight(sp16),
                        _bankInforView(state),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
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
                    backgroundColor: whiteColor,
                    borderColor: borderColor_2,
                  ),
                ),
                gapWidth(sp12),
                Expanded(
                  child: MainButton(
                    title: widget.id != null ? 'Lưu lại' : 'Tạo mới',
                    event: () => widget.id != null
                        ? _handleUpdate(context)
                        : _handleCreate(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _inforView(CustomerState state) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin khách hàng',
              style: p8.copyWith(color: greyTextColor),
            ),
            const Divider(
              height: sp16,
              color: borderColor_2,
            ),
            gapHeight(sp12),
            AppInputSupport(
              label: 'Mã khách hàng',
              hintText: 'Nhập mã khách hàng',
              initialValue: state.customer.code,
              onChanged: myBloc.changeCode,
              borderColor: borderColor_2,
            ),
            gapHeight(sp12),
            AppInputSupport(
              label: 'Tên khách hàng',
              hintText: 'Nhập tên khách hàng',
              required: true,
              initialValue: state.customer.name,
              onChanged: myBloc.changeName,
              borderColor: borderColor_2,
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Tên khách hàng không được để trống';
                }
                return null;
              },
            ),
            gapHeight(sp12),
            AppInputSupport(
              label: 'Số điện thoại',
              hintText: 'Nhập số điện thoại',
              required: true,
              initialValue: state.customer.phone,
              textInputType: TextInputType.phone,
              onChanged: myBloc.changePhone,
              borderColor: borderColor_2,
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Số điện thoại không được để trống';
                }
                if (!isPhoneNumberValid(value ?? '') || value?.length != 10) {
                  return 'Số điện thoại không hợp lệ';
                }
                return null;
              },
            ),
            gapHeight(sp12),
            AppInputSupport(
              label: 'Email',
              hintText: 'Nhập email',
              initialValue: state.customer.email,
              onChanged: myBloc.changeEmail,
              borderColor: borderColor_2,
              validate: (value) {
                if (value == null) {
                  return null;
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
            gapHeight(sp12),
            InkWell(
              onTap: () async {
                final dates = await DialogUtils.showCalendarDatePicker(
                  context,
                );
                if (dates != null) {
                  myBloc.changeBirthday(dates[0]!);
                }
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
                        state.customer.birthday == null
                            ? 'Chọn ngày sinh'
                            : Date.formatDateDay(
                                state.customer.birthday,
                              ),
                        style: p6.copyWith(color: blackColor),
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
              borderColor: borderColor_2,
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Nam', style: p6),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Nữ', style: p6),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Khác', style: p6),
                ),
              ],
              hintText: 'Chọn giới tính',
              onChanged: (value) => myBloc.changeGender(value ?? 1),
              boxShadow: const [],
              radius: sp8,
            ),
            gapHeight(sp12),
            AppInputSupport(
              label: 'Địa chỉ',
              hintText: 'Chọn địa chỉ',
              readOnly: true,
              borderColor: borderColor_2,
              controller: TextEditingController(
                text: SelectAddressView.formatAddress(
                  state.customer.address,
                ),
              ),
              maxLines: 1,
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
                    detail: state.customer.address?.detail,
                    ward: state.customer.address?.ward,
                    district: state.customer.address?.district,
                    province: state.customer.address?.province,
                    onConfirm: myBloc.updateAddress,
                  ),
                ),
              ),
            ),
            // gapHeight(sp12),
            // CommonDropdown(
            //   label: 'Nhóm khách hàng',
            //   borderColor: borderColor_2,
            //   items: const [
            //     DropdownMenuItem(
            //       value: 1,
            //       child: Text('Nhóm 1', style: p6),
            //     ),
            //     DropdownMenuItem(
            //       value: 2,
            //       child: Text('Nhóm 2', style: p6),
            //     ),
            //     DropdownMenuItem(
            //       value: 3,
            //       child: Text('Nhóm 3', style: p6),
            //     ),
            //   ],
            //   hintText: 'Chọn nhóm',
            //   onChanged: (value) => myBloc.changeGroup(value ?? 1),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _contactInforView(CustomerState state) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin người liên hệ',
            style: p8.copyWith(color: greyTextColor),
          ),
          const Divider(
            height: sp16,
            color: borderColor_2,
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Họ và tên người liên hệ',
            hintText: 'Nhập họ tên người liên hệ',
            initialValue: state.customer.contactName,
            onChanged: (value) => myBloc.changeInfo(contactName: value),
            borderColor: borderColor_2,
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Chức danh người liên hệ',
            hintText: 'Nhập chức danh người liên hệ',
            required: true,
            initialValue: state.customer.contactTitle,
            onChanged: (value) => myBloc.changeInfo(contactTitle: value),
            borderColor: borderColor_2,
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Số điện thoại người liên hệ',
            hintText: 'Nhập số điện thoại người liên hệ',
            required: true,
            initialValue: state.customer.contactPhone,
            onChanged: (value) => myBloc.changeInfo(contactPhone: value),
            textInputType: TextInputType.phone,
            borderColor: borderColor_2,
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return null;
              }
              if (!isPhoneNumberValid(value ?? '') || value?.length != 10) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Email người liên hệ',
            hintText: 'Nhập Email người liên hệ',
            initialValue: state.customer.contactEmail,
            onChanged: (value) => myBloc.changeInfo(contactEmail: value),
            borderColor: borderColor_2,
            validate: (value) {
              if (value == null) {
                return null;
              }
              if (value.isNotEmpty && !isEmailValid(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Địa chỉ',
            hintText: 'Chọn địa chỉ',
            readOnly: true,
            borderColor: borderColor_2,
            controller: TextEditingController(
              text: SelectAddressView.formatAddress(
                state.customer.contactAddress,
              ),
            ),
            maxLines: 1,
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
                  detail: state.customer.contactAddress?.detail,
                  ward: state.customer.contactAddress?.ward,
                  district: state.customer.contactAddress?.district,
                  province: state.customer.contactAddress?.province,
                  onConfirm: myBloc.updateContactAddress,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankInforView(CustomerState state) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin tài khoản ngân hàng',
            style: p8.copyWith(color: greyTextColor),
          ),
          const Divider(
            height: sp16,
            color: borderColor_2,
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Số tài khoản',
            hintText: 'Nhập số tài khoản',
            initialValue: state.customer.accountNumber,
            onChanged: (value) => myBloc.changeInfo(accountNumber: value),
            borderColor: borderColor_2,
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Tên ngân hàng',
            hintText: 'Nhập tên ngân hàng',
            required: true,
            initialValue: state.customer.bankName,
            onChanged: (value) => myBloc.changeInfo(bankName: value),
            borderColor: borderColor_2,
          ),
          gapHeight(sp12),
          AppInputSupport(
            label: 'Cơ sở',
            hintText: 'Nhập cơ sở',
            required: true,
            textInputType: TextInputType.phone,
            initialValue: state.customer.bankBranch,
            onChanged: (value) => myBloc.changeInfo(bankBranch: value),
            borderColor: borderColor_2,
          ),
        ],
      ),
    );
  }

  void _handleCreate(BuildContext context) {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    myBloc.create(context);
  }

  void _handleUpdate(BuildContext context) {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    myBloc.update(context);
  }
}
