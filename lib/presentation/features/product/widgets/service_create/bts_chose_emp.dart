import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/employee/employee/cubit/employee_cubit.dart';
import 'package:pharmago/presentation/features/employee/employee/cubit/employee_state.dart';

import '../../../../base/empty_container.dart';
import '../../../../base/infinite_list.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../employee/employee/domain/entities/employee_entity.dart';

class BTSChoseEmp extends StatefulWidget {
  const BTSChoseEmp({
    this.staffSelected,
    this.onConfirm,
    super.key, this.onRemove,
  });

  final EmployeeEntity? staffSelected;
  final Function(EmployeeEntity? value)? onConfirm;
  final Function()? onRemove;

  @override
  State<BTSChoseEmp> createState() => _BTSChoseEmpState();
}

class _BTSChoseEmpState extends State<BTSChoseEmp> {

  final _staffBloc = getIt.get<EmployeeCubit>();

  EmployeeEntity? _staffEntity;

  @override
  void initState() {
    super.initState();

    _staffEntity = widget.staffSelected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeCubit>(
      create: (context) => _staffBloc,
      child: Container(
        height: double.infinity,
        color: whiteColor,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách nhân viên',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _staffEntity = null;
                        widget.onRemove?.call();
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Chọn lại',
                          style: p3.copyWith(color: blue_1),
                        ),
                        const Icon(
                          Icons.refresh,
                          color: blue_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gapHeight(sp16),
              AppInputSupport(
                hintText: 'Tìm kiếm nhân viên',
                prefixIcon: const Icon(Icons.search_rounded),
                onChanged: _staffBloc.changeSearch,
                onConfirm: (p0) => _staffBloc.entityILC.onRefresh(),
                backgroundColor: whiteColor,
              ),
              gapHeight(sp16),
              BlocBuilder<EmployeeCubit, EmployeeState>(
                builder: (context, state) {
                  return InfiniteList<EmployeeEntity>(
                    shrinkWrap: true,
                    getData: (page) async {
                      final res = await _staffBloc.getList(page);
                      return res;
                    },
                    itemBuilder: (context, item, index) =>
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(sp12),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _staffEntity = item;
                              });
                              widget.onConfirm?.call(_staffEntity);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(sp16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _staffEntity?.id == item.id
                                      ? mainColor
                                      : greyColor,
                                ),
                                borderRadius: BorderRadius.circular(sp12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        item.fullName ?? '',
                                        style: p3.copyWith(color: blackColor),
                                      ),
                                      gapHeight(sp8),
                                      Text(
                                        item.phoneNumber ?? '',
                                        style: p5.copyWith(color: greyColor),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: _staffEntity?.id == item.id,
                                    child: const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    scrollController: _staffBloc.scrollController,
                    infiniteListController: _staffBloc.entityILC,
                    noItemFoundWidget: const EmptyContainer(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
