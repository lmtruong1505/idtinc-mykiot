import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/list_event_bloc.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/bloc_to_page.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../../features_v2/blocs/state/init_state.dart';
import '../../../features_v2/screens/calendar/components/item_event.dart';

class AppointmentInfoView extends StatefulWidget {
  const AppointmentInfoView({super.key, this.idBranch});

  final int? idBranch;

  @override
  State<AppointmentInfoView> createState() => _AppointmentInfoViewState();
}

class _AppointmentInfoViewState extends State<AppointmentInfoView> {
  final bloc = getIt<ListEventBloc>();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList(idBranch: widget.idBranch);
    scroll.onMore(
      () => bloc.getList(idBranch: widget.idBranch),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListEventBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await bloc.getList(idBranch: widget.idBranch);
          },
          child: LoadListPage(
            state: state,
            listEmpty: bloc.list.isEmpty,
            child: ListView.separated(
              padding: sp16.pading,
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => ItemEvent2(
                event: bloc.list[index],
              ),
              separatorBuilder: (context, index) => sp16.height,
              itemCount: bloc.list.length,
            ).expanded(),
          ),
        );
      },
    );
  }
}
