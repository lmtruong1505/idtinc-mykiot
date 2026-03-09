import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class ChartOrder extends StatefulWidget {
  const ChartOrder({super.key, required this.cubit});
  final HomeCubit cubit;

  @override
  State<ChartOrder> createState() => _ChartOrderState();
}

class _ChartOrderState extends State<ChartOrder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: widget.cubit..getReportOrder(),
      builder: (context, state) {
      //  print('state.currentOrder: ${state.currentOrder}');
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(sp16).copyWith(top: sp0),
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Đơn hàng',
                        style: p9.copyWith(color: blackColor),
                      ),
                      gapWidth(sp4),
                      Text(
                        '${widget.cubit.percentDifferent(state.currentOrder.toDouble(), state.lastOrder.toDouble())}%',
                        style: p8.copyWith(
                          color: state.currentOrder > state.currentOrder
                              ? green_1
                              : red_1,
                        ),
                      ),
                      gapWidth(sp4),
                      state.currentOrder > state.currentOrder
                          ? const Icon(
                              Icons.trending_up_rounded,
                              color: green_1,
                            )
                          : const Icon(
                              Icons.trending_down_rounded,
                              color: red_1,
                            ),
                    ],
                  ),
                  gapWidth(sp4),
                  Text(
                    state.currentOrder.toString(),
                    style: h5.copyWith(color: blackColor),
                  ),
                  gapWidth(sp4),
                  Text(
                    'So với (${state.lastOrder} tháng trước)',
                    style: p9.copyWith(color: greyTextColor),
                  ),
                ],
              ),
              gapWidth(sp16),
              Expanded(child: _chart),
            ],
          ),
        );
      },
    );
  }

  Widget get _chart => AspectRatio(
        aspectRatio: 2.5,
        child: LineChart(
          _mainChartData(),
        ),
      );

  LineChartData _mainChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: (widget.cubit.state.revenueItems.length - 1).toDouble(),
      minY: 0,
      maxY: 90,
      lineBarsData: [
        // LineChartBarData(
        //   spots: sportCurrentData,
        //   isCurved: true,
        //   color: green_1,
        //   barWidth: sp2,
        //   dotData: const FlDotData(
        //     show: false,
        //   ),
        //   belowBarData: BarAreaData(
        //     show: true,
        //     applyCutOffY: false,
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: gradientColors.map((color) => color).toList(),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  List<Color> gradientColors = [
    mainColor.withOpacity(0.1),
    mainColor.withOpacity(0),
  ];

  // Widget _bottomTitleWidgets(double value, TitleMeta meta) {
  //   final style = p8.copyWith(color: greyTextColor);
  //   Widget text;
  //   text = Text(
  //     DateFormat('dd/MM')
  //         .format(widget.cubit.state.revenueItems[value.toInt()].title!),
  //     style: style,
  //   );
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }
}
