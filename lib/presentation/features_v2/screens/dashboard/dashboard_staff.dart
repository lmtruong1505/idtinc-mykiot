import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/dashboard/dashboard_staff_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/date_time/param_date.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/calendar/components/item_event.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../blocs/calendar/calendar_manager_bloc.dart';

class DashboardStaffView extends StatefulWidget {
  @override
  State<DashboardStaffView> createState() => _DashboardStaffViewState();
}

class _DashboardStaffViewState extends State<DashboardStaffView> {
  final bloc = DashboardStaffBloc();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CalendarManagerBloc>().setParamDate(
          ParamDate(
            endDate: bloc.now,
            startDate: bloc.now.copyWith(
              hour: 0,
              minute: 0,
              second: 0,
            ),
          ),
          limit: 100,
        );
    scroll.onMore(
      () => context.read<CalendarManagerBloc>().getList(
            limit: 100,
            isMore: true,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventBloc = context.read<CalendarManagerBloc>();
    return SingleChildScrollView(
      padding: 16.pading,
      controller: scroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCompany(),
          32.height,
          _buildWeek(),
          16.height,
          BlocBuilder<CalendarManagerBloc, CubitState>(
            builder: (context, state) {
              return LoadListPage(
                state: state,
                height: 200,
                listEmpty: eventBloc.list.isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Bạn có  ',
                            style: StyleApp.medium(fontSize: 16),
                          ),
                          TextSpan(
                            text: '${eventBloc.list.length} ',
                            style: StyleApp.medium(
                                fontSize: 16, color: ColorApp.yellowD2),
                          ),
                          TextSpan(
                            text: ' lịch hẹn trong ngày',
                            style: StyleApp.medium(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ItemEvent(
                        event: eventBloc.list[index],
                      ),
                      separatorBuilder: (context, index) => 16.height,
                      itemCount: eventBloc.list.length,
                    ),
                  ],
                ),
              );
            },
          ),
          context.padding.bottom.height,
        ],
      ),
    );
  }

  Widget _buildWeek() {
    return BlocBuilder<DashboardStaffBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Container(
          padding: 16.padingVer + 4.padingHor,
          decoration: BoxDecoration(
            color: ColorApp.white,
            borderRadius: 8.radius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              2.height,
              Text(
                bloc.now.formatDateTimeVi,
                textAlign: TextAlign.center,
                style: StyleApp.medium(fontSize: 16),
              ),
              18.height,
              Row(
                children: List.generate(
                  7,
                  (index) => _buildDay(
                    day: bloc.monday.add(Duration(days: index)),
                    isChoose: index == bloc.weekDay,
                    //\onTap: () => bloc.setWeekDay(index),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildCompany() {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 16.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Trực thuộc:',
            style: StyleApp.medium(color: ColorApp.grey79),
          ),
          Text(
            'Chuỗi nhà thuốc và phòng khám Thu Hương',
            style: StyleApp.medium(),
          ),
        ],
      ),
    );
  }

  Widget _buildDay({
    required DateTime day,
    bool isChoose = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isChoose ? ColorApp.main : ColorApp.white,
          borderRadius: 8.radius,
        ),
        padding: 8.padingVer,
        margin: 4.padingHor,
        child: Column(
          children: [
            Text(
              day.fomatCustom(fomat: 'EE').replaceAll('h ', ''),
              style: StyleApp.medium(
                color: isChoose ? ColorApp.white : ColorApp.greyA7,
              ),
            ),
            4.height,
            Text(
              day.day.toString(),
              style: StyleApp.medium(
                color: isChoose ? ColorApp.white : null,
                fontSize: 18,
              ),
            ),
            4.height,
          ],
        ),
      ),
    ).expanded();
  }
}
