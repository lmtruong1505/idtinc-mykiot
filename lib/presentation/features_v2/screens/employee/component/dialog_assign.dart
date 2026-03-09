import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_string.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/components/button/label_button.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../base/svg.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../di/di.dart';
import '../../../../features/company/data/models/company_model.dart';
import '../../../blocs/employee/add_work_to_emp_bloc.dart';
import '../../../blocs/state/cubit_state.dart';
import '../../../models/employee/working_data_model.dart';
import '../../../models/role/role_model.dart';
import 'branch_item.dart';
import 'bts_select_branch.dart';
import 'bts_select_role.dart';
import 'stepper_custom.dart';

class DialogAssign extends StatefulWidget {
  const DialogAssign({
    super.key,
    this.onAdd,
    this.company,
    this.roleData,
    this.oldWs,
    this.isUpdate = false,
  });

  final Function(WorkingDataModel)? onAdd;
  final CompanyModel? company;
  final int? oldWs;
  final List<RoleListModel>? roleData;
  final bool isUpdate;

  @override
  State<DialogAssign> createState() => _DialogAssignState();
}

class _DialogAssignState extends State<DialogAssign> {
  final bloc = getIt<AddWorkToEmpBloc>();

  final key = GlobalKey<FormState>();

  @override
  void initState() {
    bloc.init(widget.company?.id, widget.roleData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: 16.radius,
      ),
      insetPadding: 16.pading,
      child: Padding(
        padding: 16.pading,
        child: BlocBuilder<AddWorkToEmpBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                8.height,
                Text(
                  'Thông tin công việc',
                  style: AppStyle.headingLg,
                ),
                16.height,
                _buildCompany(),
                16.height,
                _buildRoles(),
                16.height,
                _buildProcess(),
                16.height,
                _buildBottom(),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Row(
      children: [
        IcSvg.asset('/profile_info.svg'),
        Spacer(),
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            borderRadius: 999.radius,
            color: AppColors.button_neutral_alpha_backgroundDefault,
          ),
          padding: 4.pading,
          child: InkWell(
            onTap: () {
              context.pop();
            },
            child: Icon(
              CupertinoIcons.clear,
              size: 14,
            ),
          ),
        )
      ],
    );
  }

  _buildCompany() {
    if (bloc.company != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title1,
          4.height,
          ItemBranch2(
            branch: bloc.company!,
            onEdit: () {
              context.bottomSheet(
                BtsSelectBranch(
                  id: bloc.company?.id,
                  onSelected: (company) {
                    bloc.setCompany(company);
                  },
                ),
              );
            },
          ),
        ],
      );
    }
    return FormField(
      validator: (value) => bloc.company == null ? 'Vui lòng chọn cơ sở' : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title1,
          4.height,
          ChipDashBorder(
            title: 'Chọn nơi làm việc',
            color: AppColors.text_secondary,
            padding: 8.pading,
            titleStyle: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_secondary,
            ),
            suffixIcon: const Icon(
              Icons.add,
              size: 16,
              color: AppColors.text_secondary,
            ),
            onTap: () {
                  context.bottomSheet(
                    BtsSelectBranch(
                      id: bloc.company?.id,
                      onSelected: (company) {
                        bloc.setCompany(company);
                      },
                    ),
                  );
            },
          ),
          if (field.hasError)
            Text(
              field.errorText ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }

  _buildRoles() {
    if (bloc.company == null) return Container();
    if (bloc.roles.isEmpty) {
      return FormField(
        validator: (value) =>
            bloc.roles.isEmpty ? 'Vui lòng chọn vai trò' : null,
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            title2,
            4.height,
            ChipDashBorder(
              title: 'Chọn vai trò',
              color: AppColors.text_secondary,
              padding: 8.pading,
              titleStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_secondary,
              ),
              suffixIcon: const Icon(
                Icons.add,
                size: 16,
                color: AppColors.text_secondary,
              ),
              onTap: () {
                    context.bottomSheet(
                      BtsSelectRole(
                        id: bloc.roles.map((e) => e.id ?? -1).toList(),
                        onSelected: (roles) {
                          bloc.setRoles(roles);
                        },
                        company: bloc.company?.id ?? -1,
                      ),
                    );
              },
            ),
            if (field.hasError)
              Text(
                field.errorText ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
          ],
        ),
      );
    }
    final list = bloc.roles
        .map(
          (e) => ChipCustom(
            color: AppColors.ultility_gray_60,
            title: e.title.validator,
            padding: 8.padingHor + 2.padingVer,
            titleStyle: AppStyle.bodyBsSemiBold,
            suffixIcon: InkWell(
              onTap: () {
                bloc.removeRole(e.id ?? -1);
              },
              child: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.ultility_gray_40,
              ),
            ).padding(2.padingLeft),
          ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title2,
        4.height,
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 12,
          spacing: 12,
          children: [
            ...list,
            InkWell(
              onTap: () {
                context.bottomSheet(
                  BtsSelectRole(
                    id: bloc.roles.map((e) => e.id ?? -1).toList(),
                    onSelected: (roles) {
                      bloc.setRoles(roles);
                    },
                    company: bloc.company?.id ?? -1,
                  ),
                );
              },
              child: ChipDashBorder(
                color: AppColors.ultility_gray_40,
                title: 'Thêm',
                padding: 8.padingHor + 2.padingVer,
                suffixIcon: const Icon(
                  Icons.add,
                  size: 14,
                  color: AppColors.ultility_gray_40,
                ).padding(2.padingLeft),
                titleStyle: AppStyle.bodyBsSemiBold,
              ).size(width: 120),
            ),
          ],
        ),
      ],
    );
  }

  _buildBottom() {
    return BlocBuilder<AddWorkToEmpBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        late int stateIdx;
        if (bloc.company == null) {
          stateIdx = 1;
        } else if (bloc.roles.isEmpty) {
          stateIdx = 2;
        } else {
          stateIdx = 3;
        }
        return Row(
          children: [
            LabelButton(
              label: stateIdx == 2 ? 'Trở về' : 'Huỷ bỏ',
              backgroundColor: AppColors.button_neutral_alpha_backgroundDefault
                  .withOpacity(0.05),
              labelStyle: AppStyle.bodyBsMedium,
              prefixIcon: stateIdx == 2
                  ? const Icon(
                      Icons.arrow_back,
                      size: 14,
                      color: AppColors.button_neutral_alpha_textDefault,
                    )
                  : null,
              onPressed: () {
                if (stateIdx == 2) {
                  bloc.setCompany(null);
                } else {
                  context.pop();
                }
              },
            ).expanded(),
            8.width,
            LabelButton(
              label: stateIdx == 1 ? 'Tiếp tục' : 'Xác nhận',
              labelStyle: stateIdx != 3
                  ? AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_brand_solid_textDisabled,
                    )
                  : null,
              suffixIcon: stateIdx == 1
                  ? const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.button_brand_solid_textDisabled,
                    )
                  : null,
              onPressed: stateIdx != 3
                  ? null
                  : () {
                      if (!widget.isUpdate) {
                        // create new emp
                        widget.onAdd?.call(
                          WorkingDataModel(
                            company: CompanyModel.fromEntity(bloc.company!),
                            roleData: bloc.roles,
                          ),
                        );
                        context.pop(
                          result: WorkingDataModel(
                            company: CompanyModel.fromEntity(bloc.company!),
                            roleData: bloc.roles,
                          ),
                        );
                      } else {
                        // update emp
                        context.pop(
                          result: WorkingDataModel(
                            company: CompanyModel.fromEntity(bloc.company!),
                            roleData: bloc.roles,
                            id: widget.oldWs,
                          ),
                        );
                      }
                    },
            ).expanded(),
          ],
        );
      },
    );
  }

  _buildProcess() {
    return BlocBuilder<AddWorkToEmpBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Row(
          children: [
            StepperCustom(
              doing: bloc.company == null,
              done: bloc.company != null,
            ).expanded(),
            8.width,
            StepperCustom(
              doing: bloc.company != null && bloc.roles.isEmpty,
              done: bloc.company != null && bloc.roles.isNotEmpty,
            ).expanded(),
          ],
        );
      },
    );
  }
  Widget get title1 => RichText(
    text: TextSpan(
      text: 'Cơ sở',
      style: AppStyle.bodyBsMedium.copyWith(
        color: AppColors.input_label,
      ),
      children: [
        TextSpan(
          text: ' *',
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_brand_primary_variant2,
          ),
        ),
      ],
    ),
  );

  Widget get title2 => RichText(
    text: TextSpan(
      text: 'Vai trò',
      style: AppStyle.bodyBsMedium.copyWith(
        color: AppColors.input_label,
      ),
      children: [
        TextSpan(
          text: ' *',
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_brand_primary_variant2,
          ),
        ),
      ],
    ),
  );
}
