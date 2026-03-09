import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../constants/spacing.dart';
import '../../../../blocs/calendar/calendar_manager_bloc.dart';
import '../../../../blocs/state/init_state.dart';

class TabEventDoctor extends StatefulWidget {
  final EmployeeModel model;
  const TabEventDoctor({
    super.key,
    required this.model,
  });

  @override
  State<TabEventDoctor> createState() => _TabEventDoctorState();
}

class _TabEventDoctorState extends State<TabEventDoctor>
    with AutomaticKeepAliveClientMixin {
  late CalendarManagerBloc bloc;
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<CalendarManagerBloc>();
    bloc.getList();
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CalendarManagerBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: sp16.pading,
          controller: scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainButtonV2(
                title: 'Thêm mới lịch hẹn',
                onTap: () {
                  context.router.push(
                    CreateEventRoute(
                      staff: widget.model,
                      
                    ),
                  );
                },
              ),
              sp16.height,
              LoadListPage(
                state: state,
                height: 200,
                listEmpty: bloc.list.isEmpty,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _buildItem(
                    event: bloc.list[index],
                  ),
                  separatorBuilder: (context, index) => sp16.height,
                  itemCount: bloc.list.length,
                ),
              ),
              context.padding.bottom.height,
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem({
    required EventModel event,
  }) {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    return InkWell(
      onTap: () {
        context.pushRoute(DetailEventRoute(id: event.id ?? 0));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextRow2(
            title: 'Tên khách hàng',
            content: event.customer?.fullName ?? '',
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          8.height,
          TextRow2(
            title: 'Thời gian',
            content: event.meetingAt.toDate.fomatCustom(
              fomat: 'HH:mm dd/MM/yyyy',
            ),
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          8.height,
          TextRow2(
            title: 'Dịch vụ',
            content: event.services
                ?.map(
                  (e) => e.title ?? '',
                )
                .toList()
                .listToString,
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
        ],
      ).container(border: Border.all(color: ColorApp.greyE2)),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
