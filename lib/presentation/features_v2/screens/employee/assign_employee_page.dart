import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/check_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/branch_and_role_item.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/dialog_assign.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/item_assign_emp.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/empty_view.dart';
import '../../../../shared/components/widgets/progess_stepper.dart';
import '../../../base/empty_container.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/employee/assign_employee_bloc.dart';
import '../../blocs/enum/bloc_status.dart';

@RoutePage()
class AssignEmployeePage extends StatefulWidget {
  const AssignEmployeePage({super.key});

  @override
  State<AssignEmployeePage> createState() => _AssignEmployeePageState();
}

class _AssignEmployeePageState extends State<AssignEmployeePage> {
  final _key = GlobalKey<FormState>();

  final bloc = AssignEmployeeBloc();

  final textCtrl = TextEditingController();

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: 'Thêm nhân viên',
        leadingText: 'Trở về',
      ),
      backgroundColor: AppColors.bg_primary,
      body: BlocBuilder<AssignEmployeeBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return _buildBody();
        },
      ),
      bottomNavigationBar: _buildBtnNav(),
    );
  }

  _buildBody() {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStepper(),
            if (bloc.currentStep == 0)
              Column(
                children: [
                  InputColumn(
                    label: 'Mã thành viên Pharmago',
                    hintText: 'Nhập mã thành viên',
                    isRequired: true,
                    controller: textCtrl,
                  ),
                  if (bloc.state.status == BlocStatus.loading)
                    const BaseLoading().padding(16.pading),
                ],
              ),
            if (bloc.currentStep == 1) _buildDetail(),
          ],
        ),
      ),
    );
  }

  _buildStepper() {
    return ProgessStepper(
      steps: bloc.steps,
      current: bloc.currentStep,
    ).padding(16.padingVer + 32.padingHor);
  }

  _buildDetail() {
    if (bloc.model?.userData == null) {
      return const EmptyContainer(
        msg: 'Không tìm thấy thông tin nhân viên',
      );
    }
    return Column(
      children: [
        16.height,
        ItemAssignEmp(
          model: bloc.model!.userData!,
        ),
        24.height,
        _buildWorkingInfo(),
      ],
    );
  }

  _buildBtnNav() {
    return BlocBuilder<AssignEmployeeBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Container(
          padding: 16.padingHor + 12.padingTop + 32.padingBottom,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.border_tertiary,
                width: 1,
              ),
            ),
          ),
          child: DoubleButtonWithIcon(
            confirmText: bloc.currentStep == 0 ? 'Xác nhận' : 'Thêm',
            cancelText: bloc.currentStep == 0 ? 'Quét mã' : 'Trở về',
            canPressed: bloc.currentStep == 0 || bloc.workingData.isNotEmpty,
            iconCancel: bloc.currentStep == 0
                ? const Icon(
                    Icons.qr_code,
                    color: AppColors.button_neutral_outlined_iconDefault,
                  )
                : null,
            onCancel: () {
              if (bloc.currentStep == 1) {
                bloc.nextStep(0);
                bloc.clear();
                return;
              }
              if (bloc.currentStep == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                ).then((value) {
                  if (value != null && value is String) {
                    textCtrl.text = value;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không tìm thấy mã'),
                      ),
                    );
                  }
                });
                return;
              }
            },
            onConfirm: () {
              if (_key.currentState!.validate() && bloc.currentStep == 0) {
                _findEmp();
                return;
              }
              if (bloc.currentStep == 1) {
                _assignEmp();
              }
            },
            equal: bloc.currentStep == 1,
          ),
        );
      },
    );
  }

  _buildWorkingInfo() {
    if (bloc.workingData.isNotEmpty) {
      return _buildListWorking();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin công việc',
          style: AppStyle.bodyMdRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
          textAlign: TextAlign.start,
        ).padding(16.padingHor),
        const Divider(
          color: AppColors.border_tertiary,
          thickness: 1,
        ).padding(16.padingHor),
        EmptyComfirm(
          labelBtn: 'Thêm nơi làm việc',
          text: 'Chưa có thông tin công việc',
          // onPressed: () => context.pushRoute(
          //   AddWorkToEmpRoute(
          //     onAdd: (data) {
          //       bloc.addWorkingData(data);
          //     },
          //   ),
          // ),
         onPressed: () {
            context.dialog(
              DialogAssign(
                    onAdd: (data) {
                      bloc.addWorkingData(data);
                    },
              ),
            );
          },
          svgAsset: Assets.iconsIcEmpty2,
          suffixIcon: const Icon(
            Icons.add,
            color: AppColors.button_brand_solid_iconDefault,
            size: 20,
          ),
          btnColor: AppColors.button_neutral_solid_backgroundDefault,
        ).size(width: double.infinity),
      ],
    );
  }

  _buildListWorking() {
    return Container(
      padding: 16.padingHor,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Thông tin công việc',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
                textAlign: TextAlign.start,
              ).expanded(),
              InkWell(
                onTap: () {
                  // context.pushRoute(
                  //   AddWorkToEmpRoute(
                  //     onAdd: (data) {
                  //       bloc.addWorkingData(data);
                  //     },
                  //   ),
                  // );
                  context.dialog(
                    DialogAssign(
                      onAdd: (data) {
                        bloc.addWorkingData(data);
                      },
                    ),
                  );
                },
                child: LabelButton(
                  label: 'Thêm',
                  labelStyle: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.button_neutral_alpha_textDefault,
                  ),
                  suffixIcon: const Icon(
                    Icons.add,
                    color: AppColors.button_neutral_alpha_iconDefault,
                    size: 20,
                  ),
                ).size(height: 32),
              ),
            ],
          ),
          const Divider(
            color: AppColors.border_tertiary,
            thickness: 1,
          ),
          4.height,
          ListView.separated(
            itemCount: bloc.workingData.length,
            separatorBuilder: (context, index) => 12.height,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => BranchAndRoleItem(
              data: bloc.workingData[index],
              onEdit: (data) {
                bloc.changeWorkingData(data);
              },
              onDelete: () {
                bloc.removeWorkingData(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _findEmp() {
    bloc.findEmp(textCtrl.text).then((value) {
      if (value.code == 200) {
        bloc.nextStep(1);
      } else {
        CheckStateBloc.checkNoLoad(
          context,
          bloc.state.copyWith(
            msg: value.message,
            status: BlocStatus.failure,
          ),
          isShowMsg: true,
        );
      }
    });
  }

  void _assignEmp() {
    bloc.assign().then((value) {
      if (value.code == 200) {
        CheckStateBloc.showSnackBar(context, 'Thêm nhân viên thành công');
        context.maybePop(true);
      } else {
        CheckStateBloc.checkNoLoad(
          context,
          bloc.state.copyWith(
            msg: value.message,
            status: BlocStatus.failure,
          ),
          isShowMsg: true,
        );
      }
    });
  }
}
