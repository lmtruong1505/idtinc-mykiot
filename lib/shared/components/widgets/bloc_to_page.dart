import 'package:flutter/material.dart';
import 'package:pharmago/generated/assets.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/features_v2/blocs/enum/bloc_status.dart';
import '../../../presentation/features_v2/blocs/state/cubit_state.dart';

class LoadListPage extends StatelessWidget {
  final CubitState state;
  final Widget child;
  final Widget? emptyView;
  final bool listEmpty;
  final double? height;

  const LoadListPage({
    required this.state,
    required this.child,
    this.listEmpty = false,
    this.height,
    this.emptyView,
  });

  @override
  Widget build(BuildContext context) {
    if (listEmpty && state.status == BlocStatus.loading) {
      return const Center(
        child: BaseLoading(),
      ).size(
        height: height,
      );
    }
    if (listEmpty && state.status == BlocStatus.success) {
      return emptyView ??
          Column(
            children: [
              const EmptyContainer().padding(16.padingVer),
            ],
          );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        child,
        SizedBox(
          height: 50,
          child: !listEmpty && state.status == BlocStatus.loading
              ? const BaseLoading(
                  height: 50,
                )
              : null,
        ),
        //context.padding.bottom.height,
      ],
    );
  }
}

Widget LoadPage({
  required CubitState state,
  Widget? child,
  Widget? loadChild,
  Widget? errorView,
  double? height = 200,
  bool listEmpty = false,
}) {
  switch (state.status) {
    case BlocStatus.loading:
      return loadChild ??
          BaseLoading(
            height: height,
          );

    case BlocStatus.failure:
      return errorView ??
          EmptyContainer(
            msg: state.msg,
            svgAsset: Assets.svgWarningOutline,
          );
    default:
      if (listEmpty) {
        return const EmptyContainer();
      }
      return child ?? const SizedBox();
  }
}
