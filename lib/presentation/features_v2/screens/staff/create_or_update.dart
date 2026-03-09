import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features/address/cubit/location/location_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/param/create_or_update_param.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/components/bottom_sheet/bottom_sheet_location.dart';

import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../blocs/staff/staff_bloc.dart';
import '../../blocs/staff/staff_manager_bloc.dart';

@RoutePage()
class CreateOrUpdateStaffPage extends StatefulWidget {
  final EmployeeModel? employee;
  const CreateOrUpdateStaffPage({
    super.key,
    this.employee,
  });

  @override
  State<CreateOrUpdateStaffPage> createState() =>
      _CreateOrUpdateStaffPageState();
}

class _CreateOrUpdateStaffPageState extends State<CreateOrUpdateStaffPage> {
  final _keyForm = GlobalKey<FormState>();
  final birthDay = TextEditingController();
  final address = TextEditingController();
  final roleBloc = ListRoleBloc();
  // final companyBloc = getIt<WorkSpaceCubit>();
  final bloc = StaffBloc();

  final param = CreateOrUpdateParam(
    accountType: 'EMPLOYEE',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roleBloc.getList(valueData: widget.employee?.role);
    // companyBloc.getListCompanies(
    //   companyIdData: widget.employee?.companyId,
    //   parent: getCompany,
    // );
    if (widget.employee != null) {
      birthDay.text = widget.employee?.dob.fomatDefaulft ?? '';

      address.text =
          BackAddress.mapData(widget.employee?.address).addressDetail ?? '';

      setParam();
    }
  }

  setParam() {
    param.address = widget.employee?.address == null
        ? null
        : BackAddress.mapData(widget.employee?.address);
    param.fullName = widget.employee?.fullName;
    param.username = widget.employee?.username;
    param.email = widget.employee?.email;
    param.licence = widget.employee?.licence;
    param.company = widget.employee?.roleData?.company;
    param.role = widget.employee?.role;
    param.active = widget.employee?.active;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          successBtnText: widget.employee != null ? 'Chi tiết' : 'Danh sách',
          success: () {
            if (widget.employee == null) {
              context.read<StaffManagerBloc>().getList();
            }
            context.pop();
            context.pop(result: true);
          },
        );
      },
      child: Scaffold(
        appBar: BaseAppBar(
          title: widget.employee != null
              ? 'Cập nhật nhân viên '
              : 'Tạo mới nhân viên',
        ),
        bottomNavigationBar: MainButtonV2(
          onTap: () {
            if (_keyForm.currentState!.validate()) {
              if (widget.employee?.id != null) {
                bloc.update(widget.employee?.id ?? 0, param);
              } else {
                bloc.create(param);
              }
            } else {
              CheckStateBloc.showSnackBar(
                context,
                'Vui lòng nhập đầy đủ thông tin',
                colorBg: ColorApp.red,
              );
            }
          },
          title: 'Xác nhận',
        ).container(),
        body: SingleChildScrollView(
          padding: 16.pading,
          child: Form(
            key: _keyForm,
            onChanged: () {
              _keyForm.currentState?.validate();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // InputColumn(
                //   label: 'Mã nhân viên',
                //   initialValue: widget.employee?.code,
                //   onChanged: (p0) => param.code = p0,
                // ),
                InputColumn(
                  label: 'Tên nhân viên',
                  isRequired: true,
                  initialValue: widget.employee?.fullName,
                  onChanged: (p0) => param.fullName = p0,
                ),
                InputColumn(
                  label: 'Số điện thoại',
                  isRequired: true,
                  initialValue: widget.employee?.username,
                  textInputType: TextInputType.phone,
                  onChanged: (p0) => param.username = p0,
                ),
                if (widget.employee == null)
                  InputColumn(
                    label: 'Mật khẩu',
                    isRequired: true,
                    isPassword: true,
                    minLines: 1,
                    textInputType: TextInputType.visiblePassword,
                    onChanged: (p0) => param.password = p0,
                  ),
                InputColumn(
                  label: 'Email',
                  initialValue: widget.employee?.email,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (p0) => param.email = p0,
                ),
                InputColumn(
                  label: 'Số CMND/CCCD',
                  initialValue: widget.employee?.licence,
                  onChanged: (p0) => param.licence = p0,
                ),
                InputColumn(
                  label: 'Vị trí',
                  isRequired: true,
                  controller: address,
                  suffixIcon: const Icon(
                    Icons.location_on_outlined,
                  ),
                  onTap: () {
                    context.bottomSheet(const BottomSheetLocationPage()).then(
                      (value) {
                        if (value is BackAddress) {
                          param.address = value;
                          address.text = value.addressDetail ?? '';
                        }
                      },
                    );
                  },
                ),
                InputColumn(
                  label: 'Ngày sinh',
                  suffixIcon: const Icon(
                    Icons.calendar_month_outlined,
                  ),
                  controller: birthDay,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(1700),
                      lastDate: DateTime.now(),
                      initialDate: param.dob.toDate,
                      currentDate: DateTime.now(),
                    ).then(
                      (value) {
                        if (value is DateTime) {
                          //param.dob = '${value.toIso8601String()}Z';
                          param.dob = value.fomatCustom(fomat: 'yyyy-MM-dd');
                          birthDay.text = value.fomatDefaulft;
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ListRoleBloc, CubitState>(
                  bloc: roleBloc,
                  builder: (context, state) {
                    return DropDownColumn<int>(
                      label: 'Vai trò',
                      isRequired: true,
                      value: roleBloc.value,
                      items: List.generate(
                        roleBloc.list.length,
                        (index) {
                          return DropdownMenuItem(
                            value: roleBloc.list[index].id,
                            child: Text(
                              roleBloc.list[index].title ?? '',
                              style: StyleApp.normal(),
                            ),
                          );
                        },
                      ),
                      onChanged: (p0) {
                        param.role = p0;
                        // param.accountType = roleBloc.list
                        //     .firstWhere(
                        //       (element) => element.id == p0,
                        //     )
                        //     .code;
                      },
                    );
                  },
                ),
                // BlocBuilder<WorkSpaceCubit, WorkSpaceState>(
                //   bloc: companyBloc,
                //   builder: (context, state) {
                //     return DropDownColumn<int>(
                //       label: 'Cơ sở',
                //       value: companyBloc.companyId,
                //       //isRequired: true,
                //       items: List.generate(
                //         state.companies.length,
                //         (index) {
                //           return DropdownMenuItem(
                //             value: state.companies[index].id,
                //             child: Text(
                //               state.companies[index].name ?? '',
                //               style: StyleApp.normal(),
                //             ),
                //           );
                //         },
                //       ),
                //       onChanged: (p0) {
                //         param.company = p0;
                //       },
                //     );
                //   },
                // ),
                16.height,
              ],
            ).container(
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
