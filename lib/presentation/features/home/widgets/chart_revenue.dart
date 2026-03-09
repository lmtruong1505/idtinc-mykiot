import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class ChartRevenueView extends StatefulWidget {
  const ChartRevenueView({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  State<ChartRevenueView> createState() => _ChartRevenueViewState();
}

class _ChartRevenueViewState extends State<ChartRevenueView> {
  late List<FlSpot> sportCurrentData;
  late List<FlSpot> sportLastData;
  double maxY = 0;

  @override
  void initState() {
    super.initState();

    sportCurrentData = widget.cubit.state.revenueItems
        .asMap()
        .map(
          (key, value) => MapEntry(
            key,
            FlSpot(
              double.tryParse((key).toString()) ?? 0,
              value.value ?? 0,
            ),
          ),
        )
        .values
        .toList();

    sportLastData = widget.cubit.state.revenueItems
        .asMap()
        .map(
          (key, value) => MapEntry(
            key,
            FlSpot(
              double.tryParse((key).toString()) ?? 0,
              value.valueExtra ?? 0,
            ),
          ),
        )
        .values
        .toList();
    for (final e in widget.cubit.state.revenueItems) {
      if ((e.value ?? 0) > maxY) {
        maxY = e.value ?? 0;
      }
      if ((e.valueExtra ?? 0) > maxY) {
        maxY = e.valueExtra ?? 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: widget.cubit..reportRevenue(),
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(sp16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Doanh số bán hàng',
                    style: p9.copyWith(color: blackColor),
                  ),
                  gapWidth(sp4),
                  Text(
                    '${widget.cubit.percentDifferent(state.currentRevenue, state.lastRevenue)}%',
                    style: p8.copyWith(
                      color: state.currentRevenue > state.lastRevenue
                          ? green_1
                          : red_1,
                    ),
                  ),
                  gapWidth(sp4),
                  state.currentRevenue > state.lastRevenue
                      ? const Icon(Icons.trending_up_rounded, color: green_1)
                      : const Icon(Icons.trending_down_rounded, color: red_1),
                ],
              ),
              gapHeight(sp8),
              Text(
                '${FormatCurrency(state.currentRevenue)}đ',
                style: h5.copyWith(color: blackColor),
              ),
              gapHeight(sp4),
              Text(
                'So với (${FormatCurrency(state.lastRevenue)}đ tháng trước)',
                style: p9.copyWith(color: greyTextColor),
              ),
              gapHeight(sp16),
              Stack(
                children: [
                  _chart(),
                  Positioned(
                    child: Row(
                      children: [
                        _oneSuggest('Tháng này', mainColor),
                        gapWidth(sp8),
                        _oneSuggest('Tháng trước', yellow_1),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chart() {
    return AspectRatio(
      aspectRatio: 2.5,
      child: LineChart(
        _mainChartData(),
      ),
    );
  }

  LineChartData _mainChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: (widget.cubit.state.revenueItems.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: sportCurrentData,
          isCurved: true,
          color: green_1,
          barWidth: sp2,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            applyCutOffY: false,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors.map((color) => color).toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: sportLastData,
          isCurved: true,
          color: yellow_1,
          barWidth: sp2,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            applyCutOffY: false,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: lastGradientColors.map((color) => color).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> gradientColors = [
    mainColor.withOpacity(0.1),
    mainColor.withOpacity(0),
  ];

  List<Color> lastGradientColors = [
    yellow_1.withOpacity(0.1),
    yellow_1.withOpacity(0),
  ];

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final style = p8.copyWith(color: greyTextColor);
    Widget text;
    text = Text(
      DateFormat('dd')
          .format(widget.cubit.state.revenueItems[value.toInt()].title!),
      style: style,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget _oneSuggest(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: sp4, horizontal: sp8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: bg_4,
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: sp8,
          ),
          gapWidth(sp4),
          Text(
            title,
            style: p7.copyWith(color: blackColor),
          ),
        ],
      ),
    );
  }
}
