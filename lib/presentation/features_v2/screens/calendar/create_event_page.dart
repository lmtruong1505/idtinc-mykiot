import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/create_event_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/list_pk_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/calendar/components/create/tab_doctor.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../blocs/calendar/calendar_manager_bloc.dart';
import 'components/create/tab_company.dart';
import 'components/create/tab_customer.dart';
import 'components/create/tab_service.dart';
import 'components/create/tab_time.dart';

@RoutePage()
class CreateEventPage extends StatefulWidget {
  final bool isEvent;
  final EmployeeModel? staff;
  const CreateEventPage({
    super.key,
    this.isEvent = true,
    this.staff,
  });

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bloc = CreateEventBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(vsync: this, length: lengthTab);
    bloc.isEvent = widget.isEvent;
    if (widget.staff?.id != null) {
      bloc.company = widget.staff?.companyId;
      bloc.doctor = widget.staff?.id;
    }
  }

  int get lengthTab {
    const int length = 5;
    if (widget.staff?.id != null) {
      length - 1;
    }
    if (widget.staff?.companyId != null) {
      length - 1;
    }
    if (!widget.isEvent) {
      length - 1;
    }

    return length;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.staff?.id);
    return Scaffold(
      backgroundColor: ColorApp.greyF5,
      appBar: BaseAppBar(
        title: widget.isEvent ? 'Tạo mới lịch hẹn' : 'Tạo mới phiếu khám',
      ),
      bottomNavigationBar: BlocConsumer<CreateEventBloc, CubitState>(
        bloc: bloc,
        listener: (context, state) {
          CheckStateBloc.check(
            context,
            state,
            successBtnText: 'Danh sách',
            success: () {
              if (widget.isEvent) {
                context.read<CalendarManagerBloc>().getList();
              } else {
                context.read<ListPhieuKhamBloc>().getList();
              }
              context.pop();
              context.pop();
            },
          );
        },
        builder: (context, state) {
          return ExpandedSection(
            isSelected: bloc.isCreate,
            child: Container(
              color: ColorApp.white,
              padding: 16.pading + 4.padingBottom,
              child: RowBtn(
                onCancel: () => context.pop(),
                onConfirm: () {
                  if (widget.isEvent) {
                    bloc.createEvent();
                  } else {
                    bloc.createPhieuKham();
                  }
                },
                confirmText: widget.isEvent ? 'Tạo lịch hẹn' : 'Tạo phiếu khám',
              ),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: ColorApp.white,
            child: TabBar(
              controller: _tabController,
              labelColor: ColorApp.black,
              indicatorColor: ColorApp.main,
              labelStyle: StyleApp.medium(),
              unselectedLabelStyle: StyleApp.normal(),
              unselectedLabelColor: ColorApp.grey79,
              isScrollable: true,
              tabs: [
                const Tab(text: 'Khách hàng'),
                const Tab(text: 'Dịch vụ'),
                if (widget.staff?.roleData?.company == null)
                  const Tab(text: 'Cơ sở'),
                if (widget.staff?.id == null) const Tab(text: 'Bác sĩ'),
                if (widget.isEvent) const Tab(text: 'Thời gian'),
              ],
            ),
          ),
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              TabCustomerEvent(
                bloc: bloc,
              ),
              TabServiceEvent(
                bloc: bloc,
              ),
              if (widget.staff?.roleData?.company == null)
                TabCompanyCalendar(
                  bloc: bloc,
                ),
              if (widget.staff?.id == null)
                TabDoctorCalendar(
                  bloc: bloc,
                ),
              if (widget.isEvent)
                TabDateTimeEvent(
                  bloc: bloc,
                ),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
