import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/role_v2/role_detail_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/role_v2/components/role_tree_view.dart';
import 'package:pharmago/shared/components/bg/bg_detail.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/empty_container.dart';
import '../../../../base/svg.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../models/role/role_model.dart';
import '../../profile/components/header_item.dart';

class InfoTab extends StatefulWidget {
  const InfoTab({super.key, required this.bloc});

  final RoleDetailBloc bloc;

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> with AutomaticKeepAliveClientMixin {
  final TreeController<RoleListModel> _treeController =
      TreeController(roots: [], childrenProvider: (node) => node.subApp ?? []);

  bool loadFirst = true;

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<RoleDetailBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state.status == BlocStatus.loading) return const BaseLoading();
        return BgDetail(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                4.height,
                const Divider(
                  color: AppColors.border_tertiary,
                  thickness: 1.2,
                ),
                4.height,
                headerItem(
                  prefix: IcSvg.asset('/profile_info.svg'),
                  title: 'Danh sách quyền của vai trò',
                ),
                _buildTree(),
              ],
            ).container(
              boxShadow: AppShadows.elevator0,
              padding: 12.pading,
              radius: 16,
              margin: 16.pading,
            ),
          ),
        );
      },
    );
  }

  Column _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.bloc.model?.role?.title ?? '',
          style: AppStyle.headingMd,
        ),
        Row(
          children: [
            Text(
              widget.bloc.model?.role?.position?.title ?? '',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ).expanded(),
            8.width,
            Text(
              widget.bloc.model?.role?.totalEmployee.toString() ?? '0',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            8.width,
            FaIcon(iconCode: 'f007', type: FaIconType.solid),
          ],
        ),
      ],
    );
  }

  StatelessWidget _buildTree() {
    final list = widget.bloc.filter();
    if (list.isEmpty) return const EmptyContainer();
    _treeController.roots = list;
    return AnimatedTreeView(
      treeController: _treeController..expandAll(),
      shrinkWrap: true,
      padding: 0.pading,
      physics: const NeverScrollableScrollPhysics(),
      duration: 200.milliseconds,
      curve: Curves.linear,
      nodeBuilder: (context, entry) {
        return RoleTreeItem(
          entry: entry,
          onTap: () => _treeController.toggleExpansion(entry.node),
          rebuild: () => {},
          canEdit: false,
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
