import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/double_button.dart';
import '../../../../shared/components/button/label_button.dart';
import '../../../../shared/components/widgets/empty_view.dart';
import '../../../router/router.gr.dart';
import '../../blocs/employee/edit_emp_bloc.dart';
import '../../models/employee/emp_model.dart';
import 'component/branch_and_role_item.dart';
import 'component/dialog_assign.dart';

@RoutePage()
class EditEmpPage extends StatefulWidget {
  const EditEmpPage({super.key, required this.model, this.onRefresh});

  final EmpModel model;
  final VoidCallback? onRefresh;

  @override
  State<EditEmpPage> createState() => _EditEmpPageState();
}

class _EditEmpPageState extends State<EditEmpPage> {
  final bloc = EditEmpBloc();
  List<int> ids = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Thông tin nhân viên'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            // widget.model.userData != null
            //     ? ItemAssignEmp(
            //         model: widget.model.userData!,
            //       )
            //     : const EmptyContainer(
            //         msg: 'Không có thông tin nhân viên',
            //       ),
            _buildWorkingInfo(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Container _buildHeader() {
    return Container(
      padding: 16.pading.copyWith(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: 8.pading,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bg_secondary,
            ),
            child: const Icon(
              Icons.edit,
              color: AppColors.fg_tertiary,
            ),
          ),
          16.height,
          Text(
            'Chỉnh sửa thông tin nhân viên',
            style: AppStyle.heading2xl,
          ),
        ],
      ),
    );
  }

  dynamic _buildWorkingInfo() {
    if (widget.model.workingData?.isNotEmpty ?? true) {
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
          labelBtn: 'Thêm cơ sở làm việc',
          text: 'Chưa có thông tin công việc',
          onPressed: () => context.pushRoute(
            AddWorkToEmpRoute(
              onAdd: (data) {
                setState(() {
                  widget.model.workingData?.add(data);
                });
              },
            ),
          ),
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

  Container _buildListWorking() {
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
                  //       setState(() {
                  //         widget.model.workingData?.add(data);
                  //       });
                  //     },
                  //   ),
                  // );
                  context.dialog(
                    DialogAssign(
                      onAdd: (data) {
                        setState(() {
                          checkCanAdd(data);
                        });
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
            itemCount: widget.model.workingData?.length ?? 0,
            separatorBuilder: (context, index) => 12.height,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => BranchAndRoleItem(
              data: widget.model.workingData![index],
              isUpdate: true,
              canEdit: widget.model.workingData![index].appointments == 0 ||
                  widget.model.workingData![index].appointments == null,
              onEdit: (value) {
                setState(() {
                  widget.model.workingData![index] = value;
                });
              },
              onDelete: () {
                ids.add(widget.model.workingData![index].id ?? -1);
                setState(() {
                  widget.model.workingData!.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildBottom() {
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
      child: DoubleButton(
        confirmText: 'Lưu lại',
        cancelText: 'Hủy bỏ',
        onCancel: () => context.router.maybePop(),
        onConfirm: () {
          DialogUtils.showLoadingDialog(context, 'Đang cập nhật...');
          bloc.update(widget.model, ids).then((value) {
            context.pop();
            if (value.code == 200) {
              widget.onRefresh?.call();
              context.router.maybePop();
            } else {
              log('update emp error: ${value.message}');
            }
          });
        },
      ),
    );
  }

  void checkCanAdd(WorkingDataModel data) {
    bool canAdd = true;
    for (final item in widget.model.workingData ?? []) {
      if (item.company?.id == data.company?.id) {
        canAdd = false;
        break;
      }
    }
    if (canAdd) {
      widget.model.workingData?.add(data);
    }
  }
}
