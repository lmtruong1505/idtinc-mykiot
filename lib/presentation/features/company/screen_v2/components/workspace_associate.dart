import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features/company/data/models/associate_model.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/button/main_button.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/asset_path.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../cubit/workspace_associate_cubit/workspace_associate_cubit.dart';
import '../../cubit/workspace_associate_cubit/workspace_associate_state.dart';
import '../../data/models/company_model.dart';

class WorkspaceAssociate extends StatefulWidget {
  const WorkspaceAssociate({
    super.key,
    required this.workspace,
  });

  final int workspace;

  @override
  State<WorkspaceAssociate> createState() => _WorkspaceAssociateState();
}

class _WorkspaceAssociateState extends State<WorkspaceAssociate> {
  final _cubitAssociate = getIt.get<WorkspaceAssociateCubit>();
  final _searchCtl = TextEditingController();
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubitAssociate..getListAssociate(widget.workspace),
      child:
          BlocSelector<WorkspaceAssociateCubit, WorkspaceAssociateState, bool>(
        selector: (state) {
          return state.isLoading;
        },
        builder: (context, isLoading) {
          return BlocSelector<WorkspaceAssociateCubit, WorkspaceAssociateState,
              List<AssociateModel>>(
            selector: (state) {
              return state.wsAssociates;
            },
            builder: (context, wsAssociates) {
              if (isLoading) return const BaseLoading();
              return wsAssociates.isEmpty && _searchCtl.text.isEmpty
                  ? _emptyView
                  : _listView(wsAssociates);
            },
          );
        },
      ),
    );
  }

  Widget get _emptyView {
    return Column(
      children: [
        const EmptyContainer(
          msg: 'Chưa có workspace liên kết',
        ),
        MainButtonV2(
          title: 'Thêm mới',
          icon: const Icon(
            Icons.add_rounded,
            size: sp16,
          ),
          radius: sp48,
          onTap: _addAssociateHanle,
        ),
      ],
    );
  }

  Widget _listView(List<AssociateModel> wsAssociates) {
    return Padding(
      padding: const EdgeInsets.all(sp16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppInputV2(
                  controller: _searchCtl,
                  hintText: 'Tìm kiếm',
                  radius: sp24,
                  prefixIcon: const Icon(Icons.search_rounded),
                  backgroundColor: AppColors.bg_white,
                  onChanged: (p0) {
                    setState(() {});
                    if (_searchTimer != null) {
                      _searchTimer?.cancel();
                    }
                    _searchTimer = Timer(
                      const Duration(seconds: 1),
                      () {
                        _cubitAssociate.getListAssociate(
                          widget.workspace,
                          search: _searchCtl.text,
                        );
                      },
                    );
                    _searchTimer;
                  },
                  suffixIcon: _searchCtl.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchCtl.clear();
                              _cubitAssociate
                                  .getListAssociate(widget.workspace);
                            });
                          },
                          child: const Icon(Icons.close_rounded),
                        )
                      : null,
                ),
              ),
              sp12.width,
              GestureDetector(
                onTap: _addAssociateHanle,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border_primary),
                    borderRadius: BorderRadius.circular(sp48),
                  ),
                  child: const CircleAvatar(
                    radius: sp24,
                    backgroundColor: AppColors.bg_white,
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColors.icon_iconPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          sp16.height,
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final data = wsAssociates[index];
                return Slidable(
                  key: Key(data.associateCode!),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        flex: 1,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(sp12),
                          bottomRight: Radius.circular(sp12),
                        ),
                        onPressed: (context) {
                          toastification.show(
                            title: const Text('Đang thiết lập liên kết'),
                            type: ToastificationType.info,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                          _cubitAssociate.connectWsAssociate(
                            workspace: data.workspace!.id!,
                            workspaceAssociate: data.workspaceAssociate!.id!,
                            isConnect: !data.connected,
                          );
                        },
                        backgroundColor: data.connected ? red_1 : green_1,
                        foregroundColor: whiteColor,
                        label: data.connected ? 'Huỷ' : 'Kết nối',
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(sp16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp12),
                      color: AppColors.bg_white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.bg_black.withOpacity(0.1),
                          offset: Offset(0, 1),
                          blurRadius: 1,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              data.workspaceAssociate?.typeName ?? '_',
                              style: s12w400.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                            sp8.width,
                            CircleAvatar(
                              radius: sp4,
                              backgroundColor:
                                  data.workspaceAssociate?.status == 'ACTIVE'
                                      ? AppColors.green50
                                      : AppColors.red50,
                            ),
                            const Spacer(),
                            ChipCustom(
                              color: data.connected
                                  ? AppColors.green50
                                  : AppColors.red50,
                              title: data.connected
                                  ? 'Đang kết nối'
                                  : 'Ngưng kết nối',
                            ),
                          ],
                        ),
                        Text(
                          data.workspaceAssociate?.name ?? '_',
                          style:
                              s16w700.copyWith(color: AppColors.text_primary),
                        ),
                        Text(
                          'Mã liên kết: ${data.workspaceAssociate?.codeAssociate}',
                          style:
                              s14w400.copyWith(color: AppColors.text_secondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => sp16.height,
              itemCount: wsAssociates.length,
            ),
          ),
        ],
      ),
    );
  }

  void _addAssociateHanle() {
    WorkspaceAssociateConnectDialog.show(
      context,
      callBack: (workspaceAssociate) async {
        toastification.show(
          title: const Text('Đang thiết lập liên kết'),
          type: ToastificationType.info,
          autoCloseDuration: const Duration(seconds: 3),
        );
        final data = await _cubitAssociate.connectWsAssociate(
          workspace: widget.workspace,
          workspaceAssociate: workspaceAssociate,
        );
        if (data == null) {
          toastification.show(
            title: const Text('Workspace đã được liên kết trước đó'),
            type: ToastificationType.warning,
            autoCloseDuration: const Duration(seconds: 3),
          );
        } else {
          toastification.show(
            title: const Text('Liên kết thành công'),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
          );
          if (mounted) {
            context.pop();
          }
        }
      },
      searchCallBack: _cubitAssociate.findWsByAssociateCode,
    );
  }
}

class WorkspaceAssociateConnectDialog extends StatefulWidget {
  const WorkspaceAssociateConnectDialog({
    super.key,
    this.callBack,
    this.searchCallBack,
  });

  final Function(int workspaceAssociate)? callBack;
  final Future<CompanyModel?> Function(String code)? searchCallBack;

  static void show(
    BuildContext context, {
    Function(int workspaceAssociate)? callBack,
    Future<CompanyModel?> Function(String code)? searchCallBack,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(sp16).copyWith(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(sp24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(sp16),
                child: WorkspaceAssociateConnectDialog(
                  callBack: callBack,
                  searchCallBack: searchCallBack,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<WorkspaceAssociateConnectDialog> createState() =>
      _WorkspaceAssociateConnectDialogState();
}

class _WorkspaceAssociateConnectDialogState
    extends State<WorkspaceAssociateConnectDialog> {
  CompanyModel? company;
  String? errMsg;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              radius: sp12,
              backgroundColor: black5o,
              child: FaIcon(
                iconCode: 'f00d',
              ),
            ),
          ),
        ),
        Image.asset(
          '${AssetsPath.image}/setting.png',
        ),
        const Text(
          'Thiết lập liên kết Workspace',
          style: s20w700,
          textAlign: TextAlign.center,
        ),
        sp16.height,
        InputColumn(
          padding: const EdgeInsets.all(sp0),
          label: 'Nhập mã workspace',
          hintText: 'Nhập mã code workspace',
          radius: sp16,
          isRequired: true,
          suffixIcon: isLoading
              ? const SizedBox(
                  height: sp20,
                  width: sp20,
                  child: Center(
                    child: BaseLoading(),
                  ),
                )
              : const Icon(
                  Icons.search_rounded,
                  size: sp16,
                ),
          onChanged: (p0) {
            setState(() {
              errMsg = null;
              company = null;
              isLoading = false;
            });
          },
          onConfirm: (p0) async {
            setState(() {
              errMsg = null;
              company = null;
              isLoading = true;
            });
            final companySearch = await widget.searchCallBack?.call(p0);
            if (companySearch == null) {
              errMsg = 'not found';
            } else {
              company = companySearch;
            }
            isLoading = false;
            setState(() {});
          },
        ),
        sp16.height,
        if (company != null || errMsg != null) ...[
          Row(
            children: [
              Text(
                'Kết quả tìm kiếm',
                style: s12w400.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              const Expanded(
                child: Divider(
                  color: AppColors.border_primary,
                ),
              ),
            ],
          ),
          if (company == null)
            const EmptyContainer(
              msg: 'Không có dữ liệu khả dụng liên quan đến từ khóa bạn dùng',
            )
          else
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.border_primary_onBrand,
                radius: sp20,
                child: Image.asset(
                  '${AssetsPath.image}/pharmago_v2.png',
                  width: sp40,
                  fit: BoxFit.cover,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChipCustom(
                      color: company?.status == 'ACTIVE'
                          ? AppColors.green50
                          : AppColors.red50,
                      title: company?.statusName ?? '',
                    ),
                  ),
                  Text(
                    company?.name ?? '',
                    style: s16w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              subtitle: Text(
                company?.typeName ?? '',
                style: s14w400.copyWith(color: AppColors.text_secondary),
              ),
            ),
        ],
        DoubleButton(
          cancelText: 'Huỷ bỏ',
          confirmText: 'Liên kết',
          onCancel: () {
            context.pop();
          },
          onConfirm: company == null
              ? null
              : () {
                  widget.callBack?.call(company!.id!);
                  // context.pop();
                },
        ).size(height: 48),
      ],
    );
  }
}
