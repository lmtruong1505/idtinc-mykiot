import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/calendar_custom.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../../blocs/date_time/param_date.dart';
import '../../../blocs/event/event_calendar_bloc.dart';
import '../../../blocs/event/list_event_bloc.dart';
import 'empty_event.dart';
import 'items/item_event_time.dart';

class TabCalendarEvent extends StatefulWidget {
  const TabCalendarEvent({super.key});

  @override
  State<TabCalendarEvent> createState() => _TabCalendarEventState();
}

class _TabCalendarEventState extends State<TabCalendarEvent> {
  final _blocCalendar = EventCalendarV2Bloc();
  final _bloc = getIt<ListEventV2Bloc>();
  final _scroll = ScrollController();
  final paramDate = ParamDate(
    dateRange: DateRangeEnum.today,
    endDate: DateTime.now(),
    startDate: DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
    ),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.updateFilter(dateRang: paramDate);
    _blocCalendar.getList(DateTime.now());
    _scroll.onMore(() => _bloc.getList(isMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.pading,
      controller: _scroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<EventCalendarV2Bloc, CubitState>(
            bloc: _blocCalendar,
            builder: (context, state) {
              return CalendarCustom(
                isChoose: true,
                events: _blocCalendar.list,
                onMonthChanged: (date) {
                  _blocCalendar.getList(date);
                },
                onChanged: (date) {
                  paramDate.startDate = date;
                  paramDate.endDate = date.copyWith(
                    hour: 23,
                    minute: 59,
                    second: 59,
                  );
                  _bloc.updateFilter(dateRang: paramDate);
                },
              );
            },
          ).container(
            radius: 20,
            padding: 12.pading,
            border: Border.all(color: AppColors.border_tertiary),
          ),
          sp16.height,
          BlocBuilder<ListEventV2Bloc, CubitState>(
            bloc: _bloc,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(sp12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.border_primary,
                  ),
                  borderRadius: BorderRadius.circular(sp12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                    ),
                    sp4.width,
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(
                              hour: 0,
                              minute: 0,
                            ),
                          );
                          paramDate.startDate = paramDate.startDate?.copyWith(
                            hour: time?.hour,
                            minute: time?.minute,
                          );
                          _bloc.updateFilter(dateRang: paramDate);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(sp8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.border_primary,
                            ),
                            borderRadius: BorderRadius.circular(sp12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${_bloc.param.dateRang?.startDate.fomatCustom(fomat: "HH:mm")}'),
                              sp4.width,
                              Icon(
                                Icons.arrow_drop_down_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    sp4.width,
                    Text('đến'),
                    sp4.width,
                    Icon(
                      Icons.access_time_rounded,
                    ),
                    sp4.width,
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(
                              hour: 0,
                              minute: 0,
                            ),
                          );
                          paramDate.endDate = paramDate.endDate?.copyWith(
                            hour: time?.hour,
                            minute: time?.minute,
                          );
                          _bloc.updateFilter(dateRang: paramDate);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(sp8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.border_primary,
                            ),
                            borderRadius: BorderRadius.circular(sp12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${_bloc.param.dateRang?.endDate.fomatCustom(fomat: "HH:mm")}'),
                              sp4.width,
                              Icon(
                                Icons.arrow_drop_down_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          sp16.height,
          BlocBuilder<ListEventV2Bloc, CubitState>(
            bloc: _bloc,
            builder: (context, state) {
              return LoadMoreListBloc(
                state: state,
                list: _bloc.list,
                spaceBottom: context.padding.bottom,
                sizePage: _bloc.param.limit,
                emptyView: EmptyEvent(
                  onPressed: () =>
                      context.pushRoute(MedicalScheduleEditorRoute()),
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item, index) => Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Text(
                          item.meetingAt.fomatCustom(fomat: 'HH:mm'),
                          overflow: TextOverflow.ellipsis,
                          style: s14w400.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ).container(
                          radius: sp16,
                          padding: const EdgeInsets.symmetric(
                            vertical: sp4,
                            horizontal: sp8,
                          ),
                          border: Border.all(color: AppColors.border_primary),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    sp12.height,
                    ItemEventTime(
                      item: item,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
