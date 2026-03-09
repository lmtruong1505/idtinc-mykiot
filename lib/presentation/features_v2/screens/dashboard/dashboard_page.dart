import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/home/cubit/nav_home_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/dashboard/customer_top_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/dashboard/order_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/components/customer_dashboard.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../data/models/date_range.model.dart';
import '../../../../gen/assets.dart';
import '../../../di/di.dart';
import '../../../features/company/cubit/work_space/work_space_cubit.dart';
import '../../blocs/dashboard/brand_bloc.dart';
import '../../blocs/dashboard/dashboard_staff_bloc.dart';
import '../../blocs/dashboard/prd_top_bloc.dart';
import 'components/app_bar_dashboard.dart';
import 'components/employee_dashboard.dart';
import 'components/order_dashboard.dart';
import 'components/prd_dashboard.dart';

@RoutePage()
class DashboardV2Page extends StatefulWidget {
  const DashboardV2Page({
    super.key,
  });

  @override
  State<DashboardV2Page> createState() => _DashboardV2PageState();
}

class _DashboardV2PageState extends State<DashboardV2Page> {
  final bloc = DashboardStaffBloc();
  final orderBloc = OrderDashboardBloc();
  final customerTopBloc = CustomerTopBloc();
  final dashboardStaffBloc = DashboardStaffBloc();
  final prdTopBloc = PrdTopBloc();
  final brandBloc = BrandDashboardBloc();
  final brandClinicBloc = BrandDashboardBloc();
  final wsBloc = getIt.get<WorkSpaceCubit>();

  DateRangeModel? datesFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wsBloc.changeFilter(isWorkingPlace: true, isOwner: true);
    wsBloc.getListCompanies(companyIdData: wsBloc.state.companyId);
    init();
    print('=====companyType======$companyType');
  }

  void init() {
    orderBloc.getData(dates: datesFilter);
    customerTopBloc.getData();
    dashboardStaffBloc.getDataEmployeeDashboard(dates: datesFilter);
    prdTopBloc.getData();
    context.read<NavHomeBloc>().onChanged(TabCodeNav.home);
    // brandBloc.getData();
    // brandClinicBloc.type = TypeCompany.clinic;
    // brandClinicBloc.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: Stack(
        children: [
          Image.asset(Assets.imgsBackgroundWp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppbarDashboard(
                onChanged: (company) => init(),
                dateChanged: (dates) {
                  setState(() {
                    datesFilter = DateRangeModel().fromListDateTime(dates);
                  });
                  init();
                },
                dateFilter: [datesFilter?.startDate, datesFilter?.endDate],
              ),
              //DashboardStaffView().expanded(),
              SingleChildScrollView(
                padding: 16.pading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // RevenuaDashboard(),
                    // sp16.height,
                    OrderDashboard(
                      bloc: orderBloc,
                    ),
                    sp16.height,
                    // DrugstoreDashboard(
                    //   bloc: brandBloc,
                    // ),
                    // sp16.height,
                    // DrugstoreDashboard(
                    //   bloc: brandClinicBloc,
                    //   type: TypeCompany.clinic,
                    // ),
                    // sp16.height,
                    PrdDashboard(
                      bloc: prdTopBloc,
                    ),
                    sp16.height,
                    CustomerDashboard(
                      bloc: customerTopBloc,
                    ),
                    sp16.height,
                    EmployeeDashboard(
                      bloc: dashboardStaffBloc,
                    ),
                    context.padding.bottom.height,
                  ],
                ),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }
}
