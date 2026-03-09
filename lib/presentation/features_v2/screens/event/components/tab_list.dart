import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/event/list_event_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/presentation/features_v2/screens/event/components/bts/bts_filter_calendar.dart';
import 'package:pharmago/presentation/features_v2/screens/event/components/empty_event.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../config/role/check_role_per.dart';
import '../../../../config/role/permission/index.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../../models/employee/working_data_model.dart';
import 'items/item_event_calendar.dart';
import 'package:auto_route/auto_route.dart';

class TabListEvent extends StatefulWidget {
  final int? companyId;
  final int? doctorId;
  final bool isCallBloc;
  final bool isAdd;
  final List<WorkingDataModel>? workingData;
  final int? customer;
  final EdgeInsets? padding;
  const TabListEvent({
    super.key,
    this.isCallBloc = true,
    this.isAdd = true,
    this.companyId,
    this.doctorId,
    this.workingData,
    this.customer,
    this.padding,
  });

  @override
  State<TabListEvent> createState() => _TabListEventState();
}

class _TabListEventState extends State<TabListEvent> {
  final _bloc = getIt<ListEventV2Bloc>();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isCallBloc) {
      _bloc.init(
        companyId: widget.companyId,
        doctor: widget.doctorId,
        customer: widget.customer,
      );
    }
    scroll.onMore(() => _bloc.getList(isMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListEventV2Bloc, CubitState>(
      bloc: _bloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            _bloc.getList();
          },
          child: LoadMoreListBloc(
            padding: widget.padding,
            state: state,
            list: _bloc.list,
            spaceBottom: context.padding.bottom,
            controller: scroll,
            emptyViewAll: EmptyEvent(
              onPressed: widget.isAdd &&
                      checkPermission(PerAppointmentEnum.CREATE.code)
                  ? () {
                      context.pushRoute(
                        CreateEventV2Route(
                          companyId: widget.companyId,
                          employeeId: widget.doctorId,
                        ),
                      );
                    }
                  : null,
            ),
            headerView: headerView(),
            separatorBuilder: 12.height,
            isEmptyAll: state.isFirst,
            sizePage: _bloc.param.limit,
            itemBuilder: (context, item, index) {
              bool showTime = false;
              if (index != 0) {
                final previousItem = _bloc.list[index - 1];
                showTime =
                    previousItem.meetingAt.fomatCustom(fomat: 'dd/MM/yyyy') !=
                        item.meetingAt.fomatCustom(fomat: 'dd/MM/yyyy');
              } else {
                showTime = true;
              }
              return Column(
                children: [
                  if (showTime)
                    Padding(
                      padding: const EdgeInsets.only(bottom: sp12),
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Text(
                            item.meetingAt == null ? 'Khám trực tiếp' : item.meetingAt.fomatCustom(fomat: 'dd/MM/yyyy'),
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
                    ),
                  ItemEventCalendar(
                    item: item,
                    isEmployee: widget.doctorId != null,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget headerView() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchFilterCustom(
            hintText: 'Tìm tên, SĐT, mã lịch hẹn',
            value: _bloc.param.search,
            isActive: _bloc.isFilter,
            onConfirm: _bloc.search,
            onChange: (p0) {
              _bloc.param.search = p0;
            },
            onTap: () {
              context.bottomSheet(
                BtsFilterEvent(
                  dateRang: _bloc.param.dateRang,
                  doctor: _bloc.param.doctor,
                  status: _bloc.param.status,
                  workingData: widget.workingData,
                  doctorId: widget.doctorId,
                  companyId: _bloc.param.companyId,
                  onChanged: (dateRang, status, doctor, companyId) {
                    _bloc.updateFilter(
                      dateRang: dateRang,
                      status: status,
                      doctor: widget.doctorId != null
                          ? PreEmpModel(id: widget.doctorId)
                          : doctor,
                      companyId: companyId,
                    );
                  },
                ),
              );
            },
          ),
          24.height,
        ],
      );
}
