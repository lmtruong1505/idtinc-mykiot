import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_state.dart';
import 'package:pharmago/presentation/features/company/screen_v2/components/bts_filter.dart';
import 'package:pharmago/presentation/features/company/screen_v2/components/items/item_workspace.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/number_trend.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/title_add.dart';
import '../../../cubit/work_space/work_space_cubit.dart';

class TabListWorkSpace extends StatefulWidget {
  const TabListWorkSpace({
    super.key,
  });

  @override
  State<TabListWorkSpace> createState() => _TabListWorkSpaceState();
}

class _TabListWorkSpaceState extends State<TabListWorkSpace>
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

        if (state.count.validator <= 0 && state.companies.isEmpty) {
          return EmptyComfirm(
            text: 'Bạn chưa sở hữu Workspace nào',
            labelBtn: 'Tạo Workspace',
            svgAsset: Assets.iconsWokrspaceIcon,
            onPressed: () {
              context.pushRoute(CreateWorkspaceRoute());
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            bloc.getListCompanies();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRevenua().padding(16.padingHor),
              SingleChildScrollView(
                padding: 16.padingHor,
                controller: scroll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    32.height,
                    SearchFilterCustom(
                      hintText: 'Nhập tên workspace',
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
                    TitleAdd(
                      labelButton: 'Thêm Workspace',
                      onPressed: () => context.pushRoute(
                        CreateWorkspaceRoute(),
                      ),
                    ),
                    const Divider(
                      height: 0,
                      color: AppColors.border_tertiary,
                    ),
                    if (state.isLoading && !state.isLoadMore && !state.isFirst)
                      const BaseLoading(
                        height: 200,
                      ),
                    if (state.companies.isNotEmpty && !state.isLoading) ...[
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => ItemWorkspace(
                          company: state.companies[index],
                        ),
                        separatorBuilder: (context, index) => 16.height,
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
              ).expanded(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevenua() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: context.appLocalized.txt_total_sales,
            style: AppStyle.headingXl,
            children: [
              TextSpan(
                text: ' (${context.appLocalized.txt_sale_content})',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
        ),
        8.height,
        NumberTrending(
          number: bloc.state.revenue.validator.formatPrice(type: ' đ'),
          percent: getPercentWorkSpace(
            bloc.state.revenue.validator,
            bloc.state.revenueBefore.validator,
          ),
          isUp: bloc.state.revenue.validator >=
              bloc.state.revenueBefore.validator,
          style: AppStyle.headingDisplay,
          subStyle: AppStyle.bodyBsBold,
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
