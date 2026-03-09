import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/v2/customer_action_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/v2/list_customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/bg/bg_btn_nav_bar.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/header_create.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../features/address/domain/entities/address_entity.dart';
import '../../blocs/profile_bloc/profile_edit_bloc.dart';
import '../../models/customer/v2/create_model.dart';
import '../../models/customer/v2/customer_model.dart';

@RoutePage()
class CreateCustomerV2Page extends StatefulWidget {
  final CustomerV2Model? customer;
  const CreateCustomerV2Page({super.key, this.customer});

  @override
  State<CreateCustomerV2Page> createState() => _CreateCustomerV2PageState();
}

class _CreateCustomerV2PageState extends State<CreateCustomerV2Page> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = CustomerActionV2Bloc();
  final param = CreateCustomerV2Model();
  final birthday = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    if (widget.customer != null) {
      param.fullName = widget.customer?.fullName ?? '';
      param.phone = widget.customer?.phone ?? '';
      param.birthday = widget.customer?.birthday ?? '';
      param.gender = widget.customer?.gender;
      param.address = widget.customer?.address;
      birthday.text = widget.customer?.birthday ?? '';
    } else {
      param.gender = Gender.male.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerActionV2Bloc, CubitState>(
      bloc: _bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          route:
              state.data is int ? DetailCustomerV2Route(id: state.data) : null,
          success: () {
            getIt<ListCustomerV2Bloc>().getList();
            context.router.popUntil(
              (route) => route.settings.name == HomeRoute.name,
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBarTitleCenter(
          title: '',
          leadingText: 'Trở về',
        ),
        bottomNavigationBar: BgBtnNavBar(
          child: DoubleButton(
            onCancel: () => context.pop(),
            onConfirm: () {
              if (_formKey.currentState?.validate() == true) {
                if (widget.customer != null) {
                  _bloc.update(widget.customer!.id!, param);
                } else {
                  _bloc.create(param);
                }
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: 16.padingVer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderCreate(
                iconCode: 'f234',
                isEdit: widget.customer != null,
                title: widget.customer == null
                    ? 'Tạo mới khách hàng'
                    : 'Cập nhật khách hàng',
              ),
              36.height,
              _buildForm(),
              context.padding.bottom.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: 16.padingHor,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputColumn(
              label: 'Tên khách hàng',
              isRequired: true,
              padding: 0.pading,
              initialValue: param.fullName,
              onChanged: (p0) => param.fullName = p0,
            ),
            16.height,
            InputColumn(
              label: 'Số điện thoại',
              textInputType: TextInputType.phone,
              padding: 0.pading,
              initialValue: param.phone,
              onChanged: (p0) => param.phone = p0,
            ),
            16.height,
            DropDownColumn<String>(
              label: 'Giới tính',
              padding: 0.pading,
              value: param.gender,
              onChanged: (p0) {
                param.gender = p0;
              },
              items: List.generate(Gender.values.length, (index) {
                return DropdownMenuItem(
                  value: Gender.values[index].code,
                  child: Text(
                    Gender.values[index].getName,
                  ),
                );
              }),
            ),
            16.height,
            InputColumn(
              label: 'Ngày sinh',
              padding: 0.pading,
              readOnly: true,
              controller: birthday,
              suffixIcon: const Icon(
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
    );
  }
}
