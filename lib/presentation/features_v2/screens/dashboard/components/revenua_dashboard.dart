import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import 'bg_widget_dashboard.dart';

class RevenuaDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BgWidgetDashboard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Doanh số tổng hợp từ các cơ sở',
                style: StyleApp.normal(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ).flexible(),
              4.width,
              Text(
                '+2.5%',
                style: StyleApp.semibold(
                  fontSize: 12,
                  color: ColorApp.green,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              2.width,
              const Icon(Icons.trending_up_outlined,
                size: 15,
                color: ColorApp.green,
              ),
            ],
          ),
          4.height,
          Text(
            '100.000.000đ',
            style: StyleApp.bold(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          4.height,
          Text(
            'So với (50.000.000đ tháng trước)',
            style: StyleApp.normal(
              color: ColorApp.grey,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          sp16.height,
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                _buildChart().size(height: 150),
                Row(
                  children: [
                    _oneSuggest('Tháng này', ColorApp.main),
                    sp12.width,
                    _oneSuggest('Tháng trước', ColorApp.yellowF7),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneSuggest(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: sp4, horizontal: sp8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: ColorApp.greyF5,
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
            style: StyleApp.normal(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final List<ChartClass> chartData = List.generate(
      10,
      (index) => ChartClass(
        day: DateTime.now().copyWith(
          day: index + 1,
        ),
        current: Random().nextDouble() * 10000000,
        last: Random().nextDouble() * 10000000,
      ),
    );

    final double current = chartData.fold(
      0,
      (previousValue, element) => previousValue > element.current.validator
          ? previousValue
          : element.current ?? 0,
    );
    final double last = chartData.fold(
      0,
      (previousValue, element) => previousValue > element.last.validator
          ? previousValue
          : element.last ?? 0,
    );

    final double max = current > last ? current : last;

    final int maxX = chartData.length;

    return LineChart(
      LineChartData(
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
        maxX: maxX.toDouble(),
        minY: 0,
        maxY: max,
        lineBarsData: [
          LineChartBarData(
            spots: chartData
                .map(
                  (e) => FlSpot((e.day?.day ?? 0).toDouble(), e.current ?? 0),
                )
                .toList(),
            isCurved: true,
            color: ColorApp.main,
            barWidth: sp2,
            dotData: const FlDotData(
              show: false,
            ),
          ),
          LineChartBarData(
            spots: chartData
                .map(
                  (e) => FlSpot((e.day?.day ?? 0).toDouble(), e.last ?? 0),
                )
                .toList(),
            isCurved: true,
            color: ColorApp.yellowF7,
            barWidth: sp2,
            dotData: const FlDotData(
              show: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final style = StyleApp.normal(color: ColorApp.grey79);
    Widget text;
    text = Text(
      value.round().toString(),
      style: style,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}

class ChartClass {
  DateTime? day;
  double? current;
  double? last;
  ChartClass({
    this.day,
    this.current,
    this.last,
  });
}
