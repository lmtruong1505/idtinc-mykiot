import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/dashboard/prd_top_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/components/bg_widget_dashboard.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

class PrdDashboard extends StatelessWidget {
  final PrdTopBloc bloc;
  PrdDashboard({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrdTopBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return BgWidgetDashboard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Top ${bloc.list.length} sản phẩm',
                style: StyleApp.normal(),
              ),
              // sp8.height,
              // RichText(
              //   text: TextSpan(
              //     text: state.total.toString(),
              //     style: StyleApp.normal(color: ColorApp.main),
              //     children: [
              //       TextSpan(
              //         text: ' sản phẩm',
              //         style: StyleApp.normal(),
              //       ),
              //     ],
              //   ),
              // ),
              // sp16.height,
              DefaultTabController(
                length: 3,
                child: TabBar(
                  indicatorColor: ColorApp.main,
                  labelColor: ColorApp.main,
                  unselectedLabelColor: ColorApp.grey79,
                  onTap: (value) {
                    bloc.sort = SortPrdDashboard.values[value];
                  },
                  tabs: const [
                    Tab(
                      text: 'Doanh số',
                    ),
                    Tab(
                      text: 'Số lượng bán',
                    ),
                    Tab(
                      text: 'Cận date',
                    ),
                  ],
                ),
              ),
              sp16.height,
              LoadPage(
                state: state,
                height: 200,
                listEmpty: bloc.list.isEmpty,
                child: SizedBox(
                  height: heightDevice(context) / 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        bloc.list.length,
                        (index) => Column(
                          children: [
                            _buildPrd(index),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final colors = [
    ColorApp.yellowF7,
    ColorApp.greyE2,
    ColorApp.brown,
  ];

  Widget _buildPrd(int index) {
    final isRevenue = bloc.sort == SortPrdDashboard.revenue;
    final isExpired = bloc.sort == SortPrdDashboard.expired;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: sp8.pading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 21,
                width: 21,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index > 2 ? null : colors[index],
                  border: index < 3 ? null : Border.all(color: ColorApp.greyAA),
                ),
                child: Text(
                  '${index + 1}',
                  style: StyleApp.medium(fontSize: 12),
                ),
              ),
              sp8.width,
              Text(
                bloc.list[index].name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: StyleApp.medium(
                  fontSize: 14,
                  color: ColorApp.black,
                ),
              ).expanded(),
            ],
          ),
        ),
        Visibility(
          visible: bloc.sort != SortPrdDashboard.expired,
          child: Padding(
            padding: sp12.padingHor + sp8.padingVer,
            child: TextRowDashboard(
              title: 'Tồn hiện tại',
              content: '${bloc.list[index].availableStock} ${bloc.list[index].unitSell?.name}',
              titleStyle: isExpired
                  ? s14w400.copyWith(color: AppColors.blue60)
                  : null,
              isPercent: false,
            ),
          ),
        ),
        Container(
          padding: sp12.padingHor + sp8.padingVer,
          decoration: BoxDecoration(
            color: bg_4,
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: TextRowDashboard(
            title: isRevenue
                ? 'Doanh số'
                : isExpired
                    ? 'Hết hạn'
                    : 'Số lượng bán',
            content: isRevenue
                ? bloc.list[index].revenue.formatPrice(type: 'đ')
                : bloc.list[index].sold.formatPrice(),
            titleStyle: isExpired
                ? s14w400.copyWith(color: AppColors.ultility_red)
                : null,
            isPercent: false,
          ),
        ),
        if (isExpired)
          TextRowDashboard(
            title: 'Cận date',
            content: bloc.list[index].revenue.formatPrice(),
            isPercent: false,
            titleStyle: s14w400.copyWith(color: AppColors.ultility_carrot_60),
          ).padding(sp12.padingHor + sp8.padingVer)
      ],
    );
  }
}
