import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/role_v2/components/role_info_popup.dart';
import 'package:pharmago/presentation/features_v2/screens/role_v2/tab/info_tab.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../shared/components/dialog/dialog_message.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../config/role/check_role_per.dart';
import '../../../config/role/permission/index.dart';
import '../../blocs/role_v2/role_detail_bloc.dart';
import '../../blocs/state/check_state.dart';
import 'tab/emp_tab.dart';

@RoutePage()
class DetailRoleV2Page extends StatefulWidget {
  const DetailRoleV2Page({super.key, required this.id, this.refresh});

  final int id;
  final VoidCallback? refresh;

  @override
  State<DetailRoleV2Page> createState() => _DetailRoleV2PageState();
}

class _DetailRoleV2PageState extends State<DetailRoleV2Page> {
  final bloc = RoleDetailBloc();
  bool canEdit = isOwnerWsCsMn && checkPermission(PerRoleEnum.EDIT.code);
  bool canDelete = isOwnerWsCsMn && checkPermission(PerRoleEnum.DELETE.code);

  @override
  void initState() {
    bloc.getDetail(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCustom(
          title: 'Quản lý vai trò',
          subTitle: 'Thông tin vai trò',
          actions: [
            BlocBuilder<RoleDetailBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                if(bloc.model?.role?.isDefault ?? false) return const SizedBox();
                return RoleInfoPopup(
                  child: IconBtn(
                    backgroundColor: AppColors.bg_primary,
                    icon: const Icon(
                      Icons.more_vert,
                      size: 15,
                    ),
                  ),
                  onTap: (value) {
                    switch (value) {
                      case RoleInfoEvent.edit:
                        if(!canEdit) {
                          context.permissionDenied()();
                          return;
                        }
                        context.router.push(CreateRoleV2Route(model: bloc
                            .model)).then((value) {
                          if (value != null && value == true) {
                            bloc.getDetail(widget.id);
                            widget.refresh?.call();
                          }
                        });
                        break;
                      case RoleInfoEvent.delete:
                        if(!canDelete) {
                          context.permissionDenied()();
                          return;
                        }
                        _buildDialog();
                        break;
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Container(
          height: 45,
          padding: 20.padingHor,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border_tertiary),
            ),
          ),
          child: TabBar(
            labelStyle: AppStyle.bodyBsMedium.copyWith(height: 1.2),
            labelColor: AppColors.text_primary,
            unselectedLabelStyle: AppStyle.bodyBsRegular.copyWith(height: 1.2),
            unselectedLabelColor: AppColors.text_tertiary,
            indicatorColor: AppColors.border_primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            tabs: const [
              Tab(
                text: 'Thông tin chi tiết',
              ),
              Tab(
                text: 'Danh sách nhân viên',
              ),
            ],
          ),
        ),
        TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InfoTab(
              bloc: bloc,
            ),
            EmpTab(
              bloc: bloc,
              onSuccess: () {
                widget.refresh?.call();
              },
            ),
          ],
        ).expanded(),
      ],
    );
  }

  void _buildDialog() {
    context.dialog(
      DialogConfirm(
        title: 'Xác nhận xóa vai trò',
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Bạn có chắc chắn muốn xóa vai trò ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
            children: [
              TextSpan(
                text: bloc.model!.role?.title.validator.toLowerCase(),
                style: AppStyle.bodyBsSemiBold.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              TextSpan(
                text: ' không?',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
            ],
          ),
        ),
        actionConfirmBorder: true,
        colorConfirmBtn: AppColors.button_negative_outlined_textDefault,
        icon: IconDiaLog(
          color: AppColors.fg_negative.withOpacity(0.1),
          icon: const Icon(
            Icons.delete,
            color: AppColors.fg_negative,
            size: 32,
          ),
        ),
        confirm: () {
          bloc.delete(widget.id).then((value) {
            context.pop();
            if (value.code == 200) {
              CheckStateBloc.showSnackBar(
                context,
                'Xóa vai trò thành công',
              );
              context.pop(result: true);
            } else {
              context.dialog(
                DialogMessage(
                  title: 'Thông báo',
                  content: value.message ?? 'Xóa vai trò không thành công',
                  isError: true,
                ),
              );
            }
          });
        },
      ),
    );
  }
}
