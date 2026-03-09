import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/blocs/profile_bloc/profile_edit_bloc.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/dialog/dialog_message.dart';
import '../../../../../../shared/components/input/input_column.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../di/di.dart';
import '../../../../../features/address/cubit/location/location_bloc.dart';
import '../../../../../features/address/domain/entities/address_entity.dart';
import '../../../../../features/address/domain/entities/address_item_entity.dart';
import '../../../../../router/router.gr.dart';
import '../../../../blocs/customer/v2/list_customer_bloc.dart';
import '../../../../models/customer/v2/create_model.dart';
import '../../../../models/customer/v2/customer_model.dart';

class BtsAddCustomer extends StatefulWidget {
  const BtsAddCustomer({
    super.key,
    required this.success,
    this.model,
    this.phone,
    this.isEvent = false,
    this.title,
  });

  final Function(CustomerV2Model) success;
  final CustomerV2Model? model;
  final String? phone;
  final bool isEvent;
  final String? title;

  @override
  State<BtsAddCustomer> createState() => _BtsAddCustomerState();
}

class _BtsAddCustomerState extends State<BtsAddCustomer> {
  final _bloc = getIt<ListCustomerV2Bloc>();
  final param = CreateCustomerV2Model();
  final birthday = TextEditingController();

  Gender gender = Gender.male;
  final key = GlobalKey<FormState>();

  bool checkPhone(String phone) {
    for (int i = 0; i < phone.length; i++) {
      if (!phone[i].isDigit()) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    final bool isPhone = checkPhone(widget.phone ?? '');
    param.phone = widget.model?.phone ?? (isPhone ? widget.phone : '');
    param.fullName = widget.model?.fullName ?? (!isPhone ? widget.phone : '');
    param.birthday = widget.model?.birthday;
    param.gender = widget.model?.gender;
    param.address = widget.model?.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: widget.title ?? 'Thêm mới khách hàng',
      cancelText: 'Hủy bỏ',
      confirmText: 'Xác nhận',
      onCancel: () {
        Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
      },
      onConfirm: () async {
        if (!key.currentState!.validate()) return;
        final res = await _bloc.checkIsExist(param.phone ?? '');
        if (res != null) {
          context.dialog(
            DialogConfirm(
              title: 'Thông báo',
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Khách hàng ${res.phone.validator} - ${res.fullName.validator} ',
                      style: AppStyle.bodyBsSemiBold
                          .copyWith(color: AppColors.text_secondary),
                    ),
                    TextSpan(
                      text: 'đã tồn tại!',
                      style: AppStyle.bodyBsRegular.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ),
              ),
              icon: IconDiaLog(
                icon: FaIcon(
                  iconCode: 'f071',
                  color: AppColors.fg_warning,
                  type: FaIconType.solid,
                ),
                color: AppColors.fg_warning.withOpacity(0.1),
              ),
              closeLabel: 'Trở lại',
              confirmLabel: 'Chọn khách hàng',
              close: () {
                context.pop();
              },
              confirm: () {
                context.pop();
                context.pop();
                widget.success(res);
              },
            ),
          );
        } else {
          context.pop();
          widget.success(
            CustomerV2Model(
              fullName: param.fullName,
              phone: param.phone,
              birthday: param.birthday,
              gender: gender.getName,
              address: param.address,
            ),
          );
        }
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputColumn(
                label: 'Số điện thoại',
                textInputType: TextInputType.phone,
                padding: 0.pading,
                initialValue: param.phone,
                onChanged: (p0) => param.phone = p0,
                isRequired: widget.isEvent,
              ),
              16.height,
              InputColumn(
                label: 'Tên khách hàng',
                isRequired: true,
                padding: 0.pading,
                initialValue: param.fullName,
                onChanged: (p0) => param.fullName = p0,
              ),
              16.height,
              InputColumn(
                label: 'Ngày sinh',
                padding: 0.pading,
                readOnly: true,
                controller: birthday,
                prefixIcon: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.fg_quaternary,
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
                      param.birthday = value.fomatCustom(fomat: 'yyyy-MM-dd');
                      birthday.text = value.fomatDefaulft;
                    }
                  });
                },
              ),
              16.height,
              _buildGender(),
              // BuildAddress(
              //   addressEntity: param.address,
              //   onTap: chooseAddress,
              // ),
              16.height,
              InputColumn(
                label: 'Địa chỉ',
                padding: 0.pading,
                initialValue: param.address?.title ?? param.address?.detail,
                onChanged: (p0) => setState(() {
                  param.address = AddressEntity(
                    title: p0,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildGender() {
    return Row(
      children: [
        Row(
          children: [
            Radio<Gender>(
              value: Gender.male,
              groupValue: gender,
              activeColor: AppColors.ultility_blue,
              onChanged: (Gender? value) {
                gender = value ?? Gender.male;
                setState(() {});
              },
            ).size(
              height: 24,
              width: 24,
            ),
            8.width,
            Text(Gender.male.getName),
          ],
        ).expanded(),
        Row(
          children: [
            Radio<Gender>(
              value: Gender.female,
              groupValue: gender,
              activeColor: AppColors.ultility_blue,
              onChanged: (Gender? value) {
                gender = value ?? Gender.female;
                setState(() {});
              },
            ).size(
              height: 24,
              width: 24,
            ),
            8.width,
            Text(Gender.female.getName),
          ],
        ).expanded(),
      ],
    );
  }

  void chooseAddress() {
    context
        .pushRoute(
      AddressRoute(
        model: param.address != null
            ? BackAddress.mapAddressEntity(param.address)
            : null,
      ),
    )
        .then(
      (value) {
        if (value is BackAddress) {
          setState(() {
            param.address = AddressEntity(
              title: value.address,
              ward: AddressItemEntity(
                code: value.ward?.code ?? '',
                name: value.ward?.title ?? '',
              ),
              district: AddressItemEntity(
                code: value.district?.code ?? '',
                name: value.district?.title ?? '',
              ),
              province: AddressItemEntity(
                code: value.province?.code ?? '',
                name: value.province?.title ?? '',
              ),
            );
          });
        }
      },
    );
  }
}
