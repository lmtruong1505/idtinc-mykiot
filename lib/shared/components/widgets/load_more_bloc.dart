import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/base/empty_container.dart';
import '../../../presentation/features_v2/blocs/enum/bloc_status.dart';
import '../../../presentation/features_v2/blocs/state/cubit_state.dart';

typedef ItemWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  ItemType item,
  int index,
);

class LoadMoreListBloc<T> extends StatelessWidget {
  final CubitState state;
  final List<T> list;
  final ItemWidgetBuilder<T> itemBuilder;
  final Widget? emptyViewAll;
  final Widget? emptyView;
  final Widget? separatorBuilder;
  final double? height;
  final ScrollPhysics? physics;
  final Widget? headerView;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final int sizePage;
  final bool isEmptyAll;
  final double? spaceBottom;

  const LoadMoreListBloc({
    required this.state,
    required this.list,
    required this.itemBuilder,
    this.height = 200,
    this.emptyView,
    this.emptyViewAll,
    this.separatorBuilder,
    this.physics,
    this.headerView,
    this.padding,
    this.controller,
    this.sizePage = 20,
    this.spaceBottom,
    this.isEmptyAll = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmptyAll && state.status == BlocStatus.success && list.isEmpty) {
      return emptyViewAll ?? const EmptyContainer();
    }
    return SingleChildScrollView(
      physics: physics,
      padding: padding ?? 16.pading,
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (headerView != null && !state.isFirst) headerView!,
          if (list.isEmpty && state.status == BlocStatus.loading) _loadView(),
          if (list.isEmpty && state.status == BlocStatus.success)
            emptyView ?? const EmptyContainer(),
          if (list.isNotEmpty) _buildBody(),
          if (sizePage <= list.length) _loadmoreView(),
          if (sizePage <= list.length) context.padding.bottom.height,
          if (spaceBottom != null && sizePage > list.length)
            spaceBottom!.height,
        ],
      ),
    );
  }

  Widget _loadmoreView() {
    return SizedBox(
      height: 50,
      child: list.isNotEmpty && state.status == BlocStatus.loading
          ? const BaseLoading(
              height: 50,
            )
          : null,
    );
  }

  Widget _loadView() {
    return const Center(
      child: BaseLoading(),
    ).size(
      height: height,
    );
  }

  Widget _buildBody() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => itemBuilder(context, list[index], index),
      separatorBuilder: (context, index) => separatorBuilder ?? 16.height,
      itemCount: list.length,
    );
  }
}
