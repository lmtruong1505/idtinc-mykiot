import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/position_bloc/position_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/position/position_model.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/filter_item.dart';
import '../../../../base/loading.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/state/cubit_state.dart';

// ignore: must_be_immutable
class BtsFilterRoles extends StatefulWidget {
   BtsFilterRoles({super.key, this.position, required this.onChange});

  int? position;
  final Function(
    int? position,
  ) onChange;

  @override
  State<BtsFilterRoles> createState() => _BtsFilterRolesState();
}

class _BtsFilterRolesState extends State<BtsFilterRoles> {
  final positionBloc = PositionBloc();

  @override
  void initState() {
    positionBloc.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.onChange(
          null,
        );
        context.pop();
      },
      onConfirm: () {
        widget.onChange(
          widget.position,
        );
        context.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<PositionBloc, CubitState>(
            bloc: positionBloc,
            builder: (context, state) {
              if (state.status == BlocStatus.loading) {
                return const BaseLoading();
              }
              final list = [
                PositionModel(
                  title: 'Tất cả',
                ),
                ...positionBloc.list,
              ];
              final index = widget.position == null
                  ? 0
                  : list.indexWhere((element) => element.id == widget.position);
              return FilterItem(
                label: 'Vị trí làm việc',
                select: index,
                items: list.map((e) => e.title.validator).toList(),
                onTap: (p0) {
                  widget.position = list[p0].id;
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
