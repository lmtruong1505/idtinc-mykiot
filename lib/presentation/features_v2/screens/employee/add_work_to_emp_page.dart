import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/employee/add_work_to_emp_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/check_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/bts_select_role.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/chip_custom.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../models/role/role_model.dart';
import 'component/branch_item.dart';
import 'component/bts_select_branch.dart';

@RoutePage()
class AddWorkToEmpPage extends StatefulWidget {
  const AddWorkToEmpPage({
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
  State<AddWorkToEmpPage> createState() => _AddWorkToEmpPageState();
}

class _AddWorkToEmpPageState extends State<AddWorkToEmpPage> {
  final bloc = getIt<AddWorkToEmpBloc>();

  final key = GlobalKey<FormState>();

  @override
  void initState() {
    bloc.init(widget.company?.id, widget.roleData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_primary,
      appBar: AppBarTitleCenter(
        title: 'Thông tin công việc',
        leadingText: 'Trở về',
      ),
      body: Container(
        padding: 16.pading.copyWith(bottom: 0),
        child: BlocBuilder<AddWorkToEmpBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            if (state.status == BlocStatus.loading) {
              return const BaseLoading();
            }
            return _buildBody();
          },
        ),
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  _buildBody() {
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCompany(),
            16.height,
            _buildRoles(),
          ],
        ),
      ),
    );
  }

  _buildBottom() {
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
        confirmText: 'Xác nhận',
        cancelText: 'Trở về',
        onCancel: () => context.router.maybePop(),
        onConfirm: () {
          if (!key.currentState!.validate()) {
            return;
          }
          if (!widget.isUpdate) {
            // create new emp
            widget.onAdd?.call(
              WorkingDataModel(
                company: CompanyModel.fromEntity(bloc.company!),
                roleData: bloc.roles,
              ),
            );
            context.router.maybePop(
              WorkingDataModel(
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
      ),
    );
  }

  _buildCompany() {
    if (bloc.company != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
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
          ),
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
          ColumnLabelButton(
            title: 'Cơ sở',
            label: 'Chọn cơ sở',
            isRequire: true,
            backgroundColor: AppColors.bg_primary,
            border: const BorderSide(
              color: AppColors.button_neutral_outlined_borderDefault,
            ),
            labelStyle: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.button_neutral_outlined_textDefault,
            ),
            suffixIcon: const Icon(
              Icons.add,
              size: 17,
              color: AppColors.button_neutral_outlined_textDefault,
            ),
            onPressed: () {
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
    if (bloc.roles.isEmpty) {
      return FormField(
        validator: (value) =>
            bloc.roles.isEmpty ? 'Vui lòng chọn vai trò' : null,
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColumnLabelButton(
              title: 'Vai trò',
              label: 'Chọn vai trò',
              isRequire: true,
              backgroundColor: AppColors.bg_primary,
              border: const BorderSide(
                color: AppColors.button_neutral_outlined_borderDefault,
              ),
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.button_neutral_outlined_textDefault,
              ),
              suffixIcon: const Icon(
                Icons.add,
                size: 17,
                color: AppColors.button_neutral_outlined_textDefault,
              ),
              onPressed: () {
                if (bloc.company == null) {
                  CheckStateBloc.showSnackBar(
                    context,
                    'Vui lòng chọn cơ sở',
                    colorBg: AppColors.red60,
                  );
                  return;
                }
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
        RichText(
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
        ),
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}
