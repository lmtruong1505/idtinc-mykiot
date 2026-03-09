import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../constants/spacing.dart';

// ignore: must_be_immutable
class CustomerFastCreateView extends StatefulWidget {
  CustomerFastCreateView({
    super.key,
    required this.onConfirm,
    this.onUpdate,
    required this.onCancel,
    this.customer,
    this.phone,
  });

  final Function(String phone, String name) onConfirm;
  final Function(CustomerEntity? value)? onUpdate;
  final Function() onCancel;
  CustomerEntity? customer;
  String? phone;

  @override
  State<CustomerFastCreateView> createState() => _CustomerFastCreateViewState();
}

class _CustomerFastCreateViewState extends State<CustomerFastCreateView> {
  late TextEditingController _phoneController;
  late TextEditingController _nameController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _phoneController = TextEditingController()..text = widget.phone ?? '';
    _nameController = TextEditingController();
    if (widget.customer != null) {
      _phoneController.text = widget.customer?.phone ?? '';
      _nameController.text = widget.customer?.name ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          onChanged: () {
            _keyForm.currentState?.validate();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.customer != null
                    ? 'Chỉnh sửa khách hàng'
                    : 'Tạo mới khách hàng',
                textAlign: TextAlign.center,
                style: StyleApp.bold(
                  color: ColorApp.black,
                ),
              ),
              16.height,
              AppInputV2(
                hintText: 'Số điện thoại',
                controller: _phoneController,
                prefixIcon: const Icon(Icons.phone_outlined),
                textInputType: TextInputType.phone,
                required: true,
                validate: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (value!.isNotEmpty) {
                    return value.validatorTextField(type: TextInputType.phone);
                  }
                  return null;
                },
              ),
              16.height,
              AppInputSupport(
                hintText: 'Tên khách hàng',
                controller: _nameController,
                required: true,
                validate: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Vui lòng nhập tên khách hàng';
                  }
                  return null;
                },
              ),
              16.height,
              Row(
                children: [
                  ExtraButton(
                    title: 'Huỷ bỏ',
                    event: () {
                      widget.onCancel.call();
                    },
                  ).expanded(),
                  8.width,
                  MainButton(
                    title: 'Xác nhận',
                    event: () {
                      if (_keyForm.currentState?.validate() ?? false) {
                        widget.customer != null
                            ? widget.onUpdate?.call(
                                widget.customer!.copyWith(
                                  phone: _phoneController.text,
                                  name: _nameController.text,
                                ),
                              )
                            : widget.onConfirm.call(
                                _phoneController.text,
                                _nameController.text,
                              );
                      }
                    },
                  ).expanded(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
