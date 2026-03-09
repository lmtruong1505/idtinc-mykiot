import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/company/cubit/create_company_cubit/create_company_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/components/bg_widget_dashboard.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:pharmago/shared/utils/get_color_from_gradient.dart';

import '../../../../constants/spacing.dart';
import '../../../blocs/dashboard/brand_bloc.dart';
import '../../../models/local_model.dart';
import 'pie_chart.dart';

// ignore: must_be_immutable
class DrugstoreDashboard extends StatelessWidget {
  TypeCompany type;
  final BrandDashboardBloc bloc;
  DrugstoreDashboard({
    required this.bloc,
    this.type = TypeCompany.drugstore,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandDashboardBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return BgWidgetDashboard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PieChartDashboard(
                size: 300,
                radius: 50,
                centerText: '${bloc.list.length}',
                subText: type.title,
                fontSize: 40,
                dataChart: List.generate(
                  bloc.list.length,
                  (index) => LocalModel(
                    id: bloc.list[index].workspaceId,
                    color: index >= colors.length
                        ? getColorFromGradient(
                            bloc.list[index].totalRevenuePercentage ?? 0,
                            colors,
                            stops: [0, 100],
                          )
                        : colors[index],
                    name: bloc.list[index].name,
                    value: bloc.list[index].totalRevenuePercentage,
                  ),
                ),
              ),
              16.height,
              ...List.generate(
                bloc.list.length,
                (index) => _buildItem(context, index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
  ) {
    final double width = context.width * 0.45;

    final witdthView = bloc.list[index].totalRevenuePercentage.validator > 0
        ? width *
            (bloc.list[index].totalRevenuePercentage.validator /
                bloc.list.first.totalRevenuePercentage.validator)
        : 0;
    return Container(
      width: context.width,
      padding: sp16.padingBottom,
      margin: 16.padingTop,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  bloc.list[index].name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StyleApp.normal(fontSize: 12),
                ),
                18.height,
                RichText(
                  text: TextSpan(
                    text: 'Doanh số: ',
                    style: StyleApp.normal(color: ColorApp.grey, fontSize: 12),
                    children: [
                      TextSpan(
                        text: bloc.list[index].totalRevenue
                            .formatPrice(type: 'đ'),
                        style: StyleApp.semibold(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          sp12.width,
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: sp12,
                      width: witdthView.toDouble(),
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: 2.radius,
                      ),
                    ),
                  ],
                ),
                6.height,
                Text(
                  '${bloc.list[index].totalRevenuePercentage.formatPercent()}% tổng doanh số',
                  overflow: TextOverflow.ellipsis,
                  style: StyleApp.normal(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final colors = [
    ColorApp.redB2,
    ColorApp.red,
    const Color(0xFFFC9F9F),
    const Color(0xFFFCCCC2),
    ColorApp.redF5,
    const Color(0xfffced9ff),
  ];

  Color getColor(double percent) {
    return getColorFromGradient(
      percent,
      [
        ColorApp.redB2,
        ColorApp.red,
        const Color(0xFFFC9F9F),
        const Color(0xFFFCCCC2),
        ColorApp.redF5,
        const Color(0xfffced9ff),
      ],
      stops: [0, 100],
    );
  }
}
