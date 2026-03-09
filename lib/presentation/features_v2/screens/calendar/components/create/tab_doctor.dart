import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/staff_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/staff/components/item_staff.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../constants/spacing.dart';
import '../../../../blocs/calendar/create_event_bloc.dart';

class TabDoctorCalendar extends StatefulWidget {
  final CreateEventBloc bloc;
  const TabDoctorCalendar({required this.bloc});

  @override
  State<TabDoctorCalendar> createState() => _TabDoctorCalendarState();
}

class _TabDoctorCalendarState extends State<TabDoctorCalendar> {
  final bloc = StaffManagerBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.setActive(AccountStatusEnum.active, isReload: false);
    bloc.company = widget.bloc.company;
    bloc.getList();
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return BlocBuilder<StaffManagerBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: sp16.pading,
              controller: scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppInputV2(
                    hintText: 'Tìm tên bác sĩ',
                    borderColor: ColorApp.greyE2,
                    backgroundColor: ColorApp.white,
                    radius: Dimensions.sp8,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ColorApp.black,
                    ),
                    onChanged: bloc.search,
                    onConfirm: (p0) {},
                  ),
                  if (widget.bloc.company == null)
                    SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'Chọn cơ sở để lấy danh sách bác sĩ',
                          textAlign: TextAlign.center,
                          style: StyleApp.normal(),
                        ),
                      ),
                    ),
                  if (widget.bloc.company != null)
                    LoadListPage(
                      state: state,
                      height: 200,
                      listEmpty: bloc.list.isEmpty,
                      child: ListView.separated(
                        padding: 16.padingVer,
                        itemBuilder: (context, index) => ItemStaff(
                          staff: bloc.list[index],
                          isActive: bloc.list[index].id == widget.bloc.doctor,
                          onTap: () {
                            widget.bloc.doctor = bloc.list[index].id;
                          },
                        ),
                        separatorBuilder: (context, index) => 16.height,
                        itemCount: bloc.list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
