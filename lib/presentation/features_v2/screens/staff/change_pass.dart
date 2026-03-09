import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/param/create_or_update_param.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/bg_action.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../blocs/staff/staff_bloc.dart';

@RoutePage()
class ChangePassStaffPage extends StatefulWidget {
  final EmployeeModel staff;
  const ChangePassStaffPage({
    super.key,
    required this.staff,
  });

  @override
  State<ChangePassStaffPage> createState() => _ChangePassStaffPageState();
}

class _ChangePassStaffPageState extends State<ChangePassStaffPage> {
  final bloc = StaffBloc();
  final pass = TextEditingController();
  final passConfirm = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Đổi mật khẩu',
      ),
      bottomNavigationBar: RowBtn(
        onCancel: () => context.pop(),
        onConfirm: () { 
          if (_keyForm.currentState!.validate() &&
              pass.text == passConfirm.text) {
            bloc.update(
              widget.staff.id ?? 0,
              CreateOrUpdateParam(password: passConfirm.text),
            );
          } else if (pass.text != passConfirm.text) {
            CheckStateBloc.showSnackBar(
              context,
              'Mật khẩu không khớp',
              colorBg: ColorApp.red,
            );
          }
        },
      ).container(),
      body: BlocListener<StaffBloc, CubitState>(
        bloc: bloc,
        listener: (context, state) {
          CheckStateBloc.check(
            context,
            state,
            success: () => context.back(),
          );
        },
        child: SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _keyForm,
                child: BgAction(
                  title: 'Đổi mật khẩu',
                  click: true,
                  colorTitle: ColorApp.grey47,
                  fontSize: 14,
                  isTextClick: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputColumn(
                        label: 'Mật khẩu mới',
                        isRequired: true,
                        isPassword: true,
                        controller: pass,
                        textInputType: TextInputType.visiblePassword,
                      ),
                      InputColumn(
                        label: 'Nhập lại mật khẩu mới',
                        isRequired: true,
                        isPassword: true,
                        controller: passConfirm,
                        textInputType: TextInputType.visiblePassword,
                      ),
                      16.height,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
