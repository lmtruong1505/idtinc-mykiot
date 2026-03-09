import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/app_input.dart';
import '../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../shared/utils/delay_callback.dart';
import '../../../../base/empty_container.dart';
import '../../../../base/loading.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../di/di.dart';
import '../../../../features/branch/bloc/branch_staff_bloc/list_staff_branch_bloc.dart';
import '../../../../features/branch/data/entities/branch_emp_entity.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/state/cubit_state.dart';
import 'assign_emp_item.dart';

class BtsAssignEmp extends StatefulWidget {
  const BtsAssignEmp({super.key, required this.id, this.onSelected});

  final List<int> id;
  final Function(List<BranchEmpEntity>)? onSelected;

  @override
  State<BtsAssignEmp> createState() => _BtsAssignEmpState();
}

class _BtsAssignEmpState extends State<BtsAssignEmp> {
  List<BranchEmpEntity> emps = [];
  final delay = DelayCallBack(delay: 500.milliseconds);
  final textCtrl = TextEditingController();
  final scroll = ScrollController();
  final bloc = getIt<ListStaffBranchBloc>();

  @override
  void initState() {
    bloc.company = getCompany;
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
    super.initState();
  }

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Gán nhân viên',
      subChild: emps.isEmpty ? null : _buildCount(),
      cancelText: 'Hủy',
      confirmText: 'Xác nhận',
      onCancel: () {
        context.pop();
      },
      onConfirm: () {
        widget.onSelected?.call(emps);
        context.pop();
      },
      child: SingleChildScrollView(
        controller: scroll,
        child: Column(
          children: [
            _buildSearch(),
            16.height,
            _buildList(),
          ],
        ),
      ),
    );
  }

  BlocBuilder<ListStaffBranchBloc, CubitState> _buildList() {
    return BlocBuilder<ListStaffBranchBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const Center(
            child: BaseLoading(),
          );
        }
        if (bloc.list.isEmpty) {
          return const EmptyContainer(
            msg: 'Không tìm thấy',
          );
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return
             AssignEmpItem(
              emp: bloc.list[index],
              isSelected: checkIfSelected(bloc.list[index].employee?.id ?? -1),
              onToggle: (value) {
                if (value && !checkIfSelected(bloc.list[index].employee?.id ?? -1)) {
                  emps.add(bloc.list[index]);
                } else {
                  emps.removeWhere(
                      (element) => element.employee?.id == bloc.list[index].employee?.id);
                }
                setState(() {});
              },
            );
          },
          separatorBuilder: (context, index) => 0.height,
          itemCount: bloc.list.length,
        );
      },
    );
  }

  bool checkIfSelected(int id) {
    return emps.indexWhere((element) => element.employee?.id == id) != -1;
  }

  SizedBox _buildSearch() {
    return AppInputV2(
      hintText: 'Tìm kiếm tên, số điện thoại nhân viên',
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      suffixIcon: InkWell(
        onTap: () {
          textCtrl.clear();
          bloc.changeSearch('');
        },
        child: const Icon(
          Icons.clear_outlined,
          size: 16,
        ),
      ),
      controller: textCtrl,
      radius: 40,
      contentPadding: 12.padingHor,
      onChanged: (value) {
        delay.debounce(() {
          bloc.changeSearch(value);
        });
      },
    ).size(height: 40);
  }

  Container _buildCount() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border_tertiary,
            width: 1,
          ),
        ),
      ),
      margin: 16.padingHor,
      padding: 12.padingTop + 8.padingBottom,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Đã chọn: ',
              style: AppStyle.bodyBsRegular
                  .copyWith(color: AppColors.text_tertiary),
            ),
            TextSpan(
              text: '(${emps.length})',
              style: AppStyle.headingMd,
            ),
          ],
        ),
      ),
    );
  }
}
