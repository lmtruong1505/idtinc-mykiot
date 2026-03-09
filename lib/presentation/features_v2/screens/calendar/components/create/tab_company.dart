import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_cubit.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../features/company/cubit/work_space/work_space_state.dart';
import '../../../../blocs/calendar/create_event_bloc.dart';

class TabCompanyCalendar extends StatefulWidget {
  final CreateEventBloc bloc;
  const TabCompanyCalendar({required this.bloc});

  @override
  State<TabCompanyCalendar> createState() => _TabCompanyCalendarState();
}

class _TabCompanyCalendarState extends State<TabCompanyCalendar>
    with AutomaticKeepAliveClientMixin {
  final companyBloc = getIt<WorkSpaceCubit>();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CreateEventBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return BlocBuilder<WorkSpaceCubit, WorkSpaceState>(
          bloc: companyBloc,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: 16.pading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppInputV2(
                    hintText: 'Tìm tên dịch vụ',
                    borderColor: ColorApp.greyE2,
                    backgroundColor: ColorApp.white,
                    radius: Dimensions.sp8,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ColorApp.black,
                    ),
                    onChanged: companyBloc.changeSearchParent,
                  ),
                  sp16.height,
                  ListView.separated(
                    padding: 0.pading,
                    itemBuilder: (context, index) => _buildCompany(
                      state.companies[index],
                    ),
                    separatorBuilder: (context, index) => 16.height,
                    itemCount: state.companies.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompany(CompanyEntity company) {
    return InkWell(
      onTap: () {
        widget.bloc.company = company.id;
      },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.bloc.company == company.id
                ? ColorApp.main
                : ColorApp.greyE2,
          ),
          borderRadius: 8.radius,
          color: ColorApp.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      company.name ?? '',
                      style: StyleApp.medium(fontSize: 16),
                    ),
                    sp8.height,
                    Text(
                      'Quản lý: $getUserName',
                      style: StyleApp.normal(),
                    ),
                  ],
                ).expanded(),
                const Icon(
                  Icons.circle,
                  size: 10,
                  color: ColorApp.main,
                ),
              ],
            ),
            8.height,
            Row(
              children: [
                Image.asset(
                  Assets.iconsIcPeople,
                  height: 21,
                ),
                12.width,
                Text(
                  '${company.totalStaff ?? 0} nhân viên',
                  style: StyleApp.medium(),
                ).expanded(),
              ],
            ),
            8.height,
            Row(
              children: [
                Image.asset(
                  Assets.iconsIcCalendar,
                  height: 21,
                ),
                12.width,
                Text(
                  '${company.timeStart.fomatDate2(
                    defaultReturn: "08:00",
                    fomat: "HH:mm",
                    parseFormat: 'HH:mm:ss',
                  )} - ${company.timeEnd.fomatDate2(
                    defaultReturn: "17:30",
                    fomat: "HH:mm",
                    parseFormat: 'HH:mm:ss',
                  )}',
                  style: StyleApp.semibold(color: ColorApp.main),
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
