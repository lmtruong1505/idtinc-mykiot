import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/bg/bg_bts.dart';

import 'package:flutter/material.dart';

import '../../../../features/branch/bloc/branch_management_bloc/branch_management_bloc.dart';
import '../../../../features/company/domain/entities/company_entity.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/role/list_role_bloc.dart';
import '../../../models/role/role_model.dart';

// ignore: must_be_immutable
class BtsFilterEmp extends StatefulWidget {
  BtsFilterEmp({
    super.key,
    required this.onChange,
    this.status,
    this.role,
    this.branch,
  });

  EmployeeStatus? status;
  int? role;
  int? branch;

  Function({
    EmployeeStatus? status,
    int? role,
    int? branch,
  }) onChange;

  @override
  State<BtsFilterEmp> createState() => _BtsFilterEmpState();
}

class _BtsFilterEmpState extends State<BtsFilterEmp> {
  late ListRoleBloc roleBloc;
  final branchBloc = getIt<BranchManagementBloc>();

  @override
  void initState() {
    roleBloc = context.read<ListRoleBloc>();
    roleBloc.list.clear();
    roleBloc.getList();
    branchBloc.getList(isAll: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.onChange(
          status: null,
          role: null,
          branch: null,
        );
        context.pop();
      },
      onConfirm: () {
        widget.onChange(
          status: widget.status,
          role: widget.role,
          branch: widget.branch,
        );
        context.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<ListRoleBloc, CubitState>(
            builder: (context, state) {
              if (state.status == BlocStatus.loading) {
                return const BaseLoading();
              }
              final list = [
                RoleListModel(
                  title: 'Tất cả',
                ),
                ...roleBloc.list,
              ];
              final index = widget.role == null
                  ? 0
                  : list.indexWhere((element) => element.id == widget.role);
              return FilterItem(
                label: 'Vai trò',
                select: index,
                items: list.map((e) => e.title.validator).toList(),
                onTap: (p0) {
                  widget.role = list[p0].id;
                  setState(() {});
                },
              );
            },
          ),
          16.height,
          FilterItem(
            label: 'Trạng thái',
            select: widget.status == null
                ? 0
                : EmployeeStatus.values.indexOf(
                    widget.status!,
                  ),
            items: EmployeeStatus.values.map((e) => e.title.validator).toList(),
            onTap: (p0) {
              widget.status = EmployeeStatus.values[p0];
              setState(() {});
            },
          ),
          16.height,
          BlocBuilder<BranchManagementBloc, CubitState>(
            bloc: branchBloc,
            builder: (context, state) {
              if (state.status == BlocStatus.loading) {
                return const BaseLoading();
              }
              final list = [
                CompanyEntity(
                  name: 'Tất cả',
                ),
                ...branchBloc.list,
              ];
              final index = widget.branch == null
                  ? 0
                  : list.indexWhere((element) => element.id == widget.branch);
              return FilterItem(
                label: 'Cơ sở',
                select: index,
                items: list.map((e) => e.name.validator).toList(),
                onTap: (p0) {
                  widget.branch = list[p0].id;
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
