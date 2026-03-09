import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../cubit/workspace_associate_cubit/workspace_associate_cubit.dart';
import '../../cubit/workspace_associate_cubit/workspace_associate_state.dart';
import '../../data/models/associate_model.dart';

class WorkspaceAssociateDialog extends StatefulWidget {
  const WorkspaceAssociateDialog({
    super.key,
    this.data,
    this.callBack,
  });

  final AssociateModel? data;
  final Function(AssociateModel?)? callBack;

  @override
  State<WorkspaceAssociateDialog> createState() =>
      _WorkspaceAssociateDialogState();

  static void show(
    BuildContext context, {
    AssociateModel? data,
    Function(AssociateModel?)? callBack,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(sp16),
            ),
            color: AppColors.bg_white,
            margin: const EdgeInsets.all(sp16),
            child: WorkspaceAssociateDialog(
              data: data,
              callBack: callBack,
            ),
          ),
        );
      },
    );
  }
}

class _WorkspaceAssociateDialogState extends State<WorkspaceAssociateDialog> {
  final _searchCtl = TextEditingController();
  final _associateCubit = getIt.get<WorkspaceAssociateCubit>();
  AssociateModel? _associateSelected;
  Timer? _searchTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkspaceAssociateCubit>(
      create: (context) => _associateCubit..getListAssociate(getCompany!),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: heightDevice(context) / 3 * 2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(sp16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn nhà thuốc liên kết',
                    style: s16w700.copyWith(
                      color: AppColors.text_primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const CircleAvatar(
                      radius: sp12,
                      backgroundColor: black5o,
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.icon_iconPrimary,
                        size: sp16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: sp32),
              AppInputV2(
                controller: _searchCtl,
                hintText: 'Tìm kiếm',
                radius: sp80,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchCtl.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () => _searchCtl.clear(),
                        child: const Icon(Icons.close_rounded),
                      ),
                onChanged: (p0) {
                  setState(() {
                    _associateSelected = null;
                  });
                  if (_searchTimer != null) {
                    _searchTimer?.cancel();
                  }
                  _searchTimer = Timer(
                    const Duration(seconds: 1),
                    () {
                      _associateCubit.getListAssociate(getCompany!, search: p0);
                    },
                  );
                  _searchTimer;
                },
              ),
              sp16.height,
              BlocSelector<WorkspaceAssociateCubit, WorkspaceAssociateState,
                  List<AssociateModel>>(
                selector: (state) {
                  return state.wsAssociates;
                },
                builder: (context, wsAssociates) {
                  return BlocSelector<WorkspaceAssociateCubit, WorkspaceAssociateState, bool>(
                    selector: (state) {
                      return state.isLoading;
                    },
                    builder: (context, isLoading) {
                      if (isLoading) return const BaseLoading();
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: sp12,
                          children: wsAssociates.map((e) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _associateSelected = e;
                                });
                              },
                              child: AnimatedContainer(
                                padding: const EdgeInsets.all(sp12),
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(sp8),
                                  color: e.workspaceAssociate?.id ==
                                          _associateSelected
                                              ?.workspaceAssociate?.id
                                      ? AppColors.bg_primary_active
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.workspaceAssociate?.name ?? '',
                                          style: s16w500.copyWith(
                                            color: AppColors.text_primary,
                                          ),
                                        ),
                                        Text(
                                          e.workspaceAssociate?.codeAssociate ??
                                              '',
                                          style: s14w500.copyWith(
                                            color: AppColors.blue60,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Visibility(
                                      visible: e.workspaceAssociate?.id ==
                                          _associateSelected
                                              ?.workspaceAssociate?.id,
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: AppColors.green50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
              sp16.height,
              DoubleButton(
                cancelText: 'Mặc định',
                confirmText: 'Xác nhận',
                onCancel: () {
                  widget.callBack?.call(null);
                  context.pop();
                },
                onConfirm: () {
                  widget.callBack?.call(_associateSelected);
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
