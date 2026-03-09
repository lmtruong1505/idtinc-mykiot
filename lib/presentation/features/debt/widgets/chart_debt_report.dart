import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_report_entity.dart';

class ChartDebtReportView extends StatefulWidget {
  const ChartDebtReportView({super.key, required this.data});

  final List<DebtReportChartEntity> data;

  @override
  State<ChartDebtReportView> createState() => _ChartDebtReportViewState();
}

class _ChartDebtReportViewState extends State<ChartDebtReportView> {
  late List<FlSpot> sport;
  double maxY = 0;

  @override
  void initState() {
    super.initState();

    sport = widget.data
        .asMap()
        .map(
          (key, value) => MapEntry(
            key,
            FlSpot(
              double.tryParse((key).toString()) ?? 0,
              value.money ?? 0,
            ),
          ),
        )
        .values
        .toList();
    for (final e in widget.data) {
      if ((e.money ?? 0) > maxY) {
        maxY = e.money ?? 0;
      }
    }
  }

  List<Color> gradientColors = [
    mainColor.withOpacity(0.1),
    mainColor.withOpacity(0),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: LineChart(
        mainData(),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = p9.copyWith(color: greyTextColor);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text(DateFormat('d/M').format(widget.data[1].date ?? DateTime.now()), style: style);
        break;
      case 2:
        text = Text(DateFormat('d/M').format(widget.data[2].date ?? DateTime.now()), style: style);
        break;
      case 3:
        text = Text(DateFormat('d/M').format(widget.data[3].date ?? DateTime.now()), style: style);
        break;
      case 4:
        text = Text(DateFormat('d/M').format(widget.data[4].date ?? DateTime.now()), style: style);
        break;
      case 5:
        text = Text(DateFormat('d/M').format(widget.data[5].date ?? DateTime.now()), style: style);
        break;
      case 6:
        text = Text(DateFormat('d/M').format(widget.data[6].date ?? DateTime.now()), style: style);
        break;
      case 7:
        text = Text(DateFormat('d/M').format(widget.data[7].date ?? DateTime.now()), style: style.copyWith(color: mainColor));
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
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
            getTitlesWidget: bottomTitleWidgets,
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
      maxX: 8,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: sport,
          isCurved: false,
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
      ],
    );
  }
}
