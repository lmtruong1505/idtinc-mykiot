import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/check_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/label_button.dart';
import '../../../../base/v2/expanded_section.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/role_v2/role_detail_bloc.dart';
import '../components/bts_assign_emp.dart';
import '../components/rm_emp_item.dart';

class EmpTab extends StatefulWidget {
  const EmpTab({super.key, required this.bloc, this.onSuccess});

  final RoleDetailBloc bloc;
  final VoidCallback? onSuccess;

  @override
  State<EmpTab> createState() => _EmpTabState();
}

class _EmpTabState extends State<EmpTab> with AutomaticKeepAliveClientMixin {
  final textCtrl = TextEditingController();

  bool assignEmp = isOwnerWsCsMn && checkPermission(PerRoleEnum.ASSIGN_EMPLOYEE.code);

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<RoleDetailBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const BaseLoading();
        }
        return Scaffold(
          bottomNavigationBar: _buildRemove(),
          body: SingleChildScrollView(
            padding: 16.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearch(),
                24.height,
                _buidHeaderList(),
                16.height,
                if (widget.bloc.employees.isNotEmpty)
                  ListView.separated(
                    itemBuilder: (context, index) => RmEmpItem(
                      emp: widget.bloc.employees[index],
                      isSelected: widget.bloc.checkIfCanRemove(
                        widget.bloc.employees[index].id ?? -1,
                      ),
                      onToggle: (value) {
                        if(!assignEmp) {
                          context.permissionDenied()();
                          return;
                        }
                        widget.bloc.toggleRemove(
                          widget.bloc.employees[index].id ?? -1,
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => 0.height,
                    itemCount: widget.bloc.employees.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                if (widget.bloc.employees.isEmpty) const EmptyContainer(),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildSearch() {
    return AppInputV2(
      hintText: 'Nhập tên, số điện thoại, mã',
      controller: textCtrl,
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      suffixIcon: InkWell(
        onTap: () {
          textCtrl.clear();
          widget.bloc.search = '';
        },
        child: const Icon(
          Icons.clear_outlined,
          size: 16,
        ),
      ),
      onChanged: (value) {
        widget.bloc.search = value;
      },
      radius: 999,
    );
  }

  _buidHeaderList() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${widget.bloc.model?.employees?.length ?? 0} nhân viên',
              style: AppStyle.bodyBsMedium
                  .copyWith(color: AppColors.text_tertiary),
            ).expanded(),
            12.width,
            LabelButton(
              onPressed: assignEmp ?  () {
                context.bottomSheet(
                  BtsAssignEmp(
                    id: [],
                    onSelected: (value) {
                      widget.bloc.assign(value).then((value2) {
                        CheckStateBloc.showSnackBar(
                          context,
                          value2.code == 200
                              ? 'Gán nhân viên thành công'
                              : value2.message.validator,
                        );
                        if (value2.code == 200) {
                          widget.bloc
                              .getDetail(widget.bloc.model?.role?.id ?? 0);
                          widget.onSuccess?.call();
                        }
                      });
                    },
                  ),
                );
              } : context.permissionDenied(),
              label: 'Gán nhân viên',
              backgroundColor: AppColors.button_neutral_alpha_backgroundDefault,
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.button_neutral_alpha_textDefault,
              ),
              spaceIcon: 4,
              suffixIcon: const Icon(
                Icons.add,
                color: AppColors.button_neutral_alpha_textDefault,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildRemove() {
    return ExpandedSection(
      isSelected: widget.bloc.selectToRemoves.isNotEmpty,
      child: Row(
        children: [
          Text(
            'Đã chọn ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          Text(
            '(${widget.bloc.selectToRemoves.length})',
            style: AppStyle.headingMd,
          ),
          const Spacer(),
          LabelButton(
            onPressed: assignEmp ?  () {
              widget.bloc.detachEmp().then((value) {
                if (value.code == 200) {
                  CheckStateBloc.showSnackBar(
                    context,
                    'Xóa nhân viên thành công',
                  );
                  widget.bloc.selectToRemoves.clear();
                  widget.bloc.getDetail(widget.bloc.model?.role?.id ?? 0);
                  widget.onSuccess?.call();
                }
              });
            } : context.permissionDenied(),
            label: 'Loại nhân viên',
            backgroundColor: AppColors.button_negative_solid_backgroundDefault,
            labelStyle: AppStyle.bodyMdMedium.copyWith(
              color: AppColors.button_negative_solid_textDefault,
            ),
          ),
        ],
      ).container(
        padding:
            12.padingTop + 16.padingHor + context.padding.bottom.padingBottom,
      ),
    ).container(
      padding: 0.pading,
      boxShadow: AppShadows.elevator3,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
