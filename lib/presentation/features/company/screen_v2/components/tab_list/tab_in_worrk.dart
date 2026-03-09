import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../base/loading.dart';
import '../../../cubit/work_space/work_space_cubit.dart';
import '../../../cubit/work_space/work_space_state.dart';
import '../bts_filter.dart';
import '../items/item_staff_ws.dart';
import '../../../../../../shared/components/widgets/search_filter.dart';

class TabInWorkingWorkSpace extends StatefulWidget {
  const TabInWorkingWorkSpace({super.key});

  @override
  State<TabInWorkingWorkSpace> createState() => _TabInWorkingWorkSpaceState();
}

class _TabInWorkingWorkSpaceState extends State<TabInWorkingWorkSpace>
    with AutomaticKeepAliveClientMixin {
  final bloc = getIt<WorkSpaceCubit>();

  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.onMore(
      () => bloc.getListCompanies(isLoadMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<WorkSpaceCubit, WorkSpaceState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.isLoading && !state.isLoadMore && state.isFirst) {
          return const BaseLoading(
            height: 200,
          );
        }
        if (state.countWorking.validator <= 0 && state.companies.isEmpty) {
          return _emptyStaff();
        }
        return SingleChildScrollView(
          padding: 16.pading,
          controller: scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchFilterCustom(
                hintText: 'Nhập tên workspace, cơ sở',
                value: state.search,
                onConfirm: (p0) {
                  bloc.setSearch(p0);
                },
                isActive: bloc.isSort,
                onTap: () {
                  context.bottomSheet(
                    BtsFilterWorkspace(
                      revenue: state.revenueFilter,
                      status: state.status,
                      time: state.time,
                      type: state.type,
                      onChange: (status, type, time, revenue) {
                        bloc.changeFilter(
                          status: status,
                          type: type,
                          time: time,
                          revenue: revenue,
                        );
                      },
                    ),
                  );
                },
              ),
              16.height,
              if (state.isLoading && !state.isLoadMore && !state.isFirst)
                const BaseLoading(
                  height: 200,
                ),
              if (state.companies.isNotEmpty && !state.isLoading) ...[
                ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => ItemStaffWorkSpace(
                    company: state.companies[index],
                  ),
                  separatorBuilder: (context, index) =>
                      state.companies[index].statusUserWorkPending
                          ? const Divider(
                              height: 32,
                              color: AppColors.border_tertiary,
                            )
                          : 0.height,
                  itemCount: state.companies.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
                SizedBox(
                  height: 50,
                  child: state.isLoadMore
                      ? const BaseLoading(
                          height: 50,
                        )
                      : null,
                ),
              ],
              if (state.companies.isEmpty && !state.isLoading)
                EmptySearch(
                  text: 'Không tìm thấy kết quả',
                ),
              20.height,
              context.padding.bottom.height,
            ],
          ),
        );
      },
    );
  }

  Widget _emptyStaff() {
    return Column(
      children: [
        IconSpecial(svgPath: Assets.iconsEmpty),
        Text(
          'Bạn chưa là nhân viên của\nWorkspace nào',
          textAlign: TextAlign.center,
          style: AppStyle.bodyBsMedium,
        ),
        16.height,
        Container(
          // padding: 12.pading,
          decoration: BoxDecoration(
            borderRadius: 16.radius,
            color: Colors.white,
            border: Border.all(color: AppColors.border_tertiary),
          ),
          child: QrImageView(
            data: userCode,
            version: QrVersions.auto,
            size: 128.0,
          ),
        ),
      ],
    ).container(padding: 32.padingVer + 16.padingHor);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
