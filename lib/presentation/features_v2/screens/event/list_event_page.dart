import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/screens/event/components/tab_calendar.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../config/app_style/init_app_style.dart';
import '../../../config/role/check_role_per.dart';
import '../../../config/role/permission/index.dart';
import '../../../router/router.gr.dart';
import '../../blocs/event/list_event_bloc.dart';
import '../../blocs/state/init_state.dart';
import 'components/empty_event.dart';
import 'components/tab_list.dart';

@RoutePage()
class ListEventPage extends StatefulWidget {
  const ListEventPage({super.key});

  @override
  State<ListEventPage> createState() => _ListEventPageState();
}

class _ListEventPageState extends State<ListEventPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _bloc = getIt<ListEventV2Bloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _bloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: 'Quản lý lịch hẹn',
        leadingText: 'Trở về',
      ),
      body: BlocBuilder<ListEventV2Bloc, CubitState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state.isFirst && state.status == BlocStatus.loading) {
            return const BaseLoading();
          }
          if (_bloc.list.isEmpty &&
              state.status == BlocStatus.success &&
              state.isFirst) {
            return EmptyEvent(
              onPressed: funCreate,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              16.height,
              _tabBarCustom(),
              TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  TabListEvent(
                    isCallBloc: false,
                  ),
                  TabCalendarEvent(),
                ],
              ).expanded(),
            ],
          );
        },
      ),
    );
  }

  final List<String> icons = ['f00b', 'f133'];

  Widget _tabBarCustom() {
    return Row(
      children: [
        Row(
          children: List.generate(
            icons.length,
            (index) => IconBtn(
              onTap: () {
                if (index == 0) {
                  _bloc.init();
                }
                _tabController.animateTo(index);
              },
              backgroundColor: _tabController.index == index
                  ? AppColors.bg_primary_active
                  : AppColors.bg_primary,
              borderRadius: index == 0
                  ? 8.radiusLeft
                  : index == icons.length - 1
                      ? 8.radiusRight
                      : 0.radius,
              size: const Size(52, 32),
              padding: 0.pading,
              icon: FaIcon(
                iconCode: icons[index],
                color: AppColors.fg_primary,
              ),
            ),
          ),
        ).container(
          height: 32,
          padding: 0.pading,
          border: Border.all(color: AppColors.border_tertiary),
        ),
        const Spacer(),
        LabelButton(
          label: 'Thêm lịch hẹn',
          backgroundColor: AppColors.button_neutral_solid_backgroundDefault,
          suffixIcon: const Icon(
            Icons.add,
            color: AppColors.bg_primary,
            size: 16,
          ),
          onPressed: funCreate,
        ),
      ],
    ).padding(16.padingHor);
  }

  Function()? get funCreate =>
      checkPermission(PerAppointmentEnum.CREATE.code) ? createEvent : null;

  void createEvent() async {
    await context.pushRoute(MedicalScheduleEditorRoute());
    _bloc.getList();
  }

  // Widget _tabBarCustom() => Container(
  //       decoration: const BoxDecoration(
  //         border: Border(
  //           bottom: BorderSide(color: AppColors.border_tertiary),
  //         ),
  //       ),
  //       child: TabBar(
  //         controller: _tabController,
  //         labelColor: AppColors.text_brand_primary_variant1,
  //         unselectedLabelColor: AppColors.text_tertiary,
  //         labelStyle: AppStyle.bodyBsMedium,
  //         unselectedLabelStyle: AppStyle.bodyBsRegular,
  //         indicatorColor: AppColors.border_brandSolid,
  //         indicatorSize: TabBarIndicatorSize.label,
  //         tabs: const [
  //           Tab(
  //             text: 'Danh sách',
  //           ),
  //           Tab(
  //             text: 'Lịch',
  //           ),
  //         ],
  //       ),
  //     );
}
