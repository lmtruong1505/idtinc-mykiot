import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/v2/date_time_widget.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/calendar_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/date_time/param_date.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/components/bottom_sheet/bottom_sheet_user.dart';
import 'package:pharmago/presentation/features_v2/screens/calendar/components/item_event.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../base/v2/expanded_section.dart';
import '../../models/calendar/event_model.dart';
import '../../../router/router.gr.dart';

@RoutePage()
class BookCalendarPage extends StatefulWidget {
  @override
  State<BookCalendarPage> createState() => _BookCalendarPageState();
}

class _BookCalendarPageState extends State<BookCalendarPage> {
  late PageController _pageController;

  late CalendarManagerBloc bloc ;
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
    return Scaffold(
      backgroundColor: ColorApp.greyF5,
      appBar: const BaseAppBar(
        title: 'Quản lý lịch hẹn',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bloc.getList();
        },
        child: BlocBuilder<CalendarManagerBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            print(state.status);
            return SingleChildScrollView(
              padding: sp16.pading,
              controller: scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainButtonV2(
                    title: 'Thêm mới lịch hẹn',
                    onTap: () {
                      context.router.push(CreateEventRoute());
                    },
                  ),
                  sp16.height,
                  _buildFilter(),
                  sp16.height,
                  LoadListPage(
                    state: state,
                    height: 200,
                    listEmpty: bloc.list.isEmpty,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ItemEvent(
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
        ),
      ),
    );
  }

  Widget _body1() {
    return BlocBuilder<CalendarManagerBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: sp16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainButtonV2(
                title: 'Thêm mới lịch hẹn',
                onTap: () {
                  context.router.push(CreateEventRoute());
                },
              ),
              sp16.height,
              _buildCalendar(),
              sp16.height,
              _buildFilter(),
              sp16.height,
              ...List.generate(
                bloc.getEventsForDay(bloc.selectDay).length,
                (index) => ItemEvent(
                  event: bloc.getEventsForDay(bloc.selectDay)[index],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Text(
        //   'Danh sách lịch hẹn (${bloc.getEventsForDay(bloc.selectDay).length})',
        //   style: StyleApp.medium(fontSize: 16),
        // ),
        // sp16.height,
        Row(
          children: [
            Expanded(
              child: AppInputV2(
                hintText: 'Tìm kiếm tên khách hàng/dịch vụ',
                borderColor: ColorApp.greyE2,
                backgroundColor: ColorApp.white,
                radius: Dimensions.sp8,
                prefixIcon: const Icon(
                  Icons.search,
                  color: ColorApp.black,
                ),
                onChanged: bloc.changeSearch,
              ),
            ),
            Dimensions.sp16.width,
            GestureDetector(
              onTap: () {
                bloc.isFilter = !bloc.isFilter;
              },
              child: Container(
                width: 48,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: bloc.isFilter ? ColorApp.main : ColorApp.greyE2,
                    ),
                    borderRadius: Dimensions.sp8.radius,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    Assets.iconsIcSort,
                    width: 20,
                    color: bloc.isFilter ? ColorApp.main : ColorApp.greyAA,
                  ),
                ),
              ),
            ),
          ],
        ),
        _inputFilter(),
      ],
    );
  }

  Widget _inputFilter() {
    return ExpandedSection(
      isSelected: bloc.isFilter,
      child: Container(
        margin: Dimensions.sp16.padingTop,
        padding: Dimensions.sp12.pading,
        decoration: BoxDecoration(
          borderRadius: Dimensions.sp8.radius,
          border: Border.all(color: ColorApp.main),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BtnFilter(
              icon: Icons.calendar_month_outlined,
              title: bloc.paramData?.dateRange?.toName ?? 'Tất cả thời gian',
              onClosed: () {
                bloc.setParamDate(null);
              },
              onPressed: () {
                context
                    .bottomSheet(
                  DateTimeWidget(
                    param: bloc.paramData,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  ),
                )
                    .then(
                  (value) {
                    if (value is ParamDate) {
                      bloc.setParamDate(value);
                    }
                  },
                );
              },
            ),
            sp16.height,
            BtnFilter(
              icon: Icons.person,
              title: bloc.customer?.fullName ?? 'Tất cả khách hàng',
              onClosed: () {
                bloc.setCustomer(null);
              },
              onPressed: () {
                context
                    .bottomSheet(
                  const BtsUser(
                    isCustomerOrDoctor: true,
                  ),
                )
                    .then(
                  (value) {
                    if (value is CustomerModel) {
                      bloc.setCustomer(value);
                    }
                  },
                );
              },
            ),
            sp16.height,
            BtnFilter(
              icon: Icons.person,
              title: bloc.doctor?.fullName ?? 'Tất cả bác sĩ',
              onClosed: () {
                bloc.setDoctor(null);
              },
              onPressed: () {
                context
                    .bottomSheet(
                  const BtsUser(
                    isCustomerOrDoctor: false,
                  ),
                )
                    .then(
                  (value) {
                    if (value is EmployeeModel) {
                      bloc.setDoctor(value);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              sp16.width,
              Text(
                bloc.focusedDay
                    .fomatCustom(
                      fomat: DateFormat.YEAR_MONTH,
                    )
                    .replaceFirst('t', 'T'),
                style: StyleApp.semibold(fontSize: 16),
              ).expanded(),
              IconButton(
                onPressed: () {
                  if (_pageController.page.validator > 0) {
                    _pageController.previousPage(
                      duration: 300.milliseconds,
                      curve: Curves.linear,
                    );
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              IconButton(
                onPressed: () {
                  if (_pageController.page.validator < 12) {
                    _pageController.nextPage(
                      duration: 300.milliseconds,
                      curve: Curves.linear,
                    );
                  }
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
            ],
          ),
          Text(
            'Bạn có ${bloc.getEvensByMonth().length} lịch hẹn trong tháng này',
            style: StyleApp.medium(
              color: ColorApp.grey79,
            ),
          ).padding(sp16.padingHor),
          sp16.height,
          TableCalendar<EventModel>(
            locale: 'vi',
            headerVisible: false,
            currentDay: bloc.kToday,
            firstDay: bloc.kToday,
            lastDay: bloc.kLastDay,
            focusedDay: bloc.focusedDay,
            eventLoader: bloc.getEventsForDay,
            availableGestures: AvailableGestures.none,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final events = bloc.getEventsForDay(day);
                if (events.isEmpty) {
                  return const SizedBox();
                }

                return Positioned(
                  bottom: 0,
                  right: 5,
                  child: Container(
                    padding: 4.pading,
                    decoration: const BoxDecoration(
                      color: ColorApp.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      events.length.toString(),
                      style: StyleApp.normal(
                        color: ColorApp.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: ColorApp.main,
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: ColorApp.main,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: StyleApp.semibold(
                fontSize: 18,
                color: ColorApp.white,
              ),
              todayTextStyle: StyleApp.semibold(
                fontSize: 18,
                color: ColorApp.white,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: StyleApp.medium(),
              weekendStyle: StyleApp.medium(),
            ),
            calendarFormat: CalendarFormat.month,
            onDaySelected: bloc.onDaySelected,
            onCalendarCreated: (controller) => _pageController = controller,
            selectedDayPredicate: (DateTime date) {
              return isSameDay(bloc.selectDay, date);
            },
            onPageChanged: (focusedDay) {
              bloc.setFocusedDayPage(focusedDay);
            },
          ).padding(5.padingHor),
          sp16.height,
        ],
      ),
    );
  }
}
