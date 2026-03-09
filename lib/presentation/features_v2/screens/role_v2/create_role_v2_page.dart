import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/role_v2/role_create_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/check_state.dart';
import 'package:pharmago/presentation/features_v2/screens/role_v2/components/role_tree_view.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/dialog/dialog_message.dart';
import '../../blocs/position_bloc/position_bloc.dart';
import '../../blocs/role_v2/role_tree_bloc.dart';
import '../../blocs/state/cubit_state.dart';
import '../../models/role/detail_role_model.dart';

@RoutePage()
class CreateRoleV2Page extends StatefulWidget {
  const CreateRoleV2Page({super.key, this.model});

  final DetailRoleModel? model;

  @override
  State<CreateRoleV2Page> createState() => _CreateRoleV2PageState();
}

class _CreateRoleV2PageState extends State<CreateRoleV2Page> {
  final _keyForm = GlobalKey<FormState>();
  final bloc = RoleCreateBloc();
  final positionBloc = PositionBloc();
  final treeBloc = RoleTreeBloc();
  final textCtrl = TextEditingController();

  @override
  void initState() {
    positionBloc.getList();
    treeBloc.getList();
    if (widget.model != null) {
      textCtrl.text = widget.model?.role?.title ?? '';
      bloc.setTitle(widget.model?.role?.title ?? '');
      bloc.setPosition(widget.model!.role?.position?.id ?? -1);
      // print('treeBloc.list: ${treeBloc.list.first.toJson()}');
    }
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    positionBloc.close();
    treeBloc.close();
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: '',
        leadingText: 'Trở về',
      ),
      backgroundColor: AppColors.bg_primary,
      body: Form(
        key: _keyForm,
        child: Container(
          padding: 16.pading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                16.height,
                Text(
                  widget.model != null
                      ? 'Chỉnh sửa vai trò'
                      : 'Tạo mới vai trò',
                  style: AppStyle.heading2xl,
                ),
                36.height,
                InputColumn(
                  label: 'Tên vai trò',
                  hintText: 'Nhập tên vai trò',
                  isRequired: true,
                  controller: textCtrl,
                  padding: 0.pading,
                  onChanged: (value) {
                    bloc.setTitle(value);
                  },
                ),
                16.height,
                BlocBuilder<PositionBloc, CubitState>(
                  bloc: positionBloc,
                  builder: (context, state) {
                     bool canNotEdit = widget.model == null
                        ? false
                        : (widget.model!.items ?? []).isEmpty;
                    if(widget.model != null) {
                      canNotEdit = canNotEdit || (widget.model?.employees ?? []).isNotEmpty;
                    }
                    return IgnorePointer(
                      ignoring: canNotEdit,
                      child: CommonDropdown(
                        borderColor: AppColors.input_borderDefault,
                        color: canNotEdit
                            ? AppColors.input_backgroundDisable
                            : null,
                        radius: 8,
                        value: widget.model?.role?.position?.id,
                        boxShadow: [],
                        showIconRemove: false,
                        label: 'Vị trí làm việc',
                        required: true,
                        items: List.generate(
                          positionBloc.list.length,
                          (index) => DropdownMenuItem(
                            value: positionBloc.list[index].id,
                            child: Text(
                              positionBloc.list[index].title.validator,
                            ),
                          ),
                        ),
                        hintText: 'Chọn vị trí làm việc',
                        onChanged: (value) {
                          if (value != null) {
                            bloc.setPosition(value);
                          }
                        },
                      ),
                    );
                  },
                ),
                24.height,
                RoleTreeView(
                  bloc: treeBloc,
                  filledItem: widget.model?.items ?? [],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  _buildBottom() {
    return BlocBuilder<RoleCreateBloc, CubitState>(
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
          child: DoubleButton(
            cancelText: 'Hủy bỏ',
            confirmText: widget.model != null ? 'Lưu lại' : 'Tạo mới',
            onCancel: () {
              context.pop();
            },
            onConfirm: () {
              if (!_keyForm.currentState!.validate()) return;
              if (widget.model != null) {
                _buildUpdate();
              } else {
                _buildCreate();
              }
            },
          ),
        );
      },
    );
  }

  _buildIcon() {
    if (widget.model != null) {
      return Container(
        padding: 8.pading,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bg_secondary,
        ),
        child: const Icon(
          Icons.edit,
          color: AppColors.fg_tertiary,
        ),
      );
    }
    return IconDiaLog(
      color: AppColors.fg_positive.withOpacity(0.1),
      icon: FaIcon(
        iconCode: 'f0c0',
        color: AppColors.fg_positive,
        type: FaIconType.solid,
        size: 24,
      ),
    );
  }

  void _buildCreate() {
    bloc
        .createRole(
      treeBloc.list,
    )
        .then((value) {
      if (value.code == 200) {
        context.pop(result: true);
        ToastCustom.show(
          context,
          title: 'Thành công',
          msg: 'Tạo mới vai trò thành công',
          svgIcon: Assets.iconsSuccess,
          color: AppColors.ultility_brand_60,
          timeClose: 2.seconds,
          route: value.data is int
              ? DetailRoleV2Route(id: value.data as int)
              : null,
        );
      } else {
        CheckStateBloc.showSnackBar(
          context,
          value.message ?? 'Tạo mới vai trò không thành công',
          colorBg: AppColors.fg_negative,
        );
      }
    });
  }

  void _buildUpdate() {
    bloc
        .updateRole(
      treeBloc.list,
      widget.model!.role!.id ?? -1,
    )
        .then((value) {
      if (value.code == 200) {
        CheckStateBloc.showSnackBar(
          context,
          'Cập nhật vai trò thành công',
          colorBg: AppColors.fg_positive,
        );
        context.pop(result: true);
      } else {
        CheckStateBloc.showSnackBar(
          context,
          value.message ?? 'Cập nhật vai trò không thành công',
          colorBg: AppColors.fg_negative,
        );
      }
    });
  }
}
