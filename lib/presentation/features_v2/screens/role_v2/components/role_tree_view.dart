import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../base/check_box.dart';
import '../../../../base/empty_container.dart';
import '../../../../base/loading.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/role_v2/role_tree_bloc.dart';
import '../../../blocs/state/init_state.dart';
import '../../../models/role/role_model.dart';

class RoleTreeView extends StatefulWidget {
  const RoleTreeView({super.key, required this.bloc, required this.filledItem});

  final RoleTreeBloc bloc;
  final List<RoleListModel> filledItem;

  @override
  State<RoleTreeView> createState() => _RoleTreeViewState();
}

class _RoleTreeViewState extends State<RoleTreeView> {
  bool loadFirst = true;
  late final TreeController<RoleListModel> _treeController;

  @override
  void initState() {
    //  print('RoleTreeView initState ${widget.bloc.list.first.toJson()}');
    super.initState();
  }

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleTreeBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const Center(
            child: BaseLoading(),
          );
        }
        if (widget.bloc.list.isEmpty) {
          return const EmptyContainer();
        }
        if (loadFirst) {
          widget.bloc.setList(widget.filledItem);
          _treeController = TreeController<RoleListModel>(
            roots: widget.bloc.list,
            childrenProvider: (node) => node.subApp ?? [],
          );
          loadFirst = false;
        }
        return Container(
          width: double.infinity,
          padding: 12.pading,
          decoration: BoxDecoration(
            borderRadius: 12.radius,
            border: Border.all(
              width: 1,
              color: AppColors.border_tertiary,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Phân quyền vai trò',
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ).expanded(),
                  8.width,
                  BaseCheckbox2(
                    value: widget.bloc.all,
                    error: true,
                    onChanged: (value) {
                      widget.bloc.changeAll(value ?? false);
                    },
                  ),
                  8.width,
                  Text(
                    'Chọn tất cả',
                    style: AppStyle.bodyBsMedium,
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              _buildTree(),
            ],
          ),
        );
      },
    );
  }

  AnimatedTreeView<RoleListModel> _buildTree() {
    return AnimatedTreeView(
      shrinkWrap: true,
      treeController: _treeController,
      physics: const NeverScrollableScrollPhysics(),
      duration: 200.milliseconds,
      curve: Curves.linear,
      nodeBuilder: (context, entry) {
        // if(entry.hasChildren) {
        //   if(entry.node.subApp?.any((element) => element.value == true) ?? false) {
        //     _treeController.expand(entry.node);
        //   }
        // }
        return RoleTreeItem(
          entry: entry,
          key: Key(entry.node.id.toString()),
          onTap: () {
            _treeController.toggleExpansion(entry.node);
          },
          rebuild: () {
            widget.bloc.reload();
          },
        );
      },
    );
  }
}

class RoleTreeItem extends StatelessWidget {
  const RoleTreeItem({
    super.key,
    required this.entry,
    required this.onTap,
    required this.rebuild,
    this.canEdit = true,
  });

  final TreeEntry<RoleListModel> entry;
  final VoidCallback onTap;
  final VoidCallback rebuild;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      guide: const IndentGuide.connectingLines(
        indent: 40,
        roundCorners: true,
        thickness: 1,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        child: Row(
          children: [
            if (canEdit)
              BaseCheckbox2(
                value: entry.node.value,
                error: entry.hasChildren,
                onChanged: (value) {
                  if (entry.hasChildren) {
                    entry.node.value = value ?? false;
                    for (final child in entry.node.subApp ?? []) {
                      child.value = value;
                    }
                  } else {
                    final parent = entry.parent;
                    entry.node.value = value;
                    if (parent != null) {
                      bool val = true;
                      bool flag = false;
                      for (final element in parent.node.subApp ?? []) {
                        val = val && (element.value ?? false);
                        flag = flag || (element.value ?? false);
                      }
                      final bool? q = val ? true : flag ? null : false;
                      parent.node.value = q;
                    }
                  }
                  rebuild();
                },
              ),
            8.width,
            InkWell(
              onTap: onTap,
              child: Text(
                entry.node.title ?? '',
                style: AppStyle.bodyBsMedium,
              ),
            ).expanded(),
            8.width,
            if (entry.hasChildren)
              InkWell(
                onTap: onTap,
                child: FaIcon(
                  iconCode: entry.isExpanded ? 'f0d7' : 'f0d8',
                  type: FaIconType.solid,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
